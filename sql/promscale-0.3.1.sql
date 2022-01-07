/* 
This file is auto generated by pgx.

The ordering of items is not stable, it is driven by a dependency graph.
*/

-- src/support.rs:28
-- promscale::support::rewrite_fn_call_to_subquery
CREATE OR REPLACE FUNCTION _prom_ext."rewrite_fn_call_to_subquery"(
	"input" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'rewrite_fn_call_to_subquery_wrapper';

-- src/aggregates/vector_selector.rs:71
-- promscale::aggregates::vector_selector::vector_selector_final
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_final"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS double precision[] /* core::option::Option<alloc::vec::Vec<core::option::Option<f64>>> */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'vector_selector_final_wrapper';

-- src/aggregates/vector_selector.rs:96
-- promscale::aggregates::vector_selector::vector_selector_combine
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_combine"(
	"state1" internal, /* pgx::datum::internal::Internal */
	"state2" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'vector_selector_combine_wrapper';

-- src/aggregates/gapfill_delta.rs:8
-- promscale::aggregates::gapfill_delta::prom_extrapolate_final
CREATE OR REPLACE FUNCTION _prom_ext."prom_extrapolate_final"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS double precision[] /* core::option::Option<alloc::vec::Vec<core::option::Option<f64>>> */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_extrapolate_final_wrapper';

-- src/aggregates/prom_increase.rs:12
-- promscale::aggregates::prom_increase::PromIncrease
CREATE TYPE _prom_ext.PromIncrease;

-- src/aggregates/prom_increase.rs:12
-- promscale::aggregates::prom_increase::promincrease_in
CREATE OR REPLACE FUNCTION _prom_ext."promincrease_in"(
	"input" cstring /* &std::ffi::c_str::CStr */
) RETURNS _prom_ext.PromIncrease /* promscale::aggregates::prom_increase::PromIncrease */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'promincrease_in_wrapper';

-- src/aggregates/prom_increase.rs:12
-- promscale::aggregates::prom_increase::promincrease_out
CREATE OR REPLACE FUNCTION _prom_ext."promincrease_out"(
	"input" _prom_ext.PromIncrease /* promscale::aggregates::prom_increase::PromIncrease */
) RETURNS cstring /* &std::ffi::c_str::CStr */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'promincrease_out_wrapper';

-- src/aggregates/prom_increase.rs:12
-- promscale::aggregates::prom_increase::PromIncrease
CREATE TYPE _prom_ext.PromIncrease (
	INTERNALLENGTH = variable,
	INPUT = _prom_ext.promincrease_in, /* promscale::aggregates::prom_increase::promincrease_in */
	OUTPUT = _prom_ext.promincrease_out, /* promscale::aggregates::prom_increase::promincrease_out */
	STORAGE = extended
);

-- src/aggregates/prom_increase.rs:174
-- promscale::aggregates::prom_increase::prom_increase_finalize
CREATE OR REPLACE FUNCTION _prom_ext."prom_increase_finalize"(
	"this" _prom_ext.PromIncrease /* core::option::Option<promscale::aggregates::prom_increase::PromIncrease> */
) RETURNS double precision[] /* core::option::Option<alloc::vec::Vec<core::option::Option<f64>>> */
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_increase_finalize_wrapper';

-- src/aggregates/gapfill_delta.rs:30
-- promscale::aggregates::gapfill_delta::GapfillDeltaTransition
CREATE TYPE _prom_ext.GapfillDeltaTransition;

-- src/aggregates/gapfill_delta.rs:30
-- promscale::aggregates::gapfill_delta::gapfilldeltatransition_in
CREATE OR REPLACE FUNCTION _prom_ext."gapfilldeltatransition_in"(
	"input" cstring /* &std::ffi::c_str::CStr */
) RETURNS _prom_ext.GapfillDeltaTransition /* promscale::aggregates::gapfill_delta::GapfillDeltaTransition */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'gapfilldeltatransition_in_wrapper';

-- src/aggregates/gapfill_delta.rs:30
-- promscale::aggregates::gapfill_delta::gapfilldeltatransition_out
CREATE OR REPLACE FUNCTION _prom_ext."gapfilldeltatransition_out"(
	"input" _prom_ext.GapfillDeltaTransition /* promscale::aggregates::gapfill_delta::GapfillDeltaTransition */
) RETURNS cstring /* &std::ffi::c_str::CStr */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'gapfilldeltatransition_out_wrapper';

-- src/aggregates/gapfill_delta.rs:30
-- promscale::aggregates::gapfill_delta::GapfillDeltaTransition
CREATE TYPE _prom_ext.GapfillDeltaTransition (
	INTERNALLENGTH = variable,
	INPUT = _prom_ext.gapfilldeltatransition_in, /* promscale::aggregates::gapfill_delta::gapfilldeltatransition_in */
	OUTPUT = _prom_ext.gapfilldeltatransition_out, /* promscale::aggregates::gapfill_delta::gapfilldeltatransition_out */
	STORAGE = extended
);

-- src/schema/setup.rs:6

CREATE OR REPLACE FUNCTION @extschema@.swallow_error(query text) RETURNS VOID AS
$$
BEGIN
    BEGIN
        EXECUTE query;
    EXCEPTION WHEN duplicate_object THEN
        RAISE NOTICE 'object already exists, skipping create';
    END;
END;
$$
LANGUAGE PLPGSQL;

SELECT swallow_error('CREATE ROLE prom_reader;');
SELECT swallow_error('CREATE DOMAIN @extschema@.matcher_positive AS int[] NOT NULL;');
SELECT swallow_error('CREATE DOMAIN @extschema@.matcher_negative AS int[] NOT NULL;');
SELECT swallow_error('CREATE DOMAIN @extschema@.label_key AS TEXT NOT NULL;');
SELECT swallow_error('CREATE DOMAIN @extschema@.pattern AS TEXT NOT NULL;');

DROP FUNCTION @extschema@.swallow_error(text);

--security definer function that allows setting metadata with the promscale_prefix
CREATE OR REPLACE FUNCTION @extschema@.update_tsprom_metadata(meta_key text, meta_value text, send_telemetry BOOLEAN)
RETURNS VOID
AS $func$
    INSERT INTO _timescaledb_catalog.metadata(key, value, include_in_telemetry)
    VALUES ('promscale_' || meta_key,meta_value, send_telemetry)
    ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, include_in_telemetry = EXCLUDED.include_in_telemetry
$func$
LANGUAGE SQL VOLATILE SECURITY DEFINER;


-- src/support.rs:88
-- requires:
--   rewrite_fn_call_to_subquery
--   promscale_setup

GRANT EXECUTE ON FUNCTION @extschema@.rewrite_fn_call_to_subquery(internal) TO prom_reader;

-- src/schema/support.rs:12
-- requires:
--   promscale_setup


CREATE OR REPLACE FUNCTION @extschema@.label_find_key_equal(key_to_match label_key, pat pattern)
RETURNS matcher_positive
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_positive
    FROM label l
    WHERE l.key = key_to_match and l.value = pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.rewrite_fn_call_to_subquery;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_not_equal(key_to_match label_key, pat pattern)
RETURNS matcher_negative
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_negative
    FROM label l
    WHERE l.key = key_to_match and l.value = pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.rewrite_fn_call_to_subquery;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_regex(key_to_match label_key, pat pattern)
RETURNS matcher_positive
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_positive
    FROM label l
    WHERE l.key = key_to_match and l.value ~ pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.rewrite_fn_call_to_subquery;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_not_regex(key_to_match label_key, pat pattern)
RETURNS matcher_negative
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_negative
    FROM label l
    WHERE l.key = key_to_match and l.value ~ pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.rewrite_fn_call_to_subquery;



-- src/schema/support.rs:70
-- requires:
--   attach_support_to_label_find_key_equal


CREATE OPERATOR @extschema@.== (
    LEFTARG = label_key,
    RIGHTARG = pattern,
    FUNCTION = @extschema@.label_find_key_equal
);

CREATE OPERATOR @extschema@.!== (
    LEFTARG = label_key,
    RIGHTARG = pattern,
    FUNCTION = @extschema@.label_find_key_not_equal
);

CREATE OPERATOR @extschema@.==~ (
    LEFTARG = label_key,
    RIGHTARG = pattern,
    FUNCTION = @extschema@.label_find_key_regex
);

CREATE OPERATOR @extschema@.!=~ (
    LEFTARG = label_key,
    RIGHTARG = pattern,
    FUNCTION = @extschema@.label_find_key_not_regex
);


-- src/schema/support.rs:59
-- requires:
--   attach_support_to_label_find_key_equal
--   promscale_setup


GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_equal(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_not_equal(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_regex(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_not_regex(label_key, pattern) TO prom_reader;


-- src/raw.rs:6
-- creates:
--   Type(promscale::raw::bytea)
--   Type(promscale::raw::TimestampTz)



-- src/aggregates/vector_selector.rs:90
-- promscale::aggregates::vector_selector::vector_selector_deserialize
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_deserialize"(
	"bytes" bytea, /* promscale::raw::bytea */
	"_internal" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'vector_selector_deserialize_wrapper';

-- src/aggregates/vector_selector.rs:21
-- promscale::aggregates::vector_selector::vector_selector_transition
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"start_time" TimestampTz, /* promscale::raw::TimestampTz */
	"end_time" TimestampTz, /* promscale::raw::TimestampTz */
	"bucket_width" bigint, /* i64 */
	"lookback" bigint, /* i64 */
	"time" TimestampTz, /* promscale::raw::TimestampTz */
	"value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'vector_selector_transition_wrapper';

-- src/aggregates/vector_selector.rs:79
-- promscale::aggregates::vector_selector::vector_selector_serialize
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_serialize"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS bytea /* promscale::raw::bytea */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'vector_selector_serialize_wrapper';

-- src/aggregates/vector_selector.rs:137
-- requires:
--   vector_selector_transition
--   vector_selector_final
--   vector_selector_combine
--   vector_selector_serialize
--   vector_selector_deserialize


CREATE AGGREGATE @extschema@.vector_selector(
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    bucket_width BIGINT,
    lookback BIGINT,
    sample_time TIMESTAMPTZ,
    sample_value DOUBLE PRECISION)
(
    sfunc = vector_selector_transition,
    stype = internal,
    finalfunc = vector_selector_final,
    combinefunc = vector_selector_combine,
    serialfunc = vector_selector_serialize,
    deserialfunc = vector_selector_deserialize,
    parallel = safe
);


-- src/aggregates/prom_delta.rs:17
-- promscale::aggregates::prom_delta::prom_delta_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_delta_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"greatest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" TimestampTz, /* promscale::raw::TimestampTz */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_delta_transition_wrapper';

-- src/aggregates/prom_rate.rs:11
-- promscale::aggregates::prom_rate::prom_rate_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_rate_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"greatest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" TimestampTz, /* promscale::raw::TimestampTz */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_rate_transition_wrapper';

-- src/aggregates/prom_rate.rs:89
-- requires:
--   prom_rate_transition
--   prom_extrapolate_final


CREATE AGGREGATE @extschema@.prom_rate(
    lowest_time TIMESTAMPTZ,
    greatest_time TIMESTAMPTZ,
    step_size BIGINT,
    range BIGINT,
    sample_time TIMESTAMPTZ,
    sample_value DOUBLE PRECISION)
(
    sfunc=@extschema@.prom_rate_transition,
    stype=internal,
    finalfunc=@extschema@.prom_extrapolate_final
);


-- src/aggregates/prom_increase.rs:174
-- promscale::aggregates::prom_increase::prom_increase_state
CREATE OR REPLACE FUNCTION _prom_ext."prom_increase_state"(
	"this" _prom_ext.PromIncrease, /* core::option::Option<promscale::aggregates::prom_increase::PromIncrease> */
	"arg_one" TimestampTz, /* promscale::raw::TimestampTz */
	"arg_two" TimestampTz, /* promscale::raw::TimestampTz */
	"arg_three" bigint, /* i64 */
	"arg_four" bigint, /* i64 */
	"arg_five" TimestampTz, /* promscale::raw::TimestampTz */
	"arg_six" double precision /* f64 */
) RETURNS _prom_ext.PromIncrease /* core::option::Option<promscale::aggregates::prom_increase::PromIncrease> */
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_increase_state_wrapper';

-- src/aggregates/prom_increase.rs:174
-- promscale::aggregates::prom_increase::PromIncrease
CREATE AGGREGATE _prom_ext.test_agg (
	TimestampTz, /* promscale::raw::TimestampTz */
	TimestampTz, /* promscale::raw::TimestampTz */
	bigint, /* i64 */
	bigint, /* i64 */
	TimestampTz, /* promscale::raw::TimestampTz */
	double precision /* f64 */
)
(
	SFUNC = _prom_ext."prom_increase_state",
	STYPE = _prom_ext.PromIncrease,
	FINALFUNC = _prom_ext."prom_increase_finalize"
);

-- src/aggregates/prom_increase.rs:206
-- promscale::aggregates::prom_increase::prom_increase_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_increase_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"greatest_time" TimestampTz, /* promscale::raw::TimestampTz */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" TimestampTz, /* promscale::raw::TimestampTz */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS 'MODULE_PATHNAME', 'prom_increase_transition_wrapper';

-- src/aggregates/prom_increase.rs:283
-- requires:
--   prom_increase_transition
--   prom_extrapolate_final


CREATE AGGREGATE @extschema@.prom_increase(
    lowest_time TIMESTAMPTZ,
    greatest_time TIMESTAMPTZ,
    step_size BIGINT,
    range BIGINT,
    sample_time TIMESTAMPTZ,
    sample_value DOUBLE PRECISION)
(
    sfunc=@extschema@.prom_increase_transition,
    stype=internal,
    finalfunc=@extschema@.prom_extrapolate_final
);


-- src/aggregates/prom_delta.rs:103
-- requires:
--   prom_delta_transition
--   prom_extrapolate_final


CREATE AGGREGATE @extschema@.prom_delta(
    lowest_time TIMESTAMPTZ,
    greatest_time TIMESTAMPTZ,
    step_size BIGINT,
    range BIGINT,
    sample_time TIMESTAMPTZ,
    sample_value DOUBLE PRECISION)
(
    sfunc=@extschema@.prom_delta_transition,
    stype=internal,
    finalfunc=@extschema@.prom_extrapolate_final
);


-- src/schema/estimates.rs:23
-- requires:
--   promscale_setup


CREATE OR REPLACE FUNCTION @extschema@.label_unnest(label_array anyarray)
RETURNS SETOF anyelement
LANGUAGE internal
IMMUTABLE PARALLEL SAFE STRICT ROWS 10
AS $function$array_unnest$function$;
GRANT EXECUTE ON FUNCTION @extschema@.label_unnest(anyarray) TO prom_reader;
    

-- src/schema/estimates.rs:9
-- requires:
--   promscale_setup


CREATE OR REPLACE FUNCTION @extschema@.label_jsonb_each_text(js jsonb, OUT key text, OUT value text)
    RETURNS SETOF record
    LANGUAGE internal
    IMMUTABLE PARALLEL SAFE STRICT ROWS 10
AS $function$jsonb_each_text$function$;
GRANT EXECUTE ON FUNCTION @extschema@.label_jsonb_each_text(jsonb) TO prom_reader;
    
