use std::collections::VecDeque;
use pgx::error;
use pgx::Internal;
use pgx::*;
use serde::{Deserialize, Serialize};

use crate::aggregate_utils::in_aggregate_context;
use crate::aggregates::{GapfillDeltaTransition, Microseconds, Milliseconds, STALE_NAN, USECS_PER_MS, USECS_PER_SEC};
use crate::palloc::{Inner, InternalAsValue, ToInternal};
use crate::raw::TimestampTz;

#[derive(Serialize, Deserialize, PostgresType, Debug)]
pub struct PromIncrease {
    window: VecDeque<(pg_sys::TimestampTz, f64)>,
    // a Datum for each index in the array, 0 by convention if the value is NULL
    deltas: Vec<Option<f64>>,
    current_window_max: pg_sys::TimestampTz,
    current_window_min: pg_sys::TimestampTz,
    step_size: Microseconds,
    range: Microseconds,
    greatest_time: pg_sys::TimestampTz,
    is_counter: bool,
    is_rate: bool,
}

impl PromIncrease {
    pub fn new(
        lowest_time: pg_sys::TimestampTz,
        greatest_time: pg_sys::TimestampTz,
        range: Milliseconds,
        step_size: Milliseconds,
        is_counter: bool,
        is_rate: bool,
    ) -> Self {
        let mut expected_deltas = (greatest_time - lowest_time) / (step_size * USECS_PER_MS);
        if (greatest_time - lowest_time) % (step_size * USECS_PER_MS) != 0 {
            expected_deltas += 1
        }
        PromIncrease {
            window: VecDeque::default(),
            deltas: Vec::with_capacity(expected_deltas as usize),
            current_window_max: lowest_time + range * USECS_PER_MS,
            current_window_min: lowest_time,
            step_size: step_size * USECS_PER_MS,
            range: range * USECS_PER_MS,
            greatest_time,
            is_counter,
            is_rate,
        }
    }

    pub(crate) fn add_data_point(&mut self, time: pg_sys::TimestampTz, val: f64) {
        // skip stale NaNs
        if val.to_bits() == STALE_NAN {
            return;
        };

        while !self.in_current_window(time) {
            self.flush_current_window()
        }

        if self.window.back().map_or(false, |(prev, _)| *prev > time) {
            error!("inputs must be in ascending time order")
        }
        if time >= self.current_window_min {
            self.window.push_back((time, val));
        }
    }

    fn in_current_window(&self, time: pg_sys::TimestampTz) -> bool {
        time <= self.current_window_max
    }

    fn flush_current_window(&mut self) {
        self.add_delta_for_current_window();

        self.current_window_min += self.step_size;
        self.current_window_max += self.step_size;

        let current_window_min = self.current_window_min;
        while self
            .window
            .front()
            .map_or(false, |(time, _)| *time < current_window_min)
        {
            self.window.pop_front();
        }
    }


    //based on extrapolatedRate
    // https://github.com/prometheus/prometheus/blob/e5ffa8c9a08a5ee4185271c8c26051ddc1388b7a/promql/functions.go#L59
    fn add_delta_for_current_window(&mut self) {
        if self.window.len() < 2 {
            // if there are 1 or fewer values in the window, store NULL
            self.deltas.push(None);
            return;
        }

        let mut counter_correction = 0.0;
        if self.is_counter {
            let mut last_value = 0.0;
            for (_, sample) in &self.window {
                if *sample < last_value {
                    counter_correction += last_value
                }
                last_value = *sample
            }
        }

        let (latest_time, latest_val) = self.window.back().cloned().unwrap();
        let (earliest_time, earliest_val) = self.window.front().cloned().unwrap();
        let mut result_val = latest_val - earliest_val + counter_correction;

        // all calculated durations and interval are in seconds
        let mut duration_to_start =
            (earliest_time - self.current_window_min) as f64 / USECS_PER_SEC as f64;
        let duration_to_end = (self.current_window_max - latest_time) as f64 / USECS_PER_SEC as f64;

        let sampled_interval = (latest_time - earliest_time) as f64 / USECS_PER_SEC as f64;
        let avg_duration_between_samples = sampled_interval as f64 / (self.window.len() - 1) as f64;

        if self.is_counter && result_val > 0.0 && earliest_val >= 0.0 {
            // Counters cannot be negative. If we have any slope at
            // all (i.e. result_val went up), we can extrapolate
            // the zero point of the counter. If the duration to the
            // zero point is shorter than the durationToStart, we
            // take the zero point as the start of the series,
            // thereby avoiding extrapolation to negative counter
            // values.
            let duration_to_zero = sampled_interval * (earliest_val / result_val);
            if duration_to_zero < duration_to_start {
                duration_to_start = duration_to_zero
            }
        }

        // If the first/last samples are close to the boundaries of the range,
        // extrapolate the result. This is as we expect that another sample
        // will exist given the spacing between samples we've seen thus far,
        // with an allowance for noise.

        let extrapolation_threshold = avg_duration_between_samples * 1.1;
        let mut extrapolate_to_interval = sampled_interval;

        if duration_to_start < extrapolation_threshold {
            extrapolate_to_interval += duration_to_start;
        } else {
            extrapolate_to_interval += avg_duration_between_samples / 2.0;
        }

        if duration_to_end < extrapolation_threshold {
            extrapolate_to_interval += duration_to_end;
        } else {
            extrapolate_to_interval += avg_duration_between_samples / 2.0;
        }

        result_val *= extrapolate_to_interval / sampled_interval;

        if self.is_rate {
            result_val /= (self.range / USECS_PER_SEC) as f64;
        }

        self.deltas.push(Some(result_val));
    }

    pub fn as_vec(&mut self) -> Vec<Option<f64>> {
        while self.current_window_max <= self.greatest_time {
            self.flush_current_window();
        }
        self.deltas.clone()
    }
}

#[pg_aggregate]
impl Aggregate for PromIncrease {
    type State = Option<Self>;
    type Args = (TimestampTz, TimestampTz, Milliseconds, Milliseconds, TimestampTz, f64);
    type Finalize = Option<Vec<Option<f64>>>;

    const NAME: &'static str = "prom_increase";

    fn state(mut state: Self::State, args: Self::Args) -> Self::State {
        let (lowest_time, greatest_time, step_size, range, sample_time, sample_value) = args;
        // TODO: Missing in_aggregate_context magic
        let mut state = state.unwrap_or_else(|| {
            PromIncrease::new(
                lowest_time.into(),
                greatest_time.into(),
                range,
                step_size,
                true,
                false,
            )
        });

        state.add_data_point(sample_time.into(), sample_value);
        Some(state)
    }

    fn finalize(current: Self::State) -> Self::Finalize {
        current.map(|mut s| s.as_vec())
    }
}

// #[allow(clippy::too_many_arguments)]
// #[pg_extern(immutable, parallel_safe)]
// pub fn prom_increase_transition(
//     state: Internal,
//     lowest_time: TimestampTz,
//     greatest_time: TimestampTz,
//     step_size: Milliseconds, // `prev_now - step_size` is where the next window starts
//     range: Milliseconds,     // the size of a window to delta over
//     sample_time: TimestampTz,
//     sample_value: f64,
//     fc: pg_sys::FunctionCallInfo,
// ) -> Internal {
//     prom_increase_transition_inner(
//         unsafe { state.to_inner() },
//         lowest_time.into(),
//         greatest_time.into(),
//         step_size,
//         range,
//         sample_time.into(),
//         sample_value,
//         fc,
//     )
//     .internal()
// }
//
// #[allow(clippy::too_many_arguments)]
// fn prom_increase_transition_inner(
//     state: Option<Inner<GapfillDeltaTransition>>,
//     lowest_time: pg_sys::TimestampTz,
//     greatest_time: pg_sys::TimestampTz,
//     step_size: Milliseconds, // `prev_now - step` is where the next window starts
//     range: Milliseconds,     // the size of a window to delta over
//     sample_time: pg_sys::TimestampTz,
//     sample_value: f64,
//     fc: pg_sys::FunctionCallInfo,
// ) -> Option<Inner<GapfillDeltaTransition>> {
//     unsafe {
//         in_aggregate_context(fc, || {
//             if sample_time < lowest_time || sample_time > greatest_time {
//                 error!("input time less than lowest time")
//             }
//
//             let mut state = state.unwrap_or_else(|| {
//                 let state: Inner<_> = GapfillDeltaTransition::new(
//                     lowest_time,
//                     greatest_time,
//                     range,
//                     step_size,
//                     true,
//                     false,
//                 )
//                 .into();
//                 state
//             });
//
//             state.add_data_point(sample_time, sample_value);
//
//             Some(state)
//         })
//     }
// }
//
// /// Backwards compatibility
// #[no_mangle]
// pub extern "C" fn pg_finfo_gapfill_increase_transition() -> &'static pg_sys::Pg_finfo_record {
//     const V1_API: pg_sys::Pg_finfo_record = pg_sys::Pg_finfo_record { api_version: 1 };
//     &V1_API
// }
//
// #[no_mangle]
// unsafe extern "C" fn gapfill_increase_transition(
//     fcinfo: pg_sys::FunctionCallInfo,
// ) -> pg_sys::Datum {
//     prom_increase_transition_wrapper(fcinfo)
// }
//
// // implementation of prometheus increase function
// // for proper behavior the input must be ORDER BY sample_time
// extension_sql!(
//     r#"
// CREATE AGGREGATE @extschema@.prom_increase(
//     lowest_time TIMESTAMPTZ,
//     greatest_time TIMESTAMPTZ,
//     step_size BIGINT,
//     range BIGINT,
//     sample_time TIMESTAMPTZ,
//     sample_value DOUBLE PRECISION)
// (
//     sfunc=@extschema@.prom_increase_transition,
//     stype=internal,
//     finalfunc=@extschema@.prom_extrapolate_final
// );
// "#,
//     name = "create_prom_increase_aggregate",
//     requires = [prom_increase_transition, prom_extrapolate_final]
// );

#[cfg(any(test, feature = "pg_test"))]
#[pg_schema]
mod tests {

    use pgx::*;

    #[pg_test]
    fn test_prom_increase_basic_50m() {
        Spi::run(
            r#"
            CREATE TABLE gfi_test_table(t TIMESTAMPTZ, v DOUBLE PRECISION);
            INSERT INTO gfi_test_table (t, v) VALUES
                ('2000-01-02T15:00:00+00:00',0),
                ('2000-01-02T15:05:00+00:00',10),
                ('2000-01-02T15:10:00+00:00',20),
                ('2000-01-02T15:15:00+00:00',30),
                ('2000-01-02T15:20:00+00:00',40),
                ('2000-01-02T15:25:00+00:00',50),
                ('2000-01-02T15:30:00+00:00',60),
                ('2000-01-02T15:35:00+00:00',70),
                ('2000-01-02T15:40:00+00:00',80),
                ('2000-01-02T15:45:00+00:00',90),
                ('2000-01-02T15:50:00+00:00',100);
        "#,
        );

        let result = Spi::get_one::<Vec<f64>>(
            "SELECT prom_increase('2000-01-02T15:00:00+00:00'::TIMESTAMPTZ, '2000-01-02T15:50:00+00:00'::TIMESTAMPTZ, 50 * 60 * 1000, 50 * 60 * 1000, t, v order by t) FROM gfi_test_table"
        ).expect("SQL guery failed");
        assert_eq!(result, vec![100_f64]);
    }

    #[pg_test]
    fn test_prom_increase_basic_reset_zero() {
        Spi::run(
            r#"
            CREATE TABLE gfi_test_table(t TIMESTAMPTZ, v DOUBLE PRECISION);
            INSERT INTO gfi_test_table (t, v) VALUES
                ('2000-01-02T15:00:00+00:00',0),
                ('2000-01-02T15:05:00+00:00',10),
                ('2000-01-02T15:10:00+00:00',20),
                ('2000-01-02T15:15:00+00:00',30),
                ('2000-01-02T15:20:00+00:00',40),
                ('2000-01-02T15:25:00+00:00',50),
                ('2000-01-02T15:30:00+00:00',0),
                ('2000-01-02T15:35:00+00:00',10),
                ('2000-01-02T15:40:00+00:00',20),
                ('2000-01-02T15:45:00+00:00',30),
                ('2000-01-02T15:50:00+00:00',40);
        "#,
        );

        let result = Spi::get_one::<Vec<f64>>(
            "SELECT prom_increase('2000-01-02T15:00:00+00:00'::TIMESTAMPTZ, '2000-01-02T15:50:00+00:00'::TIMESTAMPTZ, 50 * 60 * 1000, 50 * 60 * 1000, t, v order by t) FROM gfi_test_table;"
        ).expect("SQL query failed");
        assert_eq!(result, vec![90_f64]);
    }

    #[pg_test]
    fn test_prom_increase_counter_reset_nonzero() {
        Spi::run(
            r#"
            CREATE TABLE gfi_test_table(t TIMESTAMPTZ, v DOUBLE PRECISION);
            INSERT INTO gfi_test_table (t, v) VALUES
                ('2000-01-02T15:00:00+00:00',0),
                ('2000-01-02T15:05:00+00:00',1),
                ('2000-01-02T15:10:00+00:00',2),
                ('2000-01-02T15:15:00+00:00',3),
                ('2000-01-02T15:20:00+00:00',2),
                ('2000-01-02T15:25:00+00:00',3),
                ('2000-01-02T15:30:00+00:00',4);
        "#,
        );
        let result =
            Spi::get_one::<Vec<f64>>(
            "SELECT prom_increase('2000-01-02T15:00:00+00:00'::TIMESTAMPTZ, '2000-01-02T15:30:00+00:00'::TIMESTAMPTZ, 30 * 60 * 1000, 30 * 60 * 1000, t, v order by t) FROM gfi_test_table;"
            ).expect("SQL select failed");
        assert_eq!(result, vec![7_f64]);
    }
}
