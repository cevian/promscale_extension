--
--This section handles moving objects that were previously unpackaged
--under control of the extension.
--

-- Originally defined in pkg/pgmodel/migrate.go
ALTER EXTENSION promscale ADD TABLE public.prom_schema_migrations;

-- 001/002
ALTER EXTENSION promscale ADD SCHEMA _prom_catalog;
ALTER EXTENSION promscale ADD SCHEMA prom_api;
ALTER EXTENSION promscale ADD SCHEMA prom_series;
ALTER EXTENSION promscale ADD SCHEMA prom_metric;
ALTER EXTENSION promscale ADD SCHEMA prom_data;
ALTER EXTENSION promscale ADD SCHEMA prom_data_series;
ALTER EXTENSION promscale ADD SCHEMA prom_info;
ALTER EXTENSION promscale ADD SCHEMA prom_data_exemplar;
ALTER EXTENSION promscale ADD SCHEMA ps_tag;
ALTER EXTENSION promscale ADD SCHEMA _ps_trace;
ALTER EXTENSION promscale ADD SCHEMA ps_trace;
ALTER EXTENSION promscale ADD SCHEMA _ps_catalog;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.remote_commands;
ALTER EXTENSION promscale ADD PROCEDURE _prom_catalog.execute_everywhere(text, text, boolean);
ALTER EXTENSION promscale ADD PROCEDURE _prom_catalog.update_execute_everywhere_entry(text, text, boolean);
-- 003
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_jsonb_path_exists;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_regexp_matches;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_regexp_not_matches;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_equals;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_not_equals;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_less_than;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_less_than_or_equal;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_greater_than;
ALTER EXTENSION promscale ADD TYPE ps_tag.tag_op_greater_than_or_equal;
-- 004
ALTER EXTENSION promscale ADD DOMAIN prom_api.label_array;
ALTER EXTENSION promscale ADD DOMAIN prom_api.label_value_array;
ALTER EXTENSION promscale ADD TABLE public.prom_installation_info;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.series;
ALTER EXTENSION promscale ADD SEQUENCE _prom_catalog.series_id;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.label;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.ids_epoch;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.label_key;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.label_key_position;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.metric;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.default;
-- 005
ALTER EXTENSION promscale ADD DOMAIN prom_api.matcher_positive;
ALTER EXTENSION promscale ADD DOMAIN prom_api.matcher_negative;
ALTER EXTENSION promscale ADD DOMAIN prom_api.label_key;
ALTER EXTENSION promscale ADD DOMAIN prom_api.pattern;
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_jsonb_each_text(jsonb, out text, out text);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.count_jsonb_keys(jsonb);
ALTER EXTENSION promscale ADD FUNCTION prom_api.matcher(jsonb);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_contains(prom_api.label_array, jsonb);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_value_contains(prom_api.label_value_array, text);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_match(prom_api.label_array, prom_api.matcher_positive);
ALTER EXTENSION promscale ADD OPERATOR prom_api.?(prom_api.label_array, prom_api.matcher_positive);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_match(prom_api.label_array, prom_api.matcher_negative);
ALTER EXTENSION promscale ADD OPERATOR prom_api.?(prom_api.label_array, prom_api.matcher_negative);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_find_key_equal(prom_api.label_key, prom_api.pattern);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_find_key_not_equal(prom_api.label_key, prom_api.pattern);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_find_key_regex(prom_api.label_key, prom_api.pattern);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.label_find_key_not_regex(prom_api.label_key, prom_api.pattern);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.match_equals(prom_api.label_array, ps_tag.tag_op_equals);
ALTER EXTENSION promscale ADD OPERATOR _prom_catalog.?(prom_api.label_array, ps_tag.tag_op_equals);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.match_not_equals(prom_api.label_array, ps_tag.tag_op_not_equals);
ALTER EXTENSION promscale ADD OPERATOR _prom_catalog.?(prom_api.label_array, ps_tag.tag_op_not_equals);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.match_regexp_matches(prom_api.label_array, ps_tag.tag_op_regexp_matches);
ALTER EXTENSION promscale ADD OPERATOR _prom_catalog.?(prom_api.label_array, ps_tag.tag_op_regexp_matches);
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.match_regexp_not_matches(prom_api.label_array, ps_tag.tag_op_regexp_not_matches);
ALTER EXTENSION promscale ADD OPERATOR _prom_catalog.?(prom_api.label_array, ps_tag.tag_op_regexp_not_matches);
-- 006
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.get_timescale_major_version();
ALTER EXTENSION promscale ADD PROCEDURE _prom_catalog.execute_maintenance_job(int, jsonb);
-- 007
ALTER EXTENSION promscale ADD TABLE _prom_catalog.ha_leases;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.ha_leases_logs;
ALTER EXTENSION promscale ADD FUNCTION _prom_catalog.ha_leases_audit_fn();
-- 008
ALTER EXTENSION promscale ADD TABLE _prom_catalog.metadata;
-- 009
ALTER EXTENSION promscale ADD TABLE _prom_catalog.exemplar_label_key_position;
ALTER EXTENSION promscale ADD TABLE _prom_catalog.exemplar;
-- 010
ALTER EXTENSION promscale ADD DOMAIN ps_trace.trace_id;
ALTER EXTENSION promscale ADD DOMAIN ps_trace.tag_k;
ALTER EXTENSION promscale ADD DOMAIN ps_trace.tag_v;
ALTER EXTENSION promscale ADD DOMAIN ps_trace.tag_map;
ALTER EXTENSION promscale ADD DOMAIN ps_trace.tag_type;
ALTER EXTENSION promscale ADD TYPE ps_trace.span_kind;
ALTER EXTENSION promscale ADD TYPE ps_trace.status_code;
ALTER EXTENSION promscale ADD TYPE _ps_trace.tag_key;
ALTER EXTENSION promscale ADD TYPE _ps_trace.tag;
DO $block$
DECLARE
    _i bigint;
    _max bigint = 64;
BEGIN
    FOR _i IN 1.._max
    LOOP
        EXECUTE format($sql$
            ALTER EXTENSION promscale ADD TABLE _ps_trace.tag_%s;
            $sql$, _i);
    END LOOP;
END
$block$
;
ALTER EXTENSION promscale ADD TABLE _ps_trace.operation;
ALTER EXTENSION promscale ADD TABLE _ps_trace.schema_url;
ALTER EXTENSION promscale ADD TABLE _ps_trace.instrumentation_lib;
ALTER EXTENSION promscale ADD TABLE _ps_trace.span;
ALTER EXTENSION promscale ADD TABLE _ps_trace.event;
ALTER EXTENSION promscale ADD TABLE _ps_trace.link;
-- 012
ALTER EXTENSION promscale ADD TABLE _ps_catalog.promscale_instance_information;

-- migration-table.sql
CREATE TABLE IF NOT EXISTS _ps_catalog.migration(
  name TEXT NOT NULL PRIMARY KEY
, applied_at_version TEXT
, applied_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Bring migrations table up to speed
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('001-utils.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('002-users.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('003-schemas.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('004-tag-operators.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('005-tables.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('006-matcher-operators.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('007-install-uda.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('008-tables-ha.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('009-tables-metadata.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('010-tables-exemplar.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('011-tracing.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('012-tracing-well-known-tags.sql', '0.5.0');
INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES ('013-telemetry.sql', '0.5.0');

--
-- From this point forward, proceed as if all migrations have already been run
--

/* 
This file is auto generated by pgx.

The ordering of items is not stable, it is driven by a dependency graph.
*/

-- src/util.rs:4
-- promscale::util::num_cpus
CREATE OR REPLACE FUNCTION _prom_ext."num_cpus"() RETURNS integer /* i32 */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'num_cpus_wrapper';

-- src/support.rs:28
-- promscale::support::rewrite_fn_call_to_subquery
CREATE OR REPLACE FUNCTION _prom_ext."rewrite_fn_call_to_subquery"(
	"input" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE STRICT
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'rewrite_fn_call_to_subquery_wrapper';

-- src/aggregates/vector_selector.rs:71
-- promscale::aggregates::vector_selector::vector_selector_final
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_final"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS double precision[] /* core::option::Option<alloc::vec::Vec<core::option::Option<f64>>> */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'vector_selector_final_wrapper';

-- src/aggregates/vector_selector.rs:21
-- promscale::aggregates::vector_selector::vector_selector_transition
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"start_time" timestamp with time zone, /* i64 */
	"end_time" timestamp with time zone, /* i64 */
	"bucket_width" bigint, /* i64 */
	"lookback" bigint, /* i64 */
	"time" timestamp with time zone, /* i64 */
	"value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'vector_selector_transition_wrapper';

-- src/aggregates/vector_selector.rs:96
-- promscale::aggregates::vector_selector::vector_selector_combine
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_combine"(
	"state1" internal, /* pgx::datum::internal::Internal */
	"state2" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'vector_selector_combine_wrapper';

-- src/aggregates/prom_rate.rs:10
-- promscale::aggregates::prom_rate::prom_rate_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_rate_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" timestamp with time zone, /* i64 */
	"greatest_time" timestamp with time zone, /* i64 */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" timestamp with time zone, /* i64 */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'prom_rate_transition_wrapper';

-- src/aggregates/prom_increase.rs:10
-- promscale::aggregates::prom_increase::prom_increase_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_increase_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" timestamp with time zone, /* i64 */
	"greatest_time" timestamp with time zone, /* i64 */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" timestamp with time zone, /* i64 */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'prom_increase_transition_wrapper';

-- src/aggregates/prom_delta.rs:16
-- promscale::aggregates::prom_delta::prom_delta_transition
CREATE OR REPLACE FUNCTION _prom_ext."prom_delta_transition"(
	"state" internal, /* pgx::datum::internal::Internal */
	"lowest_time" timestamp with time zone, /* i64 */
	"greatest_time" timestamp with time zone, /* i64 */
	"step_size" bigint, /* i64 */
	"range" bigint, /* i64 */
	"sample_time" timestamp with time zone, /* i64 */
	"sample_value" double precision /* f64 */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'prom_delta_transition_wrapper';

-- src/aggregates/gapfill_delta.rs:7
-- promscale::aggregates::gapfill_delta::prom_extrapolate_final
CREATE OR REPLACE FUNCTION _prom_ext."prom_extrapolate_final"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS double precision[] /* core::option::Option<alloc::vec::Vec<core::option::Option<f64>>> */
IMMUTABLE PARALLEL SAFE
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'prom_extrapolate_final_wrapper';

-- src/aggregates/gapfill_delta.rs:29
-- promscale::aggregates::gapfill_delta::GapfillDeltaTransition
-- Skipped due to `#[pgx(sql = false)]`


-- src/aggregates/prom_rate.rs:88
-- requires:
--   prom_rate_transition
--   prom_extrapolate_final


CREATE OR REPLACE AGGREGATE @extschema@.prom_rate(
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

-- src/schema/estimates.rs:9
-- requires:
--   promscale_setup


CREATE OR REPLACE FUNCTION @extschema@.label_jsonb_each_text(js jsonb, OUT key text, OUT value text)
    RETURNS SETOF record
    LANGUAGE internal
    IMMUTABLE PARALLEL SAFE STRICT ROWS 10
AS $function$jsonb_each_text$function$;
GRANT EXECUTE ON FUNCTION @extschema@.label_jsonb_each_text(jsonb) TO prom_reader;
    

-- src/aggregates/prom_delta.rs:102
-- requires:
--   prom_delta_transition
--   prom_extrapolate_final


CREATE OR REPLACE AGGREGATE @extschema@.prom_delta(
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


-- src/raw.rs:6
-- creates:
--   Type(promscale::raw::bytea)
--   Type(promscale::raw::TimestampTz)



-- src/aggregates/vector_selector.rs:79
-- promscale::aggregates::vector_selector::vector_selector_serialize
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_serialize"(
	"state" internal /* pgx::datum::internal::Internal */
) RETURNS bytea /* promscale::raw::bytea */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'vector_selector_serialize_wrapper';

-- src/aggregates/vector_selector.rs:90
-- promscale::aggregates::vector_selector::vector_selector_deserialize
CREATE OR REPLACE FUNCTION _prom_ext."vector_selector_deserialize"(
	"bytes" bytea, /* promscale::raw::bytea */
	"_internal" internal /* pgx::datum::internal::Internal */
) RETURNS internal /* pgx::datum::internal::Internal */
IMMUTABLE PARALLEL SAFE STRICT
LANGUAGE c /* Rust */
AS '$libdir/promscale-0.5.0', 'vector_selector_deserialize_wrapper';

-- src/aggregates/vector_selector.rs:137
-- requires:
--   vector_selector_transition
--   vector_selector_final
--   vector_selector_combine
--   vector_selector_serialize
--   vector_selector_deserialize


CREATE OR REPLACE AGGREGATE @extschema@.vector_selector(
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


-- src/schema/estimates.rs:23
-- requires:
--   promscale_setup


CREATE OR REPLACE FUNCTION @extschema@.label_unnest(label_array anyarray)
RETURNS SETOF anyelement
LANGUAGE internal
IMMUTABLE PARALLEL SAFE STRICT ROWS 10
AS $function$array_unnest$function$;
GRANT EXECUTE ON FUNCTION @extschema@.label_unnest(anyarray) TO prom_reader;
    

-- src/aggregates/prom_increase.rs:87
-- requires:
--   prom_increase_transition
--   prom_extrapolate_final


CREATE OR REPLACE AGGREGATE @extschema@.prom_increase(
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


-- src/schema/sql.rs:3
-- finalize
-- 001-utils.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('001-utils.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "001-utils.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                 --perms for schema will be addressed later;
                 CREATE SCHEMA IF NOT EXISTS _prom_catalog;
                
                --table to save commands so they can be run when adding new nodes
                 CREATE TABLE _prom_catalog.remote_commands(
                    key TEXT PRIMARY KEY,
                    seq SERIAL,
                    transactional BOOLEAN,
                    command TEXT
                );
                --only the prom owner has any permissions.
                GRANT ALL ON TABLE _prom_catalog.remote_commands to CURRENT_USER;
                GRANT ALL ON SEQUENCE _prom_catalog.remote_commands_seq_seq to CURRENT_USER;
                
                CREATE OR REPLACE PROCEDURE _prom_catalog.execute_everywhere(command_key text, command TEXT, transactional BOOLEAN = true)
                AS $func$
                BEGIN
                    IF command_key IS NOT NULL THEN
                       INSERT INTO _prom_catalog.remote_commands(key, command, transactional) VALUES(command_key, command, transactional)
                       ON CONFLICT (key) DO UPDATE SET command = excluded.command, transactional = excluded.transactional;
                    END IF;
                
                    EXECUTE command;
                    BEGIN
                        CALL distributed_exec(command);
                    EXCEPTION
                        WHEN undefined_function THEN
                            -- we're not on Timescale 2, just return
                            RETURN;
                        WHEN SQLSTATE '0A000' THEN
                            -- we're not the access node, just return
                            RETURN;
                    END;
                END
                $func$ LANGUAGE PLPGSQL;
                --redundant given schema settings but extra caution for this function
                REVOKE ALL ON PROCEDURE _prom_catalog.execute_everywhere(text, text, boolean) FROM PUBLIC;
                
                CREATE OR REPLACE PROCEDURE _prom_catalog.update_execute_everywhere_entry(command_key text, command TEXT, transactional BOOLEAN = true)
                AS $func$
                BEGIN
                    UPDATE _prom_catalog.remote_commands
                    SET
                        command=update_execute_everywhere_entry.command,
                        transactional=update_execute_everywhere_entry.transactional
                    WHERE key = command_key;
                END
                $func$ LANGUAGE PLPGSQL;
                --redundant given schema settings but extra caution for this function
                REVOKE ALL ON PROCEDURE _prom_catalog.update_execute_everywhere_entry(text, text, boolean) FROM PUBLIC;
            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 002-users.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('002-users.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "002-users.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CALL _prom_catalog.execute_everywhere('create_prom_reader', $ee$
                    DO $$
                        BEGIN
                            CREATE ROLE prom_reader;
                        EXCEPTION WHEN duplicate_object THEN
                            RAISE NOTICE 'role prom_reader already exists, skipping create';
                            RETURN;
                        END
                    $$;
                $ee$);
                
                CALL _prom_catalog.execute_everywhere('create_prom_writer', $ee$
                    DO $$
                        BEGIN
                            CREATE ROLE prom_writer;
                        EXCEPTION WHEN duplicate_object THEN
                            RAISE NOTICE 'role prom_writer already exists, skipping create';
                            RETURN;
                        END
                    $$;
                $ee$);
                
                CALL _prom_catalog.execute_everywhere('create_prom_modifier', $ee$
                    DO $$
                        BEGIN
                            CREATE ROLE prom_modifier;
                        EXCEPTION WHEN duplicate_object THEN
                            RAISE NOTICE 'role prom_modifier already exists, skipping create';
                            RETURN;
                        END
                    $$;
                $ee$);
                
                CALL _prom_catalog.execute_everywhere('create_prom_admin', $ee$
                    DO $$
                        BEGIN
                            CREATE ROLE prom_admin;
                        EXCEPTION WHEN duplicate_object THEN
                            RAISE NOTICE 'role prom_admin already exists, skipping create';
                            RETURN;
                        END
                    $$;
                $ee$);
                
                CALL _prom_catalog.execute_everywhere('create_prom_maintenance', $ee$
                    DO $$
                        BEGIN
                            CREATE ROLE prom_maintenance;
                        EXCEPTION WHEN duplicate_object THEN
                            RAISE NOTICE 'role prom_maintenance already exists, skipping create';
                            RETURN;
                        END
                    $$;
                $ee$);
                
                CALL _prom_catalog.execute_everywhere('grant_prom_reader_prom_writer',$ee$
                    DO $$
                    BEGIN
                        GRANT prom_reader TO prom_writer;
                        GRANT prom_reader TO prom_maintenance;
                        GRANT prom_writer TO prom_modifier;
                        GRANT prom_modifier TO prom_admin;
                        GRANT prom_maintenance TO prom_admin;
                    END
                    $$;
                $ee$);

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 003-schemas.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('003-schemas.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "003-schemas.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CALL _prom_catalog.execute_everywhere('create_schemas', $ee$ DO $$ BEGIN
                    CREATE SCHEMA IF NOT EXISTS _prom_catalog; -- this will be limited to metric and probably renamed in future
                    GRANT USAGE ON SCHEMA _prom_catalog TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_api; -- public functions
                    GRANT USAGE ON SCHEMA prom_api TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS _prom_ext; -- optimized versions of functions created by the extension
                    GRANT USAGE ON SCHEMA _prom_ext TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_series; -- series views
                    GRANT USAGE ON SCHEMA prom_series TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_metric; -- metric views
                    GRANT USAGE ON SCHEMA prom_metric TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_data;
                    GRANT USAGE ON SCHEMA prom_data TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_data_series;
                    GRANT USAGE ON SCHEMA prom_data_series TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_info;
                    GRANT USAGE ON SCHEMA prom_info TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS prom_data_exemplar;
                    GRANT USAGE ON SCHEMA prom_data_exemplar TO prom_reader;
                    GRANT ALL ON SCHEMA prom_data_exemplar TO prom_writer;
                
                    CREATE SCHEMA IF NOT EXISTS ps_tag;
                    GRANT USAGE ON SCHEMA ps_tag TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS _ps_trace;
                    GRANT USAGE ON SCHEMA _ps_trace TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS ps_trace;
                    GRANT USAGE ON SCHEMA ps_trace TO prom_reader;
                
                    CREATE SCHEMA IF NOT EXISTS _ps_catalog;
                    GRANT USAGE ON SCHEMA _ps_catalog TO prom_reader;
                END $$ $ee$);
                
                -- the promscale extension contains optimized version of some
                -- of our functions and operators. To ensure the correct version of the are
                -- used, _prom_ext must be before all of our other schemas in the search path
                DO $$
                DECLARE
                   new_path text;
                BEGIN
                   new_path := current_setting('search_path') || format(',%L,%L,%L,%L,%L,%L', 'ps_tag', '_prom_ext', 'prom_api', 'prom_metric', '_prom_catalog', 'ps_trace');
                   execute format('ALTER DATABASE %I SET search_path = %s', current_database(), new_path);
                   execute format('SET search_path = %s', new_path);
                END
                $$;

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 004-tag-operators.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('004-tag-operators.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "004-tag-operators.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE TYPE ps_tag.tag_op_jsonb_path_exists AS (tag_key text, value jsonpath);
                CREATE TYPE ps_tag.tag_op_regexp_matches AS (tag_key text, value text);
                CREATE TYPE ps_tag.tag_op_regexp_not_matches AS (tag_key text, value text);
                CREATE TYPE ps_tag.tag_op_equals AS (tag_key text, value jsonb);
                CREATE TYPE ps_tag.tag_op_not_equals AS (tag_key text, value jsonb);
                CREATE TYPE ps_tag.tag_op_less_than AS (tag_key text, value jsonb);
                CREATE TYPE ps_tag.tag_op_less_than_or_equal AS (tag_key text, value jsonb);
                CREATE TYPE ps_tag.tag_op_greater_than AS (tag_key text, value jsonb);
                CREATE TYPE ps_tag.tag_op_greater_than_or_equal AS (tag_key text, value jsonb);

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 005-tables.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('005-tables.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "005-tables.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                -----------------------
                -- Table definitions --
                -----------------------
                
                -- a special type we use in our tables so must be created here
                CREATE DOMAIN prom_api.label_array AS int[] NOT NULL;
                
                -- special type to store only values of labels
                CREATE DOMAIN prom_api.label_value_array AS TEXT[];
                
                CREATE TABLE public.prom_installation_info (
                    key TEXT PRIMARY KEY,
                    value TEXT
                );
                GRANT SELECT ON TABLE public.prom_installation_info TO PUBLIC;
                --all modifications can only be done by owner
                
                INSERT INTO public.prom_installation_info(key, value) VALUES
                    ('tagging schema',          'ps_tag'),
                    ('catalog schema',          '_prom_catalog'),
                    ('prometheus API schema',   'prom_api'),
                    ('extension schema',        '_prom_ext'),
                    ('series schema',           'prom_series'),
                    ('metric schema',           'prom_metric'),
                    ('data schema',             'prom_data'),
                    ('exemplar data schema',    'prom_data_exemplar'),
                    ('information schema',      'prom_info'),
                    ('tracing schema',          'ps_trace'),
                    ('tracing schema private',  '_ps_trace');
                
                
                CREATE TABLE _prom_catalog.series (
                    id bigint NOT NULL,
                    metric_id int NOT NULL,
                    labels prom_api.label_array NOT NULL, --labels are globally unique because of how partitions are defined
                    delete_epoch bigint NULL DEFAULT NULL -- epoch after which this row can be deleted
                ) PARTITION BY LIST(metric_id);
                GRANT SELECT ON TABLE _prom_catalog.series TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.series TO prom_writer;
                
                
                CREATE INDEX series_labels_id ON _prom_catalog.series USING GIN (labels);
                CREATE INDEX series_deleted
                    ON _prom_catalog.series(delete_epoch, id)
                    WHERE delete_epoch IS NOT NULL;
                
                CREATE SEQUENCE _prom_catalog.series_id;
                GRANT USAGE ON SEQUENCE _prom_catalog.series_id TO prom_writer;
                
                
                CREATE TABLE _prom_catalog.label (
                    id serial CHECK (id > 0),
                    key TEXT,
                    value text,
                    PRIMARY KEY (id) INCLUDE (key, value),
                    UNIQUE (key, value) INCLUDE (id)
                );
                GRANT SELECT ON TABLE _prom_catalog.label TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.label TO prom_writer;
                GRANT USAGE ON SEQUENCE _prom_catalog.label_id_seq TO prom_writer;
                
                CREATE TABLE _prom_catalog.ids_epoch(
                    current_epoch BIGINT NOT NULL,
                    last_update_time TIMESTAMPTZ NOT NULL,
                    -- force there to only be a single row
                    is_unique BOOLEAN NOT NULL DEFAULT true CHECK (is_unique = true),
                    UNIQUE (is_unique)
                );
                GRANT SELECT ON TABLE _prom_catalog.ids_epoch TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.ids_epoch TO prom_writer;
                
                -- uses an arbitrary start time so pristine and migrated DBs have the same values
                INSERT INTO _prom_catalog.ids_epoch VALUES (0, '1970-01-01 00:00:00 UTC', true);
                
                --This table creates a unique mapping
                --between label keys and their column names across metrics.
                --This is done for usability of column name, especially for
                -- long keys that get cut off.
                CREATE TABLE _prom_catalog.label_key(
                    id SERIAL,
                    key TEXT,
                    value_column_name NAME,
                    id_column_name NAME,
                    PRIMARY KEY (id),
                    UNIQUE(key)
                );
                GRANT SELECT ON TABLE _prom_catalog.label_key TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.label_key TO prom_writer;
                GRANT USAGE ON SEQUENCE _prom_catalog.label_key_id_seq TO prom_writer;
                
                CREATE TABLE _prom_catalog.label_key_position (
                    metric_name text, --references metric.metric_name NOT metric.id for performance reasons
                    key TEXT, --NOT label_key.id for performance reasons.
                    pos int,
                    UNIQUE (metric_name, key) INCLUDE (pos)
                );
                GRANT SELECT ON TABLE _prom_catalog.label_key_position TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.label_key_position TO prom_writer;
                
                CREATE TABLE _prom_catalog.metric (
                    id SERIAL PRIMARY KEY,
                    metric_name text NOT NULL,
                    table_name name NOT NULL,
                    creation_completed BOOLEAN NOT NULL DEFAULT false,
                    default_chunk_interval BOOLEAN NOT NULL DEFAULT true,
                    retention_period INTERVAL DEFAULT NULL, --NULL to use the default retention_period
                    default_compression BOOLEAN NOT NULL DEFAULT true,
                    delay_compression_until TIMESTAMPTZ DEFAULT NULL,
                    table_schema name NOT NULL DEFAULT 'prom_data',
                    series_table name NOT NULL, -- series_table specifies the name of table where the series data is stored.
                    is_view BOOLEAN NOT NULL DEFAULT false,
                    UNIQUE (metric_name, table_schema) INCLUDE (table_name),
                    UNIQUE(table_schema, table_name)
                );
                GRANT SELECT ON TABLE _prom_catalog.metric TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.metric TO prom_writer;
                GRANT USAGE ON SEQUENCE _prom_catalog.metric_id_seq TO prom_writer;
                
                CREATE TABLE _prom_catalog.default (
                    key TEXT PRIMARY KEY,
                    value TEXT
                );
                GRANT SELECT ON TABLE _prom_catalog.default TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.default TO prom_admin;
                
                INSERT INTO _prom_catalog.default(key,value) VALUES
                ('chunk_interval', (INTERVAL '8 hours')::text),
                ('retention_period', (90 * INTERVAL '1 day')::text),
                ('metric_compression', (exists(select * from pg_proc where proname = 'compress_chunk')::text)),
                ('trace_retention_period', (30 * INTERVAL '1 days')::text);

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 006-matcher-operators.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('006-matcher-operators.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "006-matcher-operators.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                ----------------------------------
                -- Label selectors and matchers --
                ----------------------------------
                -- This section contains a few functions that we're going to replace in the idempotent section.
                -- They are created here just to allow us to create the necessary operators.
                
                CREATE DOMAIN prom_api.matcher_positive AS int[] NOT NULL;
                CREATE DOMAIN prom_api.matcher_negative AS int[] NOT NULL;
                CREATE DOMAIN prom_api.label_key AS TEXT NOT NULL;
                CREATE DOMAIN prom_api.pattern AS TEXT NOT NULL;
                
                --wrapper around jsonb_each_text to give a better row_estimate
                --for labels (10 not 100)
                CREATE OR REPLACE FUNCTION _prom_catalog.label_jsonb_each_text(js jsonb, OUT key text, OUT value text)
                 RETURNS SETOF record
                 LANGUAGE SQL
                 IMMUTABLE PARALLEL SAFE STRICT ROWS 10
                AS $function$ SELECT (jsonb_each_text(js)).* $function$;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.count_jsonb_keys(j jsonb)
                RETURNS INT
                AS $func$
                    SELECT count(*)::int from (SELECT jsonb_object_keys(j)) v;
                $func$
                LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
                
                CREATE OR REPLACE FUNCTION prom_api.matcher(labels jsonb)
                RETURNS prom_api.matcher_positive
                AS $func$
                    SELECT ARRAY(
                           SELECT coalesce(l.id, -1) -- -1 indicates no such label
                           FROM label_jsonb_each_text(labels-'__name__') e
                           LEFT JOIN _prom_catalog.label l
                               ON (l.key = e.key AND l.value = e.value)
                        )::prom_api.matcher_positive
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                --------------------- op @> ------------------------
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_contains(labels prom_api.label_array, json_labels jsonb)
                RETURNS BOOLEAN
                AS $func$
                    SELECT labels @> prom_api.matcher(json_labels)
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OPERATOR prom_api.@> (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = jsonb,
                    FUNCTION = _prom_catalog.label_contains
                );
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_value_contains(labels prom_api.label_value_array, label_value TEXT)
                RETURNS BOOLEAN
                AS $func$
                    SELECT labels @> ARRAY[label_value]::TEXT[]
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OPERATOR prom_api.@> (
                    LEFTARG = prom_api.label_value_array,
                    RIGHTARG = TEXT,
                    FUNCTION = _prom_catalog.label_value_contains
                );
                
                --------------------- op ? ------------------------
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_match(labels prom_api.label_array, matchers prom_api.matcher_positive)
                RETURNS BOOLEAN
                AS $func$
                    SELECT labels && matchers
                $func$
                LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
                
                CREATE OPERATOR prom_api.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = prom_api.matcher_positive,
                    FUNCTION = _prom_catalog.label_match
                );
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_match(labels prom_api.label_array, matchers prom_api.matcher_negative)
                RETURNS BOOLEAN
                AS $func$
                    SELECT NOT (labels && matchers)
                $func$
                LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
                
                CREATE OPERATOR prom_api.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = prom_api.matcher_negative,
                    FUNCTION = _prom_catalog.label_match
                );
                
                --------------------- op == !== ==~ !=~ ------------------------
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_equal(key_to_match prom_api.label_key, pat prom_api.pattern)
                RETURNS prom_api.matcher_positive
                AS $func$
                    SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_positive
                    FROM _prom_catalog.label l
                    WHERE l.key = key_to_match and l.value = pat
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_not_equal(key_to_match prom_api.label_key, pat prom_api.pattern)
                RETURNS prom_api.matcher_negative
                AS $func$
                    SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_negative
                    FROM _prom_catalog.label l
                    WHERE l.key = key_to_match and l.value = pat
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_regex(key_to_match prom_api.label_key, pat prom_api.pattern)
                RETURNS prom_api.matcher_positive
                AS $func$
                    SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_positive
                    FROM _prom_catalog.label l
                    WHERE l.key = key_to_match and l.value ~ pat
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_not_regex(key_to_match prom_api.label_key, pat prom_api.pattern)
                RETURNS prom_api.matcher_negative
                AS $func$
                    SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_negative
                    FROM _prom_catalog.label l
                    WHERE l.key = key_to_match and l.value ~ pat
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.match_equals(labels prom_api.label_array, _op ps_tag.tag_op_equals)
                RETURNS boolean
                AS $func$
                    SELECT labels && label_find_key_equal(_op.tag_key, (_op.value#>>'{}'))::int[]
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
                
                CREATE OPERATOR _prom_catalog.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = ps_tag.tag_op_equals,
                    FUNCTION = _prom_catalog.match_equals
                );
                
                CREATE OR REPLACE FUNCTION _prom_catalog.match_not_equals(labels prom_api.label_array, _op ps_tag.tag_op_not_equals)
                RETURNS boolean
                AS $func$
                    SELECT NOT (labels && label_find_key_not_equal(_op.tag_key, (_op.value#>>'{}'))::int[])
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
                
                CREATE OPERATOR _prom_catalog.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = ps_tag.tag_op_not_equals,
                    FUNCTION = _prom_catalog.match_not_equals
                );
                
                CREATE OR REPLACE FUNCTION _prom_catalog.match_regexp_matches(labels prom_api.label_array, _op ps_tag.tag_op_regexp_matches)
                RETURNS boolean
                AS $func$
                    SELECT labels && label_find_key_regex(_op.tag_key, _op.value)::int[]
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
                
                CREATE OPERATOR _prom_catalog.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = ps_tag.tag_op_regexp_matches,
                    FUNCTION = _prom_catalog.match_regexp_matches
                );
                
                CREATE OR REPLACE FUNCTION _prom_catalog.match_regexp_not_matches(labels prom_api.label_array, _op ps_tag.tag_op_regexp_not_matches)
                RETURNS boolean
                AS $func$
                    SELECT NOT (labels && label_find_key_not_regex(_op.tag_key, _op.value)::int[])
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
                
                CREATE OPERATOR _prom_catalog.? (
                    LEFTARG = prom_api.label_array,
                    RIGHTARG = ps_tag.tag_op_regexp_not_matches,
                    FUNCTION = _prom_catalog.match_regexp_not_matches
                );

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 007-install-uda.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('007-install-uda.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "007-install-uda.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE OR REPLACE FUNCTION _prom_catalog.get_timescale_major_version()
                    RETURNS INT
                AS $func$
                    SELECT split_part(extversion, '.', 1)::INT FROM pg_catalog.pg_extension WHERE extname='timescaledb' LIMIT 1;
                $func$
                LANGUAGE SQL STABLE PARALLEL SAFE;
                
                --just a stub will be replaced in the idempotent scripts
                CREATE OR REPLACE PROCEDURE _prom_catalog.execute_maintenance_job(job_id int, config jsonb)
                AS $$
                BEGIN
                    RAISE 'calling execute_maintenance_job stub, should have been replaced';
                END
                $$ LANGUAGE PLPGSQL;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.is_timescaledb_installed()
                RETURNS BOOLEAN
                AS $func$
                    SELECT count(*) > 0 FROM pg_extension WHERE extname='timescaledb';
                $func$
                LANGUAGE SQL STABLE;
                GRANT EXECUTE ON FUNCTION _prom_catalog.is_timescaledb_installed() TO prom_reader;
                
                CREATE OR REPLACE FUNCTION _prom_catalog.is_timescaledb_oss()
                RETURNS BOOLEAN AS
                $$
                BEGIN
                    IF _prom_catalog.is_timescaledb_installed() THEN
                        IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                            -- TimescaleDB 2.x
                            RETURN (SELECT current_setting('timescaledb.license') = 'apache');
                        ELSE
                            -- TimescaleDB 1.x
                            -- Note: We cannot use current_setting() in 1.x, otherwise we get permission errors as
                            -- we need to be superuser. We should not enforce the use of superuser. Hence, we take
                            -- help of a view.
                            RETURN (SELECT edition = 'apache' FROM timescaledb_information.license);
                        END IF;
                    END IF;
                RETURN false;
                END;
                $$
                LANGUAGE plpgsql;
                GRANT EXECUTE ON FUNCTION _prom_catalog.is_timescaledb_oss() TO prom_reader;
                
                --add 2 jobs executing every 30 min by default for timescaledb 2.0
                DO $$
                BEGIN
                    IF NOT _prom_catalog.is_timescaledb_oss() AND _prom_catalog.get_timescale_major_version() >= 2 THEN
                       PERFORM public.add_job('_prom_catalog.execute_maintenance_job', '30 min');
                       PERFORM public.add_job('_prom_catalog.execute_maintenance_job', '30 min');
                    END IF;
                END
                $$;

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 008-tables-ha.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('008-tables-ha.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "008-tables-ha.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE TABLE _prom_catalog.ha_leases
                (
                    cluster_name TEXT PRIMARY KEY,
                    leader_name  TEXT,
                    lease_start  TIMESTAMPTZ,
                    lease_until  TIMESTAMPTZ
                );
                GRANT SELECT ON TABLE _prom_catalog.ha_leases TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.ha_leases TO prom_writer;
                
                CREATE TABLE _prom_catalog.ha_leases_logs
                (
                    cluster_name TEXT        NOT NULL,
                    leader_name  TEXT        NOT NULL,
                    lease_start  TIMESTAMPTZ NOT NULL, -- inclusive
                    lease_until  TIMESTAMPTZ,          -- exclusive
                    PRIMARY KEY (cluster_name, leader_name, lease_start)
                );
                GRANT SELECT ON TABLE _prom_catalog.ha_leases_logs TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.ha_leases_logs TO prom_writer;
                
                
                -- STUB for function that trigger to automatically keep the log calls - real implementation in ha.sql
                CREATE OR REPLACE FUNCTION _prom_catalog.ha_leases_audit_fn()
                    RETURNS TRIGGER
                AS
                $func$
                BEGIN
                    RAISE 'Just a stub, should be overwritten';
                    RETURN NEW;
                END;
                $func$ LANGUAGE plpgsql VOLATILE;
                
                -- trigger to automatically keep the log
                CREATE TRIGGER ha_leases_audit
                    AFTER INSERT OR UPDATE
                    ON _prom_catalog.ha_leases
                    FOR EACH ROW
                EXECUTE PROCEDURE _prom_catalog.ha_leases_audit_fn();
                
                -- default values for lease
                INSERT INTO _prom_catalog.default(key, value)
                VALUES ('ha_lease_timeout', '1m'),
                       ('ha_lease_refresh', '10s')
                ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 009-tables-metadata.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('009-tables-metadata.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "009-tables-metadata.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE TABLE IF NOT EXISTS _prom_catalog.metadata
                (
                    last_seen TIMESTAMPTZ NOT NULL,
                    metric_family TEXT NOT NULL,
                    type TEXT DEFAULT NULL,
                    unit TEXT DEFAULT NULL,
                    help TEXT DEFAULT NULL,
                    PRIMARY KEY (metric_family, type, unit, help)
                );
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.metadata TO prom_writer;
                GRANT SELECT ON TABLE _prom_catalog.metadata TO prom_reader;
                
                CREATE INDEX IF NOT EXISTS metadata_index ON _prom_catalog.metadata
                (
                    metric_family, last_seen
                );

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 010-tables-exemplar.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('010-tables-exemplar.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "010-tables-exemplar.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE TABLE IF NOT EXISTS _prom_catalog.exemplar_label_key_position (
                    metric_name TEXT NOT NULL,
                    key         TEXT NOT NULL,
                    pos         INTEGER NOT NULL,
                    PRIMARY KEY (metric_name, key) INCLUDE (pos)
                );
                GRANT SELECT ON TABLE _prom_catalog.exemplar_label_key_position TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.exemplar_label_key_position TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _prom_catalog.exemplar (
                    id          SERIAL PRIMARY KEY,
                    metric_name TEXT NOT NULL,
                    table_name  TEXT NOT NULL,
                    UNIQUE (metric_name) INCLUDE (table_name, id)
                );
                GRANT SELECT ON TABLE _prom_catalog.exemplar TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _prom_catalog.exemplar TO prom_writer;
                
                GRANT USAGE, SELECT ON SEQUENCE exemplar_id_seq TO prom_writer;

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 011-tracing.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('011-tracing.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "011-tracing.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CALL _prom_catalog.execute_everywhere('tracing_types', $ee$ DO $$ BEGIN
                
                    CREATE DOMAIN ps_trace.trace_id uuid NOT NULL CHECK (value != '00000000-0000-0000-0000-000000000000');
                    GRANT USAGE ON DOMAIN ps_trace.trace_id TO prom_reader;
                
                    CREATE DOMAIN ps_trace.tag_k text NOT NULL CHECK (value != '');
                    GRANT USAGE ON DOMAIN ps_trace.tag_k TO prom_reader;
                
                    CREATE DOMAIN ps_trace.tag_v jsonb NOT NULL;
                    GRANT USAGE ON DOMAIN ps_trace.tag_v TO prom_reader;
                
                    CREATE DOMAIN ps_trace.tag_map jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(value) = 'object');
                    GRANT USAGE ON DOMAIN ps_trace.tag_map TO prom_reader;
                
                    CREATE DOMAIN ps_trace.tag_type smallint NOT NULL; --bitmap, may contain several types
                    GRANT USAGE ON DOMAIN ps_trace.tag_type TO prom_reader;
                
                    CREATE TYPE ps_trace.span_kind AS ENUM
                    (
                        'SPAN_KIND_UNSPECIFIED',
                        'SPAN_KIND_INTERNAL',
                        'SPAN_KIND_SERVER',
                        'SPAN_KIND_CLIENT',
                        'SPAN_KIND_PRODUCER',
                        'SPAN_KIND_CONSUMER'
                    );
                    GRANT USAGE ON TYPE ps_trace.span_kind TO prom_reader;
                
                    CREATE TYPE ps_trace.status_code AS ENUM
                    (
                        'STATUS_CODE_UNSET',
                        'STATUS_CODE_OK',
                        'STATUS_CODE_ERROR'
                    );
                    GRANT USAGE ON TYPE ps_trace.status_code TO prom_reader;
                END $$ $ee$);
                
                INSERT INTO public.prom_installation_info(key, value) VALUES
                    ('tagging schema',          'ps_tag'),
                    ('tracing schema',          'ps_trace'),
                    ('tracing schema private',  '_ps_trace')
                ON CONFLICT (key) DO NOTHING;
                
                CREATE TABLE _ps_trace.tag_key
                (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                    tag_type ps_trace.tag_type NOT NULL,
                    key ps_trace.tag_k NOT NULL
                );
                CREATE UNIQUE INDEX ON _ps_trace.tag_key (key) INCLUDE (id, tag_type);
                GRANT SELECT ON TABLE _ps_trace.tag_key TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.tag_key TO prom_writer;
                GRANT USAGE ON SEQUENCE _ps_trace.tag_key_id_seq TO prom_writer;
                
                CREATE TABLE _ps_trace.tag
                (
                    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY,
                    tag_type ps_trace.tag_type NOT NULL,
                    key_id bigint NOT NULL,
                    key ps_trace.tag_k NOT NULL REFERENCES _ps_trace.tag_key (key) ON DELETE CASCADE,
                    value ps_trace.tag_v NOT NULL,
                    UNIQUE (key, value) INCLUDE (id, key_id)
                )
                PARTITION BY HASH (key);
                GRANT SELECT ON TABLE _ps_trace.tag TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.tag TO prom_writer;
                GRANT USAGE ON SEQUENCE _ps_trace.tag_id_seq TO prom_writer;
                
                -- create the partitions of the tag table
                DO $block$
                DECLARE
                    _i bigint;
                    _max bigint = 64;
                BEGIN
                    FOR _i IN 1.._max
                    LOOP
                        EXECUTE format($sql$
                            CREATE TABLE _ps_trace.tag_%s PARTITION OF _ps_trace.tag FOR VALUES WITH (MODULUS %s, REMAINDER %s)
                            $sql$, _i, _max, _i - 1);
                        EXECUTE format($sql$
                            ALTER TABLE _ps_trace.tag_%s ADD PRIMARY KEY (id)
                            $sql$, _i);
                        EXECUTE format($sql$
                            GRANT SELECT ON TABLE _ps_trace.tag_%s TO prom_reader
                            $sql$, _i);
                        EXECUTE format($sql$
                            GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.tag_%s TO prom_writer
                            $sql$, _i);
                    END LOOP;
                END
                $block$
                ;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.operation
                (
                    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                    service_name_id bigint not null, -- references id column of tag table for the service.name tag value
                    span_kind ps_trace.span_kind not null,
                    span_name text NOT NULL CHECK (span_name != ''),
                    UNIQUE (service_name_id, span_name, span_kind)
                );
                GRANT SELECT ON TABLE _ps_trace.operation TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.operation TO prom_writer;
                GRANT USAGE ON SEQUENCE _ps_trace.operation_id_seq TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.schema_url
                (
                    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                    url text NOT NULL CHECK (url != '') UNIQUE
                );
                GRANT SELECT ON TABLE _ps_trace.schema_url TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.schema_url TO prom_writer;
                GRANT USAGE ON SEQUENCE _ps_trace.schema_url_id_seq TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.instrumentation_lib
                (
                    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                    name text NOT NULL,
                    version text NOT NULL,
                    schema_url_id BIGINT REFERENCES _ps_trace.schema_url(id),
                    UNIQUE(name, version, schema_url_id)
                );
                GRANT SELECT ON TABLE _ps_trace.instrumentation_lib TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.instrumentation_lib TO prom_writer;
                GRANT USAGE ON SEQUENCE _ps_trace.instrumentation_lib_id_seq TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.span
                (
                    trace_id ps_trace.trace_id NOT NULL,
                    span_id bigint NOT NULL CHECK (span_id != 0),
                    parent_span_id bigint NULL CHECK (parent_span_id != 0),
                    operation_id bigint NOT NULL,
                    start_time timestamptz NOT NULL,
                    end_time timestamptz NOT NULL,
                    duration_ms double precision NOT NULL GENERATED ALWAYS AS ( extract(epoch from (end_time - start_time)) * 1000.0 ) STORED,
                    trace_state text CHECK (trace_state != ''),
                    span_tags ps_trace.tag_map NOT NULL,
                    dropped_tags_count int NOT NULL default 0,
                    event_time tstzrange default NULL,
                    dropped_events_count int NOT NULL default 0,
                    dropped_link_count int NOT NULL default 0,
                    status_code ps_trace.status_code NOT NULL,
                    status_message text,
                    instrumentation_lib_id bigint,
                    resource_tags ps_trace.tag_map NOT NULL,
                    resource_dropped_tags_count int NOT NULL default 0,
                    resource_schema_url_id BIGINT,
                    PRIMARY KEY (span_id, trace_id, start_time),
                    CHECK (start_time <= end_time)
                );
                CREATE INDEX ON _ps_trace.span USING BTREE (trace_id, parent_span_id) INCLUDE (span_id); -- used for recursive CTEs for trace tree queries
                CREATE INDEX ON _ps_trace.span USING GIN (span_tags jsonb_path_ops); -- supports tag filters. faster ingest than json_ops
                CREATE INDEX ON _ps_trace.span USING BTREE (operation_id); -- supports filters/joins to operation table
                --CREATE INDEX ON _ps_trace.span USING GIN (jsonb_object_keys(span_tags) array_ops); -- possible way to index key exists
                CREATE INDEX ON _ps_trace.span USING GIN (resource_tags jsonb_path_ops); -- supports tag filters. faster ingest than json_ops
                GRANT SELECT ON TABLE _ps_trace.span TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.span TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.event
                (
                    time timestamptz NOT NULL,
                    trace_id ps_trace.trace_id NOT NULL,
                    span_id bigint NOT NULL CHECK (span_id != 0),
                    event_nbr int NOT NULL DEFAULT 0,
                    name text NOT NULL,
                    tags ps_trace.tag_map NOT NULL,
                    dropped_tags_count int NOT NULL DEFAULT 0
                );
                CREATE INDEX ON _ps_trace.event USING GIN (tags jsonb_path_ops);
                CREATE INDEX ON _ps_trace.event USING BTREE (trace_id, span_id);
                GRANT SELECT ON TABLE _ps_trace.event TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.event TO prom_writer;
                
                CREATE TABLE IF NOT EXISTS _ps_trace.link
                (
                    trace_id ps_trace.trace_id NOT NULL,
                    span_id bigint NOT NULL CHECK (span_id != 0),
                    span_start_time timestamptz NOT NULL,
                    linked_trace_id ps_trace.trace_id NOT NULL,
                    linked_span_id bigint NOT NULL CHECK (linked_span_id != 0),
                    link_nbr int NOT NULL DEFAULT 0,
                    trace_state text CHECK (trace_state != ''),
                    tags ps_trace.tag_map NOT NULL,
                    dropped_tags_count int NOT NULL DEFAULT 0
                );
                CREATE INDEX ON _ps_trace.link USING BTREE (trace_id, span_id);
                CREATE INDEX ON _ps_trace.link USING GIN (tags jsonb_path_ops);
                GRANT SELECT ON TABLE _ps_trace.link TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_trace.link TO prom_writer;
                
                /*
                    If "vanilla" postgres is installed, do nothing.
                    If timescaledb is installed, turn on compression for tracing tables.
                    If timescaledb is installed and multinode is set up,
                    turn span, event, and link into distributed hypertables.
                    If timescaledb is installed but multinode is NOT set up,
                    turn span, event, and link into regular hypertables.
                */
                DO $block$
                DECLARE
                    _is_timescaledb_installed boolean = false;
                    _is_timescaledb_oss boolean = true;
                    _timescaledb_version_text text;
                    _timescaledb_major_version int;
                    _timescaledb_minor_version int;
                    _is_compression_available boolean = false;
                    _is_multinode boolean = false;
                    _saved_search_path text;
                BEGIN
                    /*
                        These functions do not exist until the
                        idempotent scripts are executed, so we have
                        to deal with it "manually"
                        _prom_catalog.get_timescale_major_version()
                        _prom_catalog.is_timescaledb_oss()
                        _prom_catalog.is_timescaledb_installed()
                        _prom_catalog.is_multinode()
                        _prom_catalog.get_default_chunk_interval()
                        _prom_catalog.get_staggered_chunk_interval(...)
                    */
                    SELECT count(*) > 0
                    INTO STRICT _is_timescaledb_installed
                    FROM pg_extension
                    WHERE extname='timescaledb';
                
                    IF _is_timescaledb_installed THEN
                        SELECT extversion INTO STRICT _timescaledb_version_text
                        FROM pg_catalog.pg_extension
                        WHERE extname='timescaledb'
                        LIMIT 1;
                
                        _timescaledb_major_version = split_part(_timescaledb_version_text, '.', 1)::INT;
                        _timescaledb_minor_version = split_part(_timescaledb_version_text, '.', 2)::INT;
                
                        _is_compression_available = CASE
                            WHEN _timescaledb_major_version >= 2 THEN true
                            WHEN _timescaledb_major_version = 1 and _timescaledb_minor_version >= 5 THEN true
                            ELSE false
                        END;
                
                        IF _timescaledb_major_version >= 2 THEN
                            _is_timescaledb_oss = (current_setting('timescaledb.license') = 'apache');
                        ELSE
                            _is_timescaledb_oss = (SELECT edition = 'apache' FROM timescaledb_information.license);
                        END IF;
                
                        IF _timescaledb_major_version >= 2 THEN
                            SELECT count(*) > 0
                            INTO STRICT _is_multinode
                            FROM timescaledb_information.data_nodes;
                        END IF;
                    END IF;
                
                    IF _is_timescaledb_installed THEN
                        IF _is_multinode THEN
                            --need to clear the search path while creating distributed
                            --hypertables because otherwise the datanodes don't find
                            --the right column types since type names are not schema
                            --qualified if in search path.
                            _saved_search_path := current_setting('search_path');
                            SET search_path = pg_temp;
                            PERFORM public.create_distributed_hypertable(
                                '_ps_trace.span'::regclass,
                                'start_time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:57:57.345608'::interval,
                                create_default_indexes=>false
                            );
                            PERFORM public.create_distributed_hypertable(
                                '_ps_trace.event'::regclass,
                                'time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:59:53.649542'::interval,
                                create_default_indexes=>false
                            );
                            PERFORM public.create_distributed_hypertable(
                                '_ps_trace.link'::regclass,
                                'span_start_time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:59:48.644258'::interval,
                                create_default_indexes=>false
                            );
                            execute format('SET search_path = %s', _saved_search_path);
                        ELSE -- not multinode
                            PERFORM public.create_hypertable(
                                '_ps_trace.span'::regclass,
                                'start_time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:57:57.345608'::interval,
                                create_default_indexes=>false
                            );
                            PERFORM public.create_hypertable(
                                '_ps_trace.event'::regclass,
                                'time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:59:53.649542'::interval,
                                create_default_indexes=>false
                            );
                            PERFORM public.create_hypertable(
                                '_ps_trace.link'::regclass,
                                'span_start_time'::name,
                                partitioning_column=>'trace_id'::name,
                                number_partitions=>1::int,
                                chunk_time_interval=>'07:59:48.644258'::interval,
                                create_default_indexes=>false
                            );
                        END IF;
                
                        IF (NOT _is_timescaledb_oss) AND _is_compression_available THEN
                            -- turn on compression
                            ALTER TABLE _ps_trace.span SET (timescaledb.compress, timescaledb.compress_segmentby='trace_id,span_id');
                            ALTER TABLE _ps_trace.event SET (timescaledb.compress, timescaledb.compress_segmentby='trace_id,span_id');
                            ALTER TABLE _ps_trace.link SET (timescaledb.compress, timescaledb.compress_segmentby='trace_id,span_id');
                
                            IF _timescaledb_major_version < 2 THEN
                                BEGIN
                                    PERFORM public.add_compression_policy('_ps_trace.span', INTERVAL '1 hour');
                                    PERFORM public.add_compression_policy('_ps_trace.event', INTERVAL '1 hour');
                                    PERFORM public.add_compression_policy('_ps_trace.link', INTERVAL '1 hour');
                                EXCEPTION
                                    WHEN undefined_function THEN
                                        RAISE NOTICE 'add_compression_policy does not exist';
                                END;
                            END IF;
                        END IF;
                    END IF;
                END;
                $block$
                ;

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 012-tracing-well-known-tags.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('012-tracing-well-known-tags.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "012-tracing-well-known-tags.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                /*
                    15 = resource | span | event | link
                */
                INSERT INTO _ps_trace.tag_key (id, key, tag_type)
                OVERRIDING SYSTEM VALUE
                VALUES
                    (1, 'service.name', 15),
                    (2, 'service.namespace', 15),
                    (3, 'service.instance.id', 15),
                    (4, 'service.version', 15),
                    (5, 'telemetry.sdk.name', 15),
                    (6, 'telemetry.sdk.language', 15),
                    (7, 'telemetry.sdk.version', 15),
                    (8, 'telemetry.auto.version', 15),
                    (9, 'container.name', 15),
                    (10, 'container.id', 15),
                    (11, 'container.runtime', 15),
                    (12, 'container.image.name', 15),
                    (13, 'container.image.tag', 15),
                    (14, 'faas.name', 15),
                    (15, 'faas.id', 15),
                    (16, 'faas.version', 15),
                    (17, 'faas.instance', 15),
                    (18, 'faas.max_memory', 15),
                    (19, 'process.pid', 15),
                    (20, 'process.executable.name', 15),
                    (21, 'process.executable.path', 15),
                    (22, 'process.command', 15),
                    (23, 'process.command_line', 15),
                    (24, 'process.command_args', 15),
                    (25, 'process.owner', 15),
                    (26, 'process.runtime.name', 15),
                    (27, 'process.runtime.version', 15),
                    (28, 'process.runtime.description', 15),
                    (29, 'webengine.name', 15),
                    (30, 'webengine.version', 15),
                    (31, 'webengine.description', 15),
                    (32, 'host.id', 15),
                    (33, 'host.name', 15),
                    (34, 'host.type', 15),
                    (35, 'host.arch', 15),
                    (36, 'host.image.name', 15),
                    (37, 'host.image.id', 15),
                    (38, 'host.image.version', 15),
                    (39, 'os.type', 15),
                    (40, 'os.description', 15),
                    (41, 'os.name', 15),
                    (42, 'os.version', 15),
                    (43, 'device.id', 15),
                    (44, 'device.model.identifier', 15),
                    (45, 'device.model.name', 15),
                    (46, 'cloud.provider', 15),
                    (47, 'cloud.account.id', 15),
                    (48, 'cloud.region', 15),
                    (49, 'cloud.availability_zone', 15),
                    (50, 'cloud.platform', 15),
                    (51, 'deployment.environment', 15),
                    (52, 'k8s.cluster', 15),
                    (53, 'k8s.node.name', 15),
                    (54, 'k8s.node.uid', 15),
                    (55, 'k8s.namespace.name', 15),
                    (56, 'k8s.pod.uid', 15),
                    (57, 'k8s.pod.name', 15),
                    (58, 'k8s.container.name', 15),
                    (59, 'k8s.replicaset.uid', 15),
                    (60, 'k8s.replicaset.name', 15),
                    (61, 'k8s.deployment.uid', 15),
                    (62, 'k8s.deployment.name', 15),
                    (63, 'k8s.statefulset.uid', 15),
                    (64, 'k8s.statefulset.name', 15),
                    (65, 'k8s.daemonset.uid', 15),
                    (66, 'k8s.daemonset.name', 15),
                    (67, 'k8s.job.uid', 15),
                    (68, 'k8s.job.name', 15),
                    (69, 'k8s.cronjob.uid', 15),
                    (70, 'k8s.cronjob.name', 15),
                    (71, 'net.transport', 15),
                    (72, 'net.peer.ip', 15),
                    (73, 'net.peer.port', 15),
                    (74, 'net.peer.name', 15),
                    (75, 'net.host.ip', 15),
                    (76, 'net.host.port', 15),
                    (77, 'net.host.name', 15),
                    (78, 'net.host.connection.type', 15),
                    (79, 'net.host.connection.subtype', 15),
                    (80, 'net.host.carrier.name', 15),
                    (81, 'net.host.carrier.mcc', 15),
                    (82, 'net.host.carrier.mnc', 15),
                    (83, 'net.host.carrier.icc', 15),
                    (84, 'peer.service', 15),
                    (85, 'enduser.id', 15),
                    (86, 'enduser.role', 15),
                    (87, 'enduser.scope', 15),
                    (88, 'thread.id', 15),
                    (89, 'thread.name', 15),
                    (90, 'code.function', 15),
                    (91, 'code.namespace', 15),
                    (92, 'code.filepath', 15),
                    (93, 'code.lineno', 15),
                    (94, 'http.method', 15),
                    (95, 'http.url', 15),
                    (96, 'http.target', 15),
                    (97, 'http.host', 15),
                    (98, 'http.scheme', 15),
                    (99, 'http.status_code', 15),
                    (100, 'http.flavor', 15),
                    (101, 'http.user_agent', 15),
                    (102, 'http.request_content_length', 15),
                    (103, 'http.request_content_length_uncompressed', 15),
                    (104, 'http.response_content_length', 15),
                    (105, 'http.response_content_length_uncompressed', 15),
                    (106, 'http.server_name', 15),
                    (107, 'http.route', 15),
                    (108, 'http.client_ip', 15),
                    (109, 'db.system', 15),
                    (110, 'db.connection_string', 15),
                    (111, 'db.user', 15),
                    (112, 'db.jdbc.driver_classname', 15),
                    (113, 'db.mssql.instance_name', 15),
                    (114, 'db.name', 15),
                    (115, 'db.statement', 15),
                    (116, 'db.operation', 15),
                    (117, 'db.hbase.namespace', 15),
                    (118, 'db.redis.database_index', 15),
                    (119, 'db.mongodb.collection', 15),
                    (120, 'db.sql.table', 15),
                    (121, 'db.cassandra.keyspace', 15),
                    (122, 'db.cassandra.page_size', 15),
                    (123, 'db.cassandra.consistency_level', 15),
                    (124, 'db.cassandra.table', 15),
                    (125, 'db.cassandra.idempotence', 15),
                    (126, 'db.cassandra.speculative_execution_count', 15),
                    (127, 'db.cassandra.coordinator.id', 15),
                    (128, 'db.cassandra.coordinator.dc', 15),
                    (129, 'rpc.system', 15),
                    (130, 'rpc.service', 15),
                    (131, 'rpc.method', 15),
                    (132, 'rpc.grpc.status_code', 15),
                    (133, 'message.type', 15),
                    (134, 'message.id', 15),
                    (135, 'message.compressed_size', 15),
                    (136, 'message.uncompressed_size', 15),
                    (137, 'rpc.jsonrpc.version', 15),
                    (138, 'rpc.jsonrpc.request_id', 15),
                    (139, 'rpc.jsonrpc.error_code', 15),
                    (140, 'rpc.jsonrpc.error_message', 15),
                    (141, 'messaging.system', 15),
                    (142, 'messaging.destination', 15),
                    (143, 'messaging.destination_kind', 15),
                    (144, 'messaging.temp_destination', 15),
                    (145, 'messaging.protocol', 15),
                    (146, 'messaging.url', 15),
                    (147, 'messaging.message_id', 15),
                    (148, 'messaging.conversation_id', 15),
                    (149, 'messaging.message_payload_size_bytes', 15),
                    (150, 'messaging.message_payload_compressed_size_bytes', 15),
                    (151, 'messaging.operation', 15),
                    (152, 'messaging.consumer_id', 15),
                    (153, 'messaging.rabbitmq.routing_key', 15),
                    (154, 'messaging.kafka.message_key', 15),
                    (155, 'messaging.kafka.consumer_group', 15),
                    (156, 'messaging.kafka.client_id', 15),
                    (157, 'messaging.kafka.partition', 15),
                    (158, 'messaging.kafka.tombstone', 15),
                    (159, 'faas.trigger', 15),
                    (160, 'faas.speculative_execution_count', 15),
                    (161, 'faas.coldstart', 15),
                    (162, 'faas.invoked_name', 15),
                    (163, 'faas.invoked_provider', 15),
                    (164, 'faas.invoked_region', 15),
                    (165, 'faas.document.collection', 15),
                    (166, 'faas.document.operation', 15),
                    (167, 'faas.document.time', 15),
                    (168, 'faas.document.name', 15),
                    (169, 'faas.time', 15),
                    (170, 'faas.cron', 15),
                    (171, 'exception.type', 15),
                    (172, 'exception.message', 15),
                    (173, 'exception.stacktrace', 15),
                    (174, 'exception.escaped', 15)
                ;
                PERFORM setval('_ps_trace.tag_key_id_seq', 1000);

            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 013-telemetry.sql
DO
$outer_migration_block$
    DECLARE
        _already_applied bool = false;
        _migration       _ps_catalog.migration = row ('013-telemetry.sql', '0.5.0');
    BEGIN
        SELECT count(*) FILTER (WHERE name = _migration.name) > 0
        INTO STRICT _already_applied
        FROM _ps_catalog.migration;
        IF _already_applied THEN
            RAISE NOTICE 'Migration "013-telemetry.sql" already applied';
            RETURN;
        END IF;

        DO
        $inner_migration_block$
            BEGIN
                CREATE TABLE IF NOT EXISTS _ps_catalog.promscale_instance_information (
                    uuid                                                UUID NOT NULL PRIMARY KEY,
                    last_updated                                        TIMESTAMPTZ NOT NULL,
                    promscale_ingested_samples_total                    BIGINT DEFAULT 0 NOT NULL,
                    promscale_metrics_queries_executed_total            BIGINT DEFAULT 0 NOT NULL,
                    promscale_metrics_queries_timedout_total            BIGINT DEFAULT 0 NOT NULL,
                    promscale_metrics_queries_failed_total              BIGINT DEFAULT 0 NOT NULL,
                    promscale_trace_query_requests_executed_total       BIGINT DEFAULT 0 NOT NULL,
                    promscale_trace_dependency_requests_executed_total  BIGINT DEFAULT 0 NOT NULL,
                    is_counter_reset_row                                BOOLEAN DEFAULT FALSE NOT NULL, -- counter reset row has '00000000-0000-0000-0000-000000000000' uuid
                    CHECK((uuid = '00000000-0000-0000-0000-000000000000' OR NOT is_counter_reset_row) AND (uuid != '00000000-0000-0000-0000-000000000000' OR is_counter_reset_row))
                );
                GRANT SELECT ON TABLE _ps_catalog.promscale_instance_information TO prom_reader;
                GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE _ps_catalog.promscale_instance_information TO prom_writer;
                
                -- Write a counter reset row, i.e., the first row in the table. Purpose:
                -- The above promscale_.* rows logically behave as counter. They get deleted by
                -- telemetry-housekeeper promscale when last_updated is too old to be stale. Since
                -- counters are always increasing, if these rows get deleted, it will result in data-loss.
                -- To avoid this loss of data, we treat the first row as immutable, and use it for incrementing
                -- the attributes of this row, with the values of the stale rows before they are deleted.
                INSERT INTO _ps_catalog.promscale_instance_information (uuid, last_updated, is_counter_reset_row)
                    VALUES ('00000000-0000-0000-0000-000000000000', '2021-12-09 00:00:00'::TIMESTAMPTZ, TRUE);
            END;
        $inner_migration_block$;

        INSERT INTO _ps_catalog.migration (name, applied_at_version) VALUES (_migration.name, _migration.applied_at_version);
    END;
$outer_migration_block$;
-- 001-base.sql
DO
$outer_migration_block$
    BEGIN
        --NOTES
        --This code assumes that table names can only be 63 chars long
        
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_default_chunk_interval()
            RETURNS INTERVAL
        AS $func$
            SELECT value::INTERVAL FROM _prom_catalog.default WHERE key='chunk_interval';
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_default_chunk_interval() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_timescale_major_version()
            RETURNS INT
        AS $func$
            SELECT split_part(extversion, '.', 1)::INT FROM pg_catalog.pg_extension WHERE extname='timescaledb' LIMIT 1;
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_timescale_major_version() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_timescale_minor_version()
            RETURNS INT
        AS $func$
            SELECT split_part(extversion, '.', 2)::INT FROM pg_catalog.pg_extension WHERE extname='timescaledb' LIMIT 1;
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_timescale_minor_version() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_default_retention_period()
            RETURNS INTERVAL
        AS $func$
            SELECT value::INTERVAL FROM _prom_catalog.default WHERE key='retention_period';
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_default_retention_period() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.is_timescaledb_installed()
        RETURNS BOOLEAN
        AS $func$
            SELECT count(*) > 0 FROM pg_extension WHERE extname='timescaledb';
        $func$
        LANGUAGE SQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.is_timescaledb_installed() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.is_timescaledb_oss()
        RETURNS BOOLEAN AS
        $$
        BEGIN
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    -- TimescaleDB 2.x
                    RETURN (SELECT current_setting('timescaledb.license') = 'apache');
                ELSE
                    -- TimescaleDB 1.x
                    -- Note: We cannot use current_setting() in 1.x, otherwise we get permission errors as
                    -- we need to be superuser. We should not enforce the use of superuser. Hence, we take
                    -- help of a view.
                    RETURN (SELECT edition = 'apache' FROM timescaledb_information.license);
                END IF;
            END IF;
            RETURN false;
        END;
        $$
        LANGUAGE plpgsql;
        GRANT EXECUTE ON FUNCTION _prom_catalog.is_timescaledb_oss() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.is_multinode()
            RETURNS BOOLEAN
        AS $func$
        DECLARE
            is_distributed BOOLEAN = false;
        BEGIN
            IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                SELECT count(*) > 0 FROM timescaledb_information.data_nodes
                    INTO is_distributed;
            END IF;
            RETURN is_distributed;
        EXCEPTION WHEN SQLSTATE '42P01' THEN -- Timescale 1.x, never distributed
            RETURN false;
        END
        $func$
        LANGUAGE PLPGSQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.is_multinode() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_default_compression_setting()
            RETURNS BOOLEAN
        AS $func$
            SELECT value::BOOLEAN FROM _prom_catalog.default WHERE key='metric_compression';
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_default_compression_setting() TO prom_reader;
        
        --Add 1% of randomness to the interval so that chunks are not aligned so that chunks are staggered for compression jobs.
        CREATE OR REPLACE FUNCTION _prom_catalog.get_staggered_chunk_interval(chunk_interval INTERVAL)
        RETURNS INTERVAL
        AS $func$
            SELECT chunk_interval * (1.0+((random()*0.01)-0.005));
        $func$
        LANGUAGE SQL VOLATILE;
        --only used for setting chunk interval, and admin function
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_staggered_chunk_interval(INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_advisory_lock_prefix_job()
            RETURNS INTEGER
        AS $func$
        SELECT 12377;
        $func$
            LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_advisory_lock_prefix_job() TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_advisory_lock_prefix_maintenance()
            RETURNS INTEGER
        AS $func$
           SELECT 12378;
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_advisory_lock_prefix_maintenance() TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.lock_metric_for_maintenance(metric_id int, wait boolean = true)
            RETURNS BOOLEAN
        AS $func$
        DECLARE
            res BOOLEAN;
        BEGIN
            IF NOT wait THEN
                SELECT pg_try_advisory_lock(_prom_catalog.get_advisory_lock_prefix_maintenance(), metric_id) INTO STRICT res;
        
                RETURN res;
            ELSE
                PERFORM pg_advisory_lock(_prom_catalog.get_advisory_lock_prefix_maintenance(), metric_id);
        
                RETURN TRUE;
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.lock_metric_for_maintenance(int, boolean) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.unlock_metric_for_maintenance(metric_id int)
            RETURNS VOID
        AS $func$
        DECLARE
        BEGIN
            PERFORM pg_advisory_unlock(_prom_catalog.get_advisory_lock_prefix_maintenance(), metric_id);
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.unlock_metric_for_maintenance(int) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.attach_series_partition(metric_record _prom_catalog.metric) RETURNS VOID
        AS $proc$
        DECLARE
        BEGIN
                EXECUTE format($$
                   ALTER TABLE _prom_catalog.series ATTACH PARTITION prom_data_series.%1$I FOR VALUES IN (%2$L)
                $$, metric_record.table_name, metric_record.id);
        END;
        $proc$
        LANGUAGE PLPGSQL
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.attach_series_partition(_prom_catalog.metric) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.attach_series_partition(_prom_catalog.metric) TO prom_writer;
        
        --Canonical lock ordering:
        --metrics
        --data table
        --labels
        --series parent
        --series partition
        
        --constraints:
        --- The prom_metric view takes locks in the order: data table, series partition.
        
        
        --This procedure finalizes the creation of a metric. The first part of
        --metric creation happens in make_metric_table and the final part happens here.
        --We split metric creation into two parts to minimize latency during insertion
        --(which happens in the make_metric_table path). Especially noteworthy is that
        --attaching the partition to the series table happens here because it requires
        --an exclusive lock, which is a high-latency operation. The other actions this
        --function does are not as critical latency-wise but are also not necessary
        --to perform in order to insert data and thus are put here.
        --
        --Note: that a consequence of this design is that the series partition is attached
        --to the series parent after in this step. Thus a metric might not be seen in some
        --cross-metric queries right away. Those queries aren't common however and the delay
        --is insignificant in practice.
        --
        --lock-order: metric table, data_table, series parent, series partition
        
        CREATE OR REPLACE PROCEDURE _prom_catalog.finalize_metric_creation()
        AS $proc$
        DECLARE
            r _prom_catalog.metric;
            created boolean;
            is_view boolean;
        BEGIN
            FOR r IN
                SELECT *
                FROM _prom_catalog.metric
                WHERE NOT creation_completed
                ORDER BY random()
            LOOP
                SELECT m.creation_completed, m.is_view
                INTO created, is_view
                FROM _prom_catalog.metric m
                WHERE m.id = r.id
                FOR UPDATE;
        
                IF created THEN
                    --release row lock
                    COMMIT;
                    CONTINUE;
                END IF;
        
                --do this before taking exclusive lock to minimize work after taking lock
                UPDATE _prom_catalog.metric SET creation_completed = TRUE WHERE id = r.id;
        
                -- in case of a view, no need to attach the partition
                IF is_view THEN
                    --release row lock
                    COMMIT;
                    CONTINUE;
                END IF;
        
                --we will need this lock for attaching the partition so take it now
                --This may not be strictly necessary but good
                --to enforce lock ordering (parent->child) explicitly. Note:
                --creating a table as a partition takes a stronger lock (access exclusive)
                --so, attaching a partition is better
                LOCK TABLE ONLY _prom_catalog.series IN SHARE UPDATE EXCLUSIVE mode;
        
                PERFORM _prom_catalog.attach_series_partition(r);
        
                COMMIT;
            END LOOP;
        END;
        $proc$ LANGUAGE PLPGSQL;
        COMMENT ON PROCEDURE _prom_catalog.finalize_metric_creation()
        IS 'Finalizes metric creation. This procedure should be run by the connector automatically';
        GRANT EXECUTE ON PROCEDURE _prom_catalog.finalize_metric_creation() TO prom_writer;
        
        --This function is called by a trigger when a new metric is created. It
        --sets up the metric just enough to insert data into it. Metric creation
        --is completed in finalize_metric_creation() above. See the comments
        --on that function for the reasoning for this split design.
        --
        --Note: latency-sensitive function. Should only contain just enough logic
        --to support inserts for the metric.
        --lock-order: data table, labels, series partition.
        CREATE OR REPLACE FUNCTION _prom_catalog.make_metric_table()
            RETURNS trigger
            AS $func$
        DECLARE
          label_id INT;
          compressed_hypertable_name text;
        BEGIN
        
           -- Note: if the inserted metric is a view, nothing to do.
           IF NEW.is_view THEN
                RETURN NEW;
           END IF;
        
           EXECUTE format('CREATE TABLE %I.%I(time TIMESTAMPTZ NOT NULL, value DOUBLE PRECISION NOT NULL, series_id BIGINT NOT NULL) WITH (autovacuum_vacuum_threshold = 50000, autovacuum_analyze_threshold = 50000)',
                            NEW.table_schema, NEW.table_name);
           EXECUTE format('GRANT SELECT ON TABLE %I.%I TO prom_reader', NEW.table_schema, NEW.table_name);
           EXECUTE format('GRANT SELECT, INSERT ON TABLE %I.%I TO prom_writer', NEW.table_schema, NEW.table_name);
           EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE %I.%I TO prom_modifier', NEW.table_schema, NEW.table_name);
           EXECUTE format('CREATE UNIQUE INDEX data_series_id_time_%s ON %I.%I (series_id, time) INCLUDE (value)',
                            NEW.id, NEW.table_schema, NEW.table_name);
        
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.is_multinode() THEN
                    --Note: we intentionally do not partition by series_id here. The assumption is
                    --that we'll have more "heavy metrics" than nodes and thus partitioning /individual/
                    --metrics won't gain us much for inserts and would be detrimental for many queries.
                    PERFORM public.create_distributed_hypertable(
                        format('%I.%I', NEW.table_schema, NEW.table_name),
                        'time',
                        chunk_time_interval=>_prom_catalog.get_staggered_chunk_interval(_prom_catalog.get_default_chunk_interval()),
                        create_default_indexes=>false
                    );
                ELSE
                    PERFORM public.create_hypertable(format('%I.%I', NEW.table_schema, NEW.table_name), 'time',
                    chunk_time_interval=>_prom_catalog.get_staggered_chunk_interval(_prom_catalog.get_default_chunk_interval()),
                                     create_default_indexes=>false);
                END IF;
            END IF;
        
            --Do not move this into the finalize step, because it's cheap to do while the table is empty
            --but takes a heavyweight blocking lock otherwise.
            IF  _prom_catalog.is_timescaledb_installed()
                    AND _prom_catalog.get_default_compression_setting() THEN
                    PERFORM prom_api.set_compression_on_metric_table(NEW.table_name, TRUE);
            END IF;
        
        
            SELECT _prom_catalog.get_or_create_label_id('__name__', NEW.metric_name)
            INTO STRICT label_id;
            --note that because labels[1] is unique across partitions and UNIQUE(labels) inside partition, labels are guaranteed globally unique
            EXECUTE format($$
                CREATE TABLE prom_data_series.%1$I (
                    id bigint NOT NULL,
                    metric_id int NOT NULL,
                    labels prom_api.label_array NOT NULL,
                    delete_epoch BIGINT NULL DEFAULT NULL,
                    CHECK(labels[1] = %2$L AND labels[1] IS NOT NULL),
                    CHECK(metric_id = %3$L),
                    CONSTRAINT series_labels_id_%3$s UNIQUE(labels) INCLUDE (id),
                    CONSTRAINT series_pkey_%3$s PRIMARY KEY(id)
                ) WITH (autovacuum_vacuum_threshold = 100, autovacuum_analyze_threshold = 100)
            $$, NEW.table_name, label_id, NEW.id);
           EXECUTE format('GRANT SELECT ON TABLE prom_data_series.%I TO prom_reader', NEW.table_name);
           EXECUTE format('GRANT SELECT, INSERT ON TABLE prom_data_series.%I TO prom_writer', NEW.table_name);
           EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE prom_data_series.%I TO prom_modifier', NEW.table_name);
           RETURN NEW;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.make_metric_table() FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.make_metric_table() TO prom_writer;
        
        DROP TRIGGER IF EXISTS make_metric_table_trigger ON _prom_catalog.metric CASCADE;
        CREATE TRIGGER make_metric_table_trigger
            AFTER INSERT ON _prom_catalog.metric
            FOR EACH ROW
            EXECUTE PROCEDURE _prom_catalog.make_metric_table();
        
        
        ------------------------
        -- Internal functions --
        ------------------------
        
        -- Return a table name built from a full_name and a suffix.
        -- The full name is truncated so that the suffix could fit in full.
        -- name size will always be exactly 62 chars.
        CREATE OR REPLACE FUNCTION _prom_catalog.pg_name_with_suffix(
                full_name text, suffix text)
            RETURNS name
        AS $func$
            SELECT (substring(full_name for 62-(char_length(suffix)+1)) || '_' || suffix)::name
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.pg_name_with_suffix(text, text) TO prom_reader;
        
        -- Return a new unique name from a name and id.
        -- This tries to use the full_name in full. But if the
        -- full name doesn't fit, generates a new unique name.
        -- Note that there cannot be a collision betweeen a user
        -- defined name and a name with a suffix because user
        -- defined names of length 62 always get a suffix and
        -- conversely, all names with a suffix are length 62.
        
        -- We use a max name length of 62 not 63 because table creation creates an
        -- array type named `_tablename`. We need to ensure that this name is
        -- unique as well, so have to reserve a space for the underscore.
        CREATE OR REPLACE FUNCTION _prom_catalog.pg_name_unique(
                full_name_arg text, suffix text)
            RETURNS name
        AS $func$
            SELECT CASE
                WHEN char_length(full_name_arg) < 62 THEN
                    full_name_arg::name
                ELSE
                    _prom_catalog.pg_name_with_suffix(
                        full_name_arg, suffix
                    )
                END
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.pg_name_unique(text, text) TO prom_reader;
        
        --Creates a new table for a given metric name.
        --This uses up some sequences so should only be called
        --If the table does not yet exist.
        --The function inserts into the metric catalog table,
        --  which causes the make_metric_table trigger to fire,
        --  which actually creates the table
        -- locks: metric, make_metric_table[data table, labels, series partition]
        CREATE OR REPLACE FUNCTION _prom_catalog.create_metric_table(
                metric_name_arg text, OUT id int, OUT table_name name)
        AS $func$
        DECLARE
          new_id int;
          new_table_name name;
        BEGIN
        new_id = nextval(pg_get_serial_sequence('_prom_catalog.metric','id'))::int;
        new_table_name = _prom_catalog.pg_name_unique(metric_name_arg, new_id::text);
        LOOP
            INSERT INTO _prom_catalog.metric (id, metric_name, table_schema, table_name, series_table)
                SELECT  new_id,
                        metric_name_arg,
                        'prom_data',
                        new_table_name,
                        new_table_name
            ON CONFLICT DO NOTHING
            RETURNING _prom_catalog.metric.id, _prom_catalog.metric.table_name
            INTO id, table_name;
            -- under high concurrency the insert may not return anything, so try a select and loop
            -- https://stackoverflow.com/a/15950324
            EXIT WHEN FOUND;
        
            SELECT m.id, m.table_name
            INTO id, table_name
            FROM _prom_catalog.metric m
            WHERE metric_name = metric_name_arg;
        
            EXIT WHEN FOUND;
        END LOOP;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE ;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_metric_table(text) TO prom_writer;
        
        --Creates a new label_key row for a given key.
        --This uses up some sequences so should only be called
        --If the table does not yet exist.
        CREATE OR REPLACE FUNCTION _prom_catalog.create_label_key(
                new_key TEXT, OUT id INT, OUT value_column_name NAME, OUT id_column_name NAME
        )
        AS $func$
        DECLARE
          new_id int;
        BEGIN
        new_id = nextval(pg_get_serial_sequence('_prom_catalog.label_key','id'))::int;
        LOOP
            INSERT INTO _prom_catalog.label_key (id, key, value_column_name, id_column_name)
                SELECT  new_id,
                        new_key,
                        _prom_catalog.pg_name_unique(new_key, new_id::text),
                        _prom_catalog.pg_name_unique(new_key || '_id', format('%s_id', new_id))
            ON CONFLICT DO NOTHING
            RETURNING _prom_catalog.label_key.id, _prom_catalog.label_key.value_column_name, _prom_catalog.label_key.id_column_name
            INTO id, value_column_name, id_column_name;
            -- under high concurrency the insert may not return anything, so try a select and loop
            -- https://stackoverflow.com/a/15950324
            EXIT WHEN FOUND;
        
            SELECT lk.id, lk.value_column_name, lk.id_column_name
            INTO id, value_column_name, id_column_name
            FROM _prom_catalog.label_key lk
            WHERE key = new_key;
        
            EXIT WHEN FOUND;
        END LOOP;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_label_key(TEXT) TO prom_writer;
        
        --Get a label key row if one doesn't yet exist.
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_key(
                key TEXT, OUT id INT, OUT value_column_name NAME, OUT id_column_name NAME)
        AS $func$
           SELECT id, value_column_name, id_column_name
           FROM _prom_catalog.label_key lk
           WHERE lk.key = get_or_create_label_key.key
           UNION ALL
           SELECT *
           FROM _prom_catalog.create_label_key(get_or_create_label_key.key)
           LIMIT 1
        $func$
        LANGUAGE SQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_key(TEXT) to prom_writer;
        
        -- Get a new label array position for a label key. For any metric,
        -- we want the positions to be as compact as possible.
        -- This uses some pretty heavy locks so use sparingly.
        -- locks: label_key_position, data table, series partition (in view creation),
        CREATE OR REPLACE FUNCTION _prom_catalog.get_new_pos_for_key(
                metric_name text, metric_table name, key_name_array text[], is_for_exemplar boolean)
            RETURNS int[]
        AS $func$
        DECLARE
            position int;
            position_array int[];
            position_array_idx int;
            count_new int;
            key_name text;
            next_position int;
            max_position int;
            position_table_name text;
        BEGIN
            If is_for_exemplar THEN
                position_table_name := 'exemplar_label_key_position';
            ELSE
                position_table_name := 'label_key_position';
            END IF;
        
            --Use double check locking here
            --fist optimistic check:
            position_array := NULL;
            EXECUTE FORMAT('SELECT array_agg(p.pos ORDER BY k.ord)
                FROM
                    unnest($1) WITH ORDINALITY as k(key, ord)
                INNER JOIN
                    _prom_catalog.%I p ON
                (
                    p.metric_name = $2
                    AND p.key = k.key
                )', position_table_name) USING key_name_array, metric_name
            INTO position_array;
        
            -- Return the array if the length is same, as the received key_name_array does not contain any new keys.
            IF array_length(key_name_array, 1) = array_length(position_array, 1) THEN
                RETURN position_array;
            END IF;
        
            -- Lock tables for exclusiveness.
            IF NOT is_for_exemplar THEN
                --lock as for ALTER TABLE because we are in effect changing the schema here
                --also makes sure the next_position below is correct in terms of concurrency
                EXECUTE format('LOCK TABLE prom_data_series.%I IN SHARE UPDATE EXCLUSIVE MODE', metric_table);
            ELSE
                LOCK TABLE _prom_catalog.exemplar_label_key_position IN ACCESS EXCLUSIVE MODE;
            END IF;
        
            max_position := NULL;
            EXECUTE FORMAT('SELECT max(pos) + 1
                FROM _prom_catalog.%I
            WHERE metric_name = $1', position_table_name) USING get_new_pos_for_key.metric_name
            INTO max_position;
        
            IF max_position IS NULL THEN
                IF is_for_exemplar THEN
                    max_position := 1;
                ELSE
                    -- Specific to label_key_position table only.
                    max_position := 2; -- element 1 reserved for __name__
                END IF;
            END IF;
        
            position_array := array[]::int[];
            position_array_idx := 1;
            count_new := 0;
            FOREACH key_name IN ARRAY key_name_array LOOP
                --second check after lock
                position := NULL;
                EXECUTE FORMAT('SELECT pos FROM _prom_catalog.%I lp
                WHERE
                    lp.metric_name = $1
                AND
                    lp.key = $2', position_table_name) USING metric_name, key_name
                INTO position;
        
                IF position IS NOT NULL THEN
                    position_array[position_array_idx] := position;
                    position_array_idx := position_array_idx + 1;
                    CONTINUE;
                END IF;
                -- key_name does not exists in the position table.
                count_new := count_new + 1;
                IF (NOT is_for_exemplar) AND (key_name = '__name__') THEN
                    next_position := 1; -- 1-indexed arrays, __name__ as first element
                ELSE
                    next_position := max_position;
                    max_position := max_position + 1;
                END IF;
        
                IF NOT is_for_exemplar THEN
                    PERFORM _prom_catalog.get_or_create_label_key(key_name);
                END IF;
        
                position := NULL;
                EXECUTE FORMAT('INSERT INTO _prom_catalog.%I
                VALUES ($1, $2, $3)
                    ON CONFLICT DO NOTHING
                RETURNING pos', position_table_name) USING metric_name, key_name, next_position
                INTO position;
        
                IF position IS NULL THEN
                    RAISE 'Could not find a new position. (is_for_exemplar=%)', is_for_exemplar;
                END IF;
                position_array[position_array_idx] := position;
                position_array_idx := position_array_idx + 1;
            END LOOP;
        
            IF NOT is_for_exemplar AND count_new > 0 THEN
                --note these functions are expensive in practice so they
                --must be run once across a collection of keys
                PERFORM _prom_catalog.create_series_view(metric_name);
                PERFORM _prom_catalog.create_metric_view(metric_name);
            END IF;
        
            RETURN position_array;
        END
        $func$
        LANGUAGE PLPGSQL
        --security definer needed to lock the series table
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.get_new_pos_for_key(text, name, text[], boolean) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_new_pos_for_key(text, name, text[], boolean) TO prom_reader; -- For exemplars querying.
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_new_pos_for_key(text, name, text[], boolean) TO prom_writer;
        
        --should only be called after a check that that the label doesn't exist
        CREATE OR REPLACE FUNCTION _prom_catalog.get_new_label_id(key_name text, value_name text, OUT id INT)
        AS $func$
        BEGIN
        LOOP
            INSERT INTO
                _prom_catalog.label(key, value)
            VALUES
                (key_name,value_name)
            ON CONFLICT DO NOTHING
            RETURNING _prom_catalog.label.id
            INTO id;
        
            EXIT WHEN FOUND;
        
            SELECT
                l.id
            INTO id
            FROM _prom_catalog.label l
            WHERE
                key = key_name AND
                value = value_name;
        
            EXIT WHEN FOUND;
        END LOOP;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_new_label_id(text, text) to prom_writer;
        
        --wrapper around jsonb_each_text to give a better row_estimate
        --for labels (10 not 100)
        CREATE OR REPLACE FUNCTION _prom_catalog.label_jsonb_each_text(js jsonb, OUT key text, OUT value text)
         RETURNS SETOF record
         LANGUAGE SQL
         IMMUTABLE PARALLEL SAFE STRICT ROWS 10
        AS $function$ SELECT (jsonb_each_text(js)).* $function$;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_jsonb_each_text(jsonb) to prom_reader;
        
        --wrapper around unnest to give better row estimate (10 not 100)
        CREATE OR REPLACE FUNCTION _prom_catalog.label_unnest(label_array anyarray)
         RETURNS SETOF anyelement
         LANGUAGE SQL
         IMMUTABLE PARALLEL SAFE STRICT ROWS 10
        AS $function$ SELECT unnest(label_array) $function$;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_unnest(anyarray) to prom_reader;
        
        -- safe_approximate_row_count returns the approximate row count of a hypertable if timescaledb is installed
        -- else returns the approximate row count in the normal table. This prevents errors in approximate count calculation
        -- if timescaledb is not installed, which is the case in plain postgres support.
        CREATE OR REPLACE FUNCTION _prom_catalog.safe_approximate_row_count(table_name_input REGCLASS) RETURNS BIGINT
            LANGUAGE PLPGSQL
        AS
        $$
        BEGIN
            IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                RETURN (SELECT * FROM approximate_row_count(table_name_input));
            ELSE
                IF _prom_catalog.is_timescaledb_installed()
                    AND (SELECT count(*) > 0
                        FROM _timescaledb_catalog.hypertable
                        WHERE format('%I.%I', schema_name, table_name)::regclass=table_name_input)
                THEN
                        RETURN (SELECT row_estimate FROM hypertable_approximate_row_count(table_name_input));
                END IF;
                RETURN (SELECT reltuples::BIGINT FROM pg_class WHERE oid=table_name_input);
            END IF;
        END;
        $$;
        GRANT EXECUTE ON FUNCTION _prom_catalog.safe_approximate_row_count(regclass) to prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.delete_series_catalog_row(
            metric_table name,
            series_ids bigint[]
        ) RETURNS VOID AS
        $$
        BEGIN
            EXECUTE FORMAT(
                'UPDATE prom_data_series.%1$I SET delete_epoch = current_epoch+1 FROM _prom_catalog.ids_epoch WHERE delete_epoch IS NULL AND id = ANY($1)',
                metric_table
            ) USING series_ids;
            RETURN;
        END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _prom_catalog.delete_series_catalog_row(name, bigint[]) to prom_modifier;
        
        ---------------------------------------------------
        ------------------- Public APIs -------------------
        ---------------------------------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metric_table_name_if_exists(
                schema text, metric_name text)
            RETURNS TABLE (id int, table_name name, table_schema name, series_table name, is_view boolean)
        AS $func$
        DECLARE
            rows_found bigint;
        BEGIN
            IF get_metric_table_name_if_exists.schema != '' AND get_metric_table_name_if_exists.schema IS NOT NULL THEN
                RETURN QUERY SELECT m.id, m.table_name::name, m.table_schema::name, m.series_table::name, m.is_view
                FROM _prom_catalog.metric m
                WHERE m.table_schema = get_metric_table_name_if_exists.schema
                AND m.metric_name = get_metric_table_name_if_exists.metric_name;
                RETURN;
            END IF;
        
            RETURN QUERY SELECT m.id, m.table_name::name, m.table_schema::name, m.series_table::name, m.is_view
            FROM _prom_catalog.metric m
            WHERE m.table_schema = 'prom_data'
            AND m.metric_name = get_metric_table_name_if_exists.metric_name;
        
            IF FOUND THEN
                RETURN;
            END IF;
        
            SELECT count(*)
            INTO rows_found
            FROM _prom_catalog.metric m
            WHERE m.metric_name = get_metric_table_name_if_exists.metric_name;
        
            IF rows_found <= 1 THEN
                RETURN QUERY SELECT m.id, m.table_name::name, m.table_schema::name, m.series_table::name, m.is_view
                FROM _prom_catalog.metric m
                WHERE m.metric_name = get_metric_table_name_if_exists.metric_name;
                RETURN;
            END IF;
        
            RAISE EXCEPTION 'found multiple metrics with same name in different schemas, please specify exact schema name';
        END
        $func$
        LANGUAGE PLPGSQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metric_table_name_if_exists(text, text) to prom_reader;
        
        -- Public function to get the name of the table for a given metric
        -- This will create the metric table if it does not yet exist.
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_metric_table_name(
                metric_name text, OUT id int, OUT table_name name, OUT possibly_new BOOLEAN)
        AS $func$
           SELECT id, table_name::name, false
           FROM _prom_catalog.metric m
           WHERE m.metric_name = get_or_create_metric_table_name.metric_name
           AND m.table_schema = 'prom_data'
           UNION ALL
           SELECT *, true
           FROM _prom_catalog.create_metric_table(get_or_create_metric_table_name.metric_name)
           LIMIT 1
        $func$
        LANGUAGE SQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_metric_table_name(text) to prom_writer;
        
        --public function to get the array position for a label key
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_key_pos(
                metric_name text, key text)
            RETURNS INT
        AS $$
            --only executes the more expensive PLPGSQL function if the label doesn't exist
            SELECT
                pos
            FROM
                _prom_catalog.label_key_position lkp
            WHERE
                lkp.metric_name = get_or_create_label_key_pos.metric_name
                AND lkp.key = get_or_create_label_key_pos.key
            UNION ALL
            SELECT
                (_prom_catalog.get_new_pos_for_key(get_or_create_label_key_pos.metric_name, m.table_name, array[get_or_create_label_key_pos.key], false))[1]
            FROM 
                _prom_catalog.get_or_create_metric_table_name(get_or_create_label_key_pos.metric_name) m
            LIMIT 1
        $$
        LANGUAGE SQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_key_pos(text, text) to prom_writer;
        
        -- label_cardinality returns the cardinality of a label_pair id in the series table.
        -- In simple terms, it means the number of times a label_pair/label_matcher is used
        -- across all the series.
        CREATE OR REPLACE FUNCTION prom_api.label_cardinality(label_id INT)
            RETURNS INT
            LANGUAGE SQL
        AS
        $$
            SELECT count(*)::INT FROM _prom_catalog.series s WHERE s.labels @> array[label_id];
        $$ STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION prom_api.label_cardinality(int) to prom_reader;
        
        --public function to get the array position for a label key if it exists
        --useful in case users want to group by a specific label key
        CREATE OR REPLACE FUNCTION prom_api.label_key_position(
                metric_name text, key text)
            RETURNS INT
        AS $$
            SELECT
                pos
            FROM
                _prom_catalog.label_key_position lkp
            WHERE
                lkp.metric_name = label_key_position.metric_name
                AND lkp.key = label_key_position.key
            LIMIT 1
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION prom_api.label_key_position(text, text) to prom_reader;
        
        -- drop_metric deletes a metric and related series hypertable from the database along with the related series, views and unreferenced labels.
        CREATE OR REPLACE FUNCTION prom_api.drop_metric(metric_name_to_be_dropped text) RETURNS VOID
        AS
        $$
            DECLARE
                hypertable_name TEXT;
                deletable_metric_id INTEGER;
            BEGIN
                IF (SELECT NOT pg_try_advisory_xact_lock(5585198506344173278)) THEN
                    RAISE NOTICE 'drop_metric can run only when no Promscale connectors are running. Please shutdown the Promscale connectors';
                    PERFORM pg_advisory_xact_lock(5585198506344173278);
                END IF;
                SELECT table_name, id INTO hypertable_name, deletable_metric_id FROM _prom_catalog.metric WHERE metric_name=metric_name_to_be_dropped;
                RAISE NOTICE 'deleting "%" metric with metric_id as "%" and table_name as "%"', metric_name_to_be_dropped, deletable_metric_id, hypertable_name;
                EXECUTE FORMAT('DROP VIEW prom_series.%1$I;', hypertable_name);
                EXECUTE FORMAT('DROP VIEW prom_metric.%1$I;', hypertable_name);
                EXECUTE FORMAT('DROP TABLE prom_data_series.%1$I;', hypertable_name);
                EXECUTE FORMAT('DROP TABLE prom_data.%1$I;', hypertable_name);
                DELETE FROM _prom_catalog.metric WHERE id=deletable_metric_id;
                -- clean up unreferenced labels, label_keys and its position.
                DELETE FROM _prom_catalog.label_key_position WHERE metric_name=metric_name_to_be_dropped;
                DELETE FROM _prom_catalog.label_key WHERE key NOT IN (select key from _prom_catalog.label_key_position);
            END;
        $$
        LANGUAGE plpgsql;
        
        --Get the label_id for a key, value pair
        -- no need for a get function only as users will not be using ids directly
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_id(
                key_name text, value_name text)
            RETURNS INT
        AS $$
            --first select to prevent sequence from being used up
            --unnecessarily
            SELECT
                id
            FROM _prom_catalog.label
            WHERE
                key = key_name AND
                value = value_name
            UNION ALL
            SELECT
                _prom_catalog.get_new_label_id(key_name, value_name)
            LIMIT 1
        $$
        LANGUAGE SQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_id(text, text) to prom_writer;
        
        --This generates a position based array from the jsonb
        --0s represent keys that are not set (we don't use NULL
        --since intarray does not support it).
        --This is not super performance critical since this
        --is only used on the insert client and is cached there.
        --Read queries can use the eq function or others with the jsonb to find equality
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_array(js jsonb)
        RETURNS prom_api.label_array AS $$
            WITH idx_val AS (
                SELECT
                    -- only call the functions to create new key positions
                    -- and label ids if they don't exist (for performance reasons)
                    coalesce(lkp.pos,
                      _prom_catalog.get_or_create_label_key_pos(js->>'__name__', e.key)) idx,
                    coalesce(l.id,
                      _prom_catalog.get_or_create_label_id(e.key, e.value)) val
                FROM label_jsonb_each_text(js) e
                     LEFT JOIN _prom_catalog.label l
                       ON (l.key = e.key AND l.value = e.value)
                    LEFT JOIN _prom_catalog.label_key_position lkp
                       ON
                       (
                          lkp.metric_name = js->>'__name__' AND
                          lkp.key = e.key
                       )
                --needs to order by key to prevent deadlocks if get_or_create_label_id is creating labels
                ORDER BY l.key
            )
            SELECT ARRAY(
                SELECT coalesce(idx_val.val, 0)
                FROM
                    generate_series(
                            1,
                            (SELECT max(idx) FROM idx_val)
                    ) g
                    LEFT JOIN idx_val ON (idx_val.idx = g)
            )::prom_api.label_array
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION _prom_catalog.get_or_create_label_array(jsonb)
        IS 'converts a jsonb to a label array';
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_array(jsonb) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_array(metric_name TEXT, label_keys text[], label_values text[])
        RETURNS prom_api.label_array AS $$
            WITH idx_val AS (
                SELECT
                    -- only call the functions to create new key positions
                    -- and label ids if they don't exist (for performance reasons)
                    coalesce(lkp.pos,
                      _prom_catalog.get_or_create_label_key_pos(get_or_create_label_array.metric_name, kv.key)) idx,
                    coalesce(l.id,
                      _prom_catalog.get_or_create_label_id(kv.key, kv.value)) val
                FROM ROWS FROM(unnest(label_keys), UNNEST(label_values)) AS kv(key, value)
                    LEFT JOIN _prom_catalog.label l
                       ON (l.key = kv.key AND l.value = kv.value)
                    LEFT JOIN _prom_catalog.label_key_position lkp
                       ON
                       (
                          lkp.metric_name = get_or_create_label_array.metric_name AND
                          lkp.key = kv.key
                       )
                ORDER BY kv.key
            )
            SELECT ARRAY(
                SELECT coalesce(idx_val.val, 0)
                FROM
                    generate_series(
                            1,
                            (SELECT max(idx) FROM idx_val)
                    ) g
                    LEFT JOIN idx_val ON (idx_val.idx = g)
            )::prom_api.label_array
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION _prom_catalog.get_or_create_label_array(text, text[], text[])
        IS 'converts a metric name, array of keys, and array of values to a label array';
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_array(TEXT, text[], text[]) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_label_ids(metric_name TEXT, metric_table NAME, label_keys text[], label_values text[])
        RETURNS TABLE(pos int[], id int[], label_key text[], label_value text[]) AS $$
                WITH cte as (
                SELECT
                    -- only call the functions to create new key positions
                    -- and label ids if they don't exist (for performance reasons)
                    lkp.pos as known_pos,
                    coalesce(l.id, _prom_catalog.get_or_create_label_id(kv.key, kv.value)) label_id,
                    kv.key key_str,
                    kv.value val_str
                FROM ROWS FROM(unnest(label_keys), UNNEST(label_values)) AS kv(key, value)
                    LEFT JOIN _prom_catalog.label l
                       ON (l.key = kv.key AND l.value = kv.value)
                    LEFT JOIN _prom_catalog.label_key_position lkp ON
                    (
                            lkp.metric_name = get_or_create_label_ids.metric_name AND
                            lkp.key = kv.key
                    )
                ORDER BY kv.key, kv.value
                )
                SELECT
                   case when count(*) = count(known_pos) Then
                      array_agg(known_pos)
                   else
                      _prom_catalog.get_new_pos_for_key(get_or_create_label_ids.metric_name, get_or_create_label_ids.metric_table, array_agg(key_str), false)
                   end as poss,
                   array_agg(label_id) as label_ids,
                   array_agg(key_str) as keys,
                   array_agg(val_str) as vals
                FROM cte
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION _prom_catalog.get_or_create_label_ids(text, name, text[], text[])
        IS 'converts a metric name, array of keys, and array of values to a list of label ids';
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_label_ids(TEXT, NAME, text[], text[]) TO prom_writer;
        
        
        -- Returns ids, keys and values for a label_array
        -- the order may not be the same as the original labels
        -- This function needs to be optimized for performance
        CREATE OR REPLACE FUNCTION prom_api.labels_info(INOUT labels INT[], OUT keys text[], OUT vals text[])
        AS $$
            SELECT
                array_agg(l.id), array_agg(l.key), array_agg(l.value)
            FROM
              _prom_catalog.label_unnest(labels) label_id
              INNER JOIN _prom_catalog.label l ON (l.id = label_id)
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.labels_info(INT[])
        IS 'converts an array of label ids to three arrays: one for ids, one for keys and another for values';
        GRANT EXECUTE ON FUNCTION prom_api.labels_info(INT[]) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.key_value_array(labels prom_api.label_array, OUT keys text[], OUT vals text[])
        AS $$
            SELECT keys, vals FROM prom_api.labels_info(labels)
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.key_value_array(prom_api.label_array)
        IS 'converts a labels array to two arrays: one for keys and another for values';
        GRANT EXECUTE ON FUNCTION prom_api.key_value_array(prom_api.label_array) TO prom_reader;
        
        --Returns the jsonb for a series defined by a label_array
        CREATE OR REPLACE FUNCTION prom_api.jsonb(labels prom_api.label_array)
        RETURNS jsonb AS $$
            SELECT
                jsonb_object(keys, vals)
            FROM
              prom_api.key_value_array(labels)
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.jsonb(labels prom_api.label_array)
        IS 'converts a labels array to a JSONB object';
        GRANT EXECUTE ON FUNCTION prom_api.jsonb(prom_api.label_array) TO prom_reader;
        
        --Returns the label_array given a series_id
        CREATE OR REPLACE FUNCTION prom_api.labels(series_id BIGINT)
        RETURNS prom_api.label_array AS $$
            SELECT
                labels
            FROM
                _prom_catalog.series
            WHERE id = series_id
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.labels(series_id BIGINT)
        IS 'fetches labels array for the given series id';
        GRANT EXECUTE ON FUNCTION prom_api.labels(series_id BIGINT) TO prom_reader;
        
        --Do not call before checking that the series does not yet exist
        CREATE OR REPLACE FUNCTION _prom_catalog.create_series(
                metric_id int,
                metric_table_name NAME,
                label_array prom_api.label_array,
                OUT series_id BIGINT)
        AS $func$
        DECLARE
           new_series_id bigint;
        BEGIN
          new_series_id = nextval('_prom_catalog.series_id');
        LOOP
            EXECUTE format ($$
                INSERT INTO prom_data_series.%I(id, metric_id, labels)
                SELECT $1, $2, $3
                ON CONFLICT DO NOTHING
                RETURNING id
            $$, metric_table_name)
            INTO series_id
            USING new_series_id, metric_id, label_array;
        
            EXIT WHEN series_id is not null;
        
            EXECUTE format($$
                SELECT id
                FROM prom_data_series.%I
                WHERE labels = $1
            $$, metric_table_name)
            INTO series_id
            USING label_array;
        
            EXIT WHEN series_id is not null;
        END LOOP;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_series(int, name, prom_api.label_array) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.resurrect_series_ids(metric_table name, series_id bigint)
            RETURNS VOID
        AS $func$
        BEGIN
            EXECUTE FORMAT($query$
                UPDATE prom_data_series.%1$I
                SET delete_epoch = NULL
                WHERE id = $1
            $query$, metric_table) using series_id;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.resurrect_series_ids(name, bigint) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.resurrect_series_ids(name, bigint) TO prom_writer;
        
        -- There shouldn't be a need to have a read only version of this as we'll use
        -- the eq or other matcher functions to find series ids like this. However,
        -- there are possible use cases that need the series id directly for performance
        -- that we might want to see if we need to support, in which case a
        -- read only version might be useful in future.
        CREATE OR REPLACE  FUNCTION _prom_catalog.get_or_create_series_id(label jsonb)
        RETURNS BIGINT AS $$
        DECLARE
          series_id bigint;
          table_name name;
          metric_id int;
        BEGIN
           --See get_or_create_series_id_for_kv_array for notes about locking
           SELECT mtn.id, mtn.table_name FROM _prom_catalog.get_or_create_metric_table_name(label->>'__name__') mtn
           INTO metric_id, table_name;
        
           LOCK TABLE ONLY _prom_catalog.series in ACCESS SHARE mode;
        
           EXECUTE format($query$
            WITH cte AS (
                SELECT _prom_catalog.get_or_create_label_array($1)
            ), existing AS (
                SELECT
                    id,
                    CASE WHEN delete_epoch IS NOT NULL THEN
                        _prom_catalog.resurrect_series_ids(%1$L, id)
                    END
                FROM prom_data_series.%1$I as series
                WHERE labels = (SELECT * FROM cte)
            )
            SELECT id FROM existing
            UNION ALL
            SELECT _prom_catalog.create_series(%2$L, %1$L, (SELECT * FROM cte))
            LIMIT 1
           $query$, table_name, metric_id)
           USING label
           INTO series_id;
        
           RETURN series_id;
        END
        $$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION _prom_catalog.get_or_create_series_id(jsonb)
        IS 'returns the series id that exactly matches a JSONB of labels';
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_series_id(jsonb) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_series_id_for_kv_array(metric_name TEXT, label_keys text[], label_values text[], OUT table_name NAME, OUT series_id BIGINT)
        AS $func$
        DECLARE
          metric_id int;
        BEGIN
           --need to make sure the series partition exists
           SELECT mtn.id, mtn.table_name FROM _prom_catalog.get_or_create_metric_table_name(metric_name) mtn
           INTO metric_id, table_name;
        
           -- the data table could be locked during label key creation
           -- and must be locked before the series parent according to lock ordering
           EXECUTE format($query$
                LOCK TABLE ONLY prom_data.%1$I IN ACCESS SHARE MODE
            $query$, table_name);
        
           EXECUTE format($query$
            WITH cte AS (
                SELECT _prom_catalog.get_or_create_label_array($1, $2, $3)
            ), existing AS (
                SELECT
                    id,
                    CASE WHEN delete_epoch IS NOT NULL THEN
                        _prom_catalog.resurrect_series_ids(%1$L, id)
                    END
                FROM prom_data_series.%1$I as series
                WHERE labels = (SELECT * FROM cte)
            )
            SELECT id FROM existing
            UNION ALL
            SELECT _prom_catalog.create_series(%2$L, %1$L, (SELECT * FROM cte))
            LIMIT 1
           $query$, table_name, metric_id)
           USING metric_name, label_keys, label_values
           INTO series_id;
        
           RETURN;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_series_id_for_kv_array(TEXT, text[], text[]) TO prom_writer;
        
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_or_create_series_id_for_label_array(metric_id INT, table_name NAME, larray prom_api.label_array, OUT series_id BIGINT)
        AS $func$
        BEGIN
           EXECUTE format($query$
            WITH existing AS (
                SELECT
                    id,
                    CASE WHEN delete_epoch IS NOT NULL THEN
                        _prom_catalog.resurrect_series_ids(%1$L, id)
                    END
                FROM prom_data_series.%1$I as series
                WHERE labels = $1
            )
            SELECT id FROM existing
            UNION ALL
            SELECT _prom_catalog.create_series(%2$L, %1$L, $1)
            LIMIT 1
           $query$, table_name, metric_id)
           USING larray
           INTO series_id;
        
           RETURN;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_or_create_series_id_for_label_array(INT, NAME, prom_api.label_array) TO prom_writer;
        
        --
        -- Parameter manipulation functions
        --
        
        CREATE OR REPLACE FUNCTION _prom_catalog.set_chunk_interval_on_metric_table(metric_name TEXT, new_interval INTERVAL)
        RETURNS void
        AS $func$
        BEGIN
            IF NOT _prom_catalog.is_timescaledb_installed() THEN
                RAISE EXCEPTION 'cannot set chunk time interval without timescaledb installed';
            END IF;
            --set interval while adding 1% of randomness to the interval so that chunks are not aligned so that
            --chunks are staggered for compression jobs.
            EXECUTE public.set_chunk_time_interval(
                format('prom_data.%I',(SELECT table_name FROM _prom_catalog.get_or_create_metric_table_name(metric_name)))::regclass,
                 _prom_catalog.get_staggered_chunk_interval(new_interval));
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.set_chunk_interval_on_metric_table(TEXT, INTERVAL) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.set_chunk_interval_on_metric_table(TEXT, INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_default_chunk_interval(chunk_interval INTERVAL)
        RETURNS BOOLEAN
        AS $$
            INSERT INTO _prom_catalog.default(key, value) VALUES('chunk_interval', chunk_interval::text)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
        
            SELECT _prom_catalog.set_chunk_interval_on_metric_table(metric_name, chunk_interval)
            FROM _prom_catalog.metric
            WHERE default_chunk_interval;
        
            SELECT true;
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_default_chunk_interval(INTERVAL)
        IS 'set the chunk interval for any metrics (existing and new) without an explicit override';
        GRANT EXECUTE ON FUNCTION prom_api.set_default_chunk_interval(INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_metric_chunk_interval(metric_name TEXT, chunk_interval INTERVAL)
        RETURNS BOOLEAN
        AS $func$
            --use get_or_create_metric_table_name because we want to be able to set /before/ any data is ingested
            --needs to run before update so row exists before update.
            SELECT _prom_catalog.get_or_create_metric_table_name(set_metric_chunk_interval.metric_name);
        
            UPDATE _prom_catalog.metric SET default_chunk_interval = false
            WHERE id IN (SELECT id FROM _prom_catalog.get_metric_table_name_if_exists('prom_data', set_metric_chunk_interval.metric_name));
        
            SELECT _prom_catalog.set_chunk_interval_on_metric_table(metric_name, chunk_interval);
        
            SELECT true;
        $func$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_metric_chunk_interval(TEXT, INTERVAL)
        IS 'set a chunk interval for a specific metric (this overrides the default)';
        GRANT EXECUTE ON FUNCTION prom_api.set_metric_chunk_interval(TEXT, INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.reset_metric_chunk_interval(metric_name TEXT)
        RETURNS BOOLEAN
        AS $func$
            UPDATE _prom_catalog.metric SET default_chunk_interval = true
            WHERE id = (SELECT id FROM _prom_catalog.get_metric_table_name_if_exists('prom_data', metric_name));
        
            SELECT _prom_catalog.set_chunk_interval_on_metric_table(metric_name,
                _prom_catalog.get_default_chunk_interval());
        
            SELECT true;
        $func$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.reset_metric_chunk_interval(TEXT)
        IS 'resets the chunk interval for a specific metric to using the default';
        GRANT EXECUTE ON FUNCTION prom_api.reset_metric_chunk_interval(TEXT) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metric_retention_period(schema_name TEXT, metric_name TEXT)
        RETURNS INTERVAL
        AS $$
            SELECT COALESCE(m.retention_period, _prom_catalog.get_default_retention_period())
            FROM _prom_catalog.metric m
            WHERE id IN (SELECT id FROM _prom_catalog.get_metric_table_name_if_exists(schema_name, get_metric_retention_period.metric_name))
            UNION ALL
            SELECT _prom_catalog.get_default_retention_period()
            LIMIT 1
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metric_retention_period(TEXT, TEXT) TO prom_reader;
        
        -- convenience function for returning retention period of raw metrics
        -- without the need to specify the schema
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metric_retention_period(metric_name TEXT)
        RETURNS INTERVAL
        AS $$
            SELECT *
            FROM _prom_catalog.get_metric_retention_period('prom_data', metric_name)
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metric_retention_period(TEXT) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.set_default_retention_period(retention_period INTERVAL)
        RETURNS BOOLEAN
        AS $$
            INSERT INTO _prom_catalog.default(key, value) VALUES('retention_period', retention_period::text)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
            SELECT true;
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_default_retention_period(INTERVAL)
        IS 'set the retention period for any metrics (existing and new) without an explicit override';
        GRANT EXECUTE ON FUNCTION prom_api.set_default_retention_period(INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_metric_retention_period(schema_name TEXT, metric_name TEXT, new_retention_period INTERVAL)
        RETURNS BOOLEAN
        AS $func$
        DECLARE
            r _prom_catalog.metric;
            _is_cagg BOOLEAN;
            _cagg_schema NAME;
            _cagg_name NAME;
        BEGIN
            --use get_or_create_metric_table_name because we want to be able to set /before/ any data is ingested
            --needs to run before update so row exists before update.
            PERFORM _prom_catalog.get_or_create_metric_table_name(set_metric_retention_period.metric_name)
            WHERE schema_name = 'prom_data';
        
            --check if its a metric view with cagg
            SELECT is_cagg, cagg_schema, cagg_name
            INTO _is_cagg, _cagg_schema, _cagg_name
            FROM _prom_catalog.get_cagg_info(schema_name, metric_name);
        
            IF NOT _is_cagg OR (_cagg_name = metric_name AND _cagg_schema = schema_name) THEN
                UPDATE _prom_catalog.metric m SET retention_period = new_retention_period
                WHERE m.table_schema = schema_name
                AND m.metric_name = set_metric_retention_period.metric_name;
        
                RETURN true;
            END IF;
        
            --handles 2-step aggregatop
            RAISE NOTICE 'Setting data retention period for all metrics with underlying continuous aggregate %.%', _cagg_schema, _cagg_name;
        
            FOR r IN
                SELECT m.*
                FROM information_schema.view_table_usage v
                INNER JOIN _prom_catalog.metric m
                  ON (m.table_name = v.view_name AND m.table_schema = v.view_schema)
                WHERE v.table_name = _cagg_name
                  AND v.table_schema = _cagg_schema
            LOOP
                RAISE NOTICE 'Setting data retention for metrics %.%', r.table_schema, r.metric_name;
        
                UPDATE _prom_catalog.metric m
                SET retention_period = new_retention_period
                WHERE m.table_schema = r.table_schema
                AND m.metric_name = r.metric_name;
            END LOOP;
        
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_metric_retention_period(TEXT, TEXT, INTERVAL)
        IS 'set a retention period for a specific metric (this overrides the default)';
        GRANT EXECUTE ON FUNCTION prom_api.set_metric_retention_period(TEXT, TEXT, INTERVAL)TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_metric_retention_period(metric_name TEXT, new_retention_period INTERVAL)
        RETURNS BOOLEAN
        AS $func$
            SELECT prom_api.set_metric_retention_period('prom_data', metric_name, new_retention_period);
        $func$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_metric_retention_period(TEXT, INTERVAL)
        IS 'set a retention period for a specific raw metric in default schema (this overrides the default)';
        GRANT EXECUTE ON FUNCTION prom_api.set_metric_retention_period(TEXT, INTERVAL)TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.reset_metric_retention_period(schema_name TEXT, metric_name TEXT)
        RETURNS BOOLEAN
        AS $func$
        DECLARE
            r _prom_catalog.metric;
            _is_cagg BOOLEAN;
            _cagg_schema NAME;
            _cagg_name NAME;
        BEGIN
        
            --check if its a metric view with cagg
            SELECT is_cagg, cagg_schema, cagg_name
            INTO _is_cagg, _cagg_schema, _cagg_name
            FROM _prom_catalog.get_cagg_info(schema_name, metric_name);
        
            IF NOT _is_cagg OR (_cagg_name = metric_name AND _cagg_schema = schema_name) THEN
                UPDATE _prom_catalog.metric m SET retention_period = NULL
                WHERE m.table_schema = schema_name
                AND m.metric_name = reset_metric_retention_period.metric_name;
        
                RETURN true;
            END IF;
        
            RAISE NOTICE 'Resetting data retention period for all metrics with underlying continuous aggregate %.%', _cagg_schema, cagg_name;
        
            FOR r IN
                SELECT m.*
                FROM information_schema.view_table_usage v
                INNER JOIN _prom_catalog.metric m
                  ON (m.table_name = v.view_name AND m.table_schema = v.view_schema)
                WHERE v.table_name = _cagg_name
                  AND v.table_schema = _cagg_schem
            LOOP
                RAISE NOTICE 'Resetting data retention for metrics %.%', r.table_schema, r.metric_name;
        
                UPDATE _prom_catalog.metric m
                SET retention_period = NULL
                WHERE m.table_schema = r.table_schema
                AND m.metric_name = r.metric_name;
            END LOOP;
        
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION prom_api.reset_metric_retention_period(TEXT, TEXT)
        IS 'resets the retention period for a specific metric to using the default';
        GRANT EXECUTE ON FUNCTION prom_api.reset_metric_retention_period(TEXT, TEXT) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.reset_metric_retention_period(metric_name TEXT)
        RETURNS BOOLEAN
        AS $func$
            SELECT prom_api.reset_metric_retention_period('prom_data', metric_name);
        $func$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION prom_api.reset_metric_retention_period(TEXT)
        IS 'resets the retention period for a specific raw metric in the default schema to using the default retention period';
        GRANT EXECUTE ON FUNCTION prom_api.reset_metric_retention_period(TEXT) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metric_compression_setting(metric_name TEXT)
        RETURNS BOOLEAN
        AS $$
        DECLARE
            can_compress boolean;
            result boolean;
            metric_table_name text;
        BEGIN
            SELECT exists(select * from pg_proc where proname = 'compress_chunk')
            INTO STRICT can_compress;
        
            IF NOT can_compress THEN
                RETURN FALSE;
            END IF;
        
            SELECT table_name
            INTO STRICT metric_table_name
            FROM _prom_catalog.get_metric_table_name_if_exists('prom_data', metric_name);
        
            IF _prom_catalog.get_timescale_major_version() >= 2  THEN
                SELECT compression_enabled
                FROM timescaledb_information.hypertables
                WHERE hypertable_schema ='prom_data'
                  AND hypertable_name = metric_table_name
                INTO STRICT result;
            ELSE
                SELECT EXISTS (
                    SELECT FROM _timescaledb_catalog.hypertable h
                    WHERE h.schema_name = 'prom_data'
                    AND h.table_name = metric_table_name
                    AND h.compressed_hypertable_id IS NOT NULL)
                INTO result;
            END IF;
            RETURN result;
        END
        $$
        LANGUAGE PLPGSQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metric_compression_setting(TEXT) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.set_default_compression_setting(compression_setting BOOLEAN)
        RETURNS BOOLEAN
        AS $$
        DECLARE
            can_compress BOOLEAN;
        BEGIN
            IF compression_setting = _prom_catalog.get_default_compression_setting() THEN
                RETURN TRUE;
            END IF;
        
            SELECT exists(select * from pg_proc where proname = 'compress_chunk')
            INTO STRICT can_compress;
        
            IF NOT can_compress AND compression_setting THEN
                RAISE EXCEPTION 'Cannot enable metrics compression, feature not found';
            END IF;
        
            INSERT INTO _prom_catalog.default(key, value) VALUES('metric_compression', compression_setting::text)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
        
            PERFORM prom_api.set_compression_on_metric_table(table_name, compression_setting)
            FROM _prom_catalog.metric
            WHERE default_compression;
            RETURN true;
        END
        $$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_default_compression_setting(BOOLEAN)
        IS 'set the compression setting for any metrics (existing and new) without an explicit override';
        GRANT EXECUTE ON FUNCTION prom_api.set_default_compression_setting(BOOLEAN) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_metric_compression_setting(metric_name TEXT, new_compression_setting BOOLEAN)
        RETURNS BOOLEAN
        AS $func$
        DECLARE
            can_compress boolean;
            metric_table_name text;
        BEGIN
            --if already set to desired value, nothing to do
            IF _prom_catalog.get_metric_compression_setting(metric_name) = new_compression_setting THEN
                RETURN TRUE;
            END IF;
        
            SELECT exists(select * from pg_proc where proname = 'compress_chunk')
            INTO STRICT can_compress;
        
            --if compression is missing, cannot enable it
            IF NOT can_compress AND new_compression_setting THEN
                RAISE EXCEPTION 'Cannot enable metrics compression, feature not found';
            END IF;
        
            --use get_or_create_metric_table_name because we want to be able to set /before/ any data is ingested
            --needs to run before update so row exists before update.
            SELECT table_name
            INTO STRICT metric_table_name
            FROM _prom_catalog.get_or_create_metric_table_name(set_metric_compression_setting.metric_name);
        
            PERFORM prom_api.set_compression_on_metric_table(metric_table_name, new_compression_setting);
        
            UPDATE _prom_catalog.metric
            SET default_compression = false
            WHERE table_name = metric_table_name;
        
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION prom_api.set_metric_compression_setting(TEXT, BOOLEAN)
        IS 'set a compression setting for a specific metric (this overrides the default)';
        GRANT EXECUTE ON FUNCTION prom_api.set_metric_compression_setting(TEXT, BOOLEAN) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.set_compression_on_metric_table(metric_table_name TEXT, compression_setting BOOLEAN)
        RETURNS void
        AS $func$
        DECLARE
        BEGIN
            IF _prom_catalog.is_timescaledb_oss() THEN
                RAISE NOTICE 'Compression not available in TimescaleDB-OSS. Cannot set compression on "%" metric table name', metric_table_name;
                RETURN;
            END IF;
            IF compression_setting THEN
                EXECUTE format($$
                    ALTER TABLE prom_data.%I SET (
                        timescaledb.compress,
                        timescaledb.compress_segmentby = 'series_id',
                        timescaledb.compress_orderby = 'time, value'
                    ); $$, metric_table_name);
        
                --rc4 of multinode doesn't properly hand down compression when turned on
                --inside of a function; this gets around that.
                IF _prom_catalog.is_multinode() THEN
                    CALL public.distributed_exec(
                        format($$
                        ALTER TABLE prom_data.%I SET (
                            timescaledb.compress,
                           timescaledb.compress_segmentby = 'series_id',
                           timescaledb.compress_orderby = 'time, value'
                       ); $$, metric_table_name),
                       transactional => false);
                END IF;
        
                --chunks where the end time is before now()-1 hour will be compressed
                --per-ht compression policy only used for timescale 1.x
                IF _prom_catalog.get_timescale_major_version() < 2 THEN
                    PERFORM public.add_compress_chunks_policy(format('prom_data.%I', metric_table_name), INTERVAL '1 hour');
                END IF;
            ELSE
                IF _prom_catalog.get_timescale_major_version() < 2 THEN
                    PERFORM public.remove_compress_chunks_policy(format('prom_data.%I', metric_table_name));
                END IF;
        
                CALL _prom_catalog.decompress_chunks_after(metric_table_name::name, timestamptz '-Infinity', transactional=>true);
        
                EXECUTE format($$
                    ALTER TABLE prom_data.%I SET (
                        timescaledb.compress = false
                    ); $$, metric_table_name);
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION prom_api.set_compression_on_metric_table(TEXT, BOOLEAN) FROM PUBLIC;
        COMMENT ON FUNCTION prom_api.set_compression_on_metric_table(TEXT, BOOLEAN)
        IS 'set a compression for a specific metric table';
        GRANT EXECUTE ON FUNCTION prom_api.set_compression_on_metric_table(TEXT, BOOLEAN) TO prom_admin;
        
        
        CREATE OR REPLACE FUNCTION prom_api.reset_metric_compression_setting(metric_name TEXT)
        RETURNS BOOLEAN
        AS $func$
        DECLARE
            metric_table_name text;
        BEGIN
            SELECT table_name
            INTO STRICT metric_table_name
            FROM _prom_catalog.get_or_create_metric_table_name(reset_metric_compression_setting.metric_name);
        
            UPDATE _prom_catalog.metric
            SET default_compression = true
            WHERE table_name = metric_table_name;
        
            PERFORM prom_api.set_compression_on_metric_table(metric_table_name, _prom_catalog.get_default_compression_setting());
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION prom_api.reset_metric_compression_setting(TEXT)
        IS 'resets the compression setting for a specific metric to using the default';
        GRANT EXECUTE ON FUNCTION prom_api.reset_metric_compression_setting(TEXT) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.epoch_abort(user_epoch BIGINT)
        RETURNS VOID AS $func$
        DECLARE db_epoch BIGINT;
        BEGIN
            SELECT current_epoch FROM ids_epoch LIMIT 1
                INTO db_epoch;
            RAISE EXCEPTION 'epoch % to old to continue INSERT, current: %',
                user_epoch, db_epoch
                USING ERRCODE='PS001';
        END;
        $func$ LANGUAGE PLPGSQL VOLATILE;
        COMMENT ON FUNCTION _prom_catalog.epoch_abort(BIGINT)
        IS 'ABORT an INSERT transaction due to the ID epoch being out of date';
        GRANT EXECUTE ON FUNCTION _prom_catalog.epoch_abort TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_confirmed_unused_series(
            metric_schema NAME, metric_table NAME, series_table NAME, potential_series_ids BIGINT[], check_time TIMESTAMPTZ
        ) RETURNS BIGINT[]
        AS $func$
        DECLARE
            r RECORD;
            check_time_condition TEXT;
        BEGIN
            FOR r IN
                SELECT *
                FROM _prom_catalog.metric m
                WHERE m.series_table = get_confirmed_unused_series.series_table
            LOOP
        
            check_time_condition := '';
            IF r.table_schema = metric_schema::NAME AND r.table_name = metric_table::NAME THEN
                check_time_condition := FORMAT('AND time >= %L', check_time);
            END IF;
        
            --at each iteration of the loop filter potential_series_ids to only
            --have those series ids that don't exist in the metric tables.
            EXECUTE format(
            $query$
                SELECT array_agg(potential_series.series_id)
                FROM unnest($1) as potential_series(series_id)
                LEFT JOIN LATERAL(
                    SELECT 1
                    FROM  %1$I.%2$I data_exists
                    WHERE data_exists.series_id = potential_series.series_id
                    %3$s
                    --use chunk append + more likely to find something starting at earliest time
                    ORDER BY time ASC
                    LIMIT 1
                ) as lateral_exists(indicator) ON (true)
                WHERE lateral_exists.indicator IS NULL
            $query$, r.table_schema, r.table_name, check_time_condition)
        		USING potential_series_ids
            INTO potential_series_ids;
        
            END LOOP;
        
            RETURN potential_series_ids;
        END
        $func$
        LANGUAGE PLPGSQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_confirmed_unused_series(NAME, NAME, NAME, BIGINT[], TIMESTAMPTZ) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.mark_unused_series(
            metric_schema TEXT, metric_table TEXT, metric_series_table TEXT, older_than TIMESTAMPTZ, check_time TIMESTAMPTZ
        ) RETURNS VOID AS $func$
        DECLARE
        BEGIN
            --chances are that the hour after the drop point will have the most similar
            --series to what is dropped, so first filter by all series that have been dropped
            --but that aren't in that first hour and then make sure they aren't in the dataset
            EXECUTE format(
            $query$
                WITH potentially_drop_series AS (
                    SELECT distinct series_id
                    FROM %1$I.%2$I
                    WHERE time < %4$L
                    EXCEPT
                    SELECT distinct series_id
                    FROM %1$I.%2$I
                    WHERE time >= %4$L AND time < %5$L
                ), confirmed_drop_series AS (
                    SELECT _prom_catalog.get_confirmed_unused_series('%1$s','%2$s','%3$s', array_agg(series_id), %5$L) as ids
                    FROM potentially_drop_series
                ) -- we want this next statement to be the last one in the txn since it could block series fetch (both of them update delete_epoch)
                UPDATE prom_data_series.%3$I SET delete_epoch = current_epoch+1
                FROM _prom_catalog.ids_epoch
                WHERE delete_epoch IS NULL
                    AND id IN (SELECT unnest(ids) FROM confirmed_drop_series)
            $query$, metric_schema, metric_table, metric_series_table, older_than, check_time);
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.mark_unused_series(text, text, text, timestamptz, timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.mark_unused_series(text, text, text, timestamptz, timestamptz) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.delete_expired_series(
            metric_schema TEXT, metric_table TEXT, metric_series_table TEXT, ran_at TIMESTAMPTZ, present_epoch BIGINT, last_updated_epoch TIMESTAMPTZ
        ) RETURNS VOID AS $func$
        DECLARE
            label_array int[];
            next_epoch BIGINT;
            deletion_epoch BIGINT;
        BEGIN
            next_epoch := present_epoch + 1;
            -- technically we can delete any ID <= current_epoch - 1
            -- but it's always safe to leave them around for a bit longer
            deletion_epoch := present_epoch - 4;
        
            -- we don't want to delete too soon
            IF ran_at < last_updated_epoch + '1 hour' THEN
                RETURN;
            END IF;
        
            EXECUTE format($query$
                -- recheck that the series IDs we might delete are actually dead
                WITH dead_series AS (
                    SELECT potential.id
                    FROM
                    (
                        SELECT id
                        FROM prom_data_series.%3$I
                        WHERE delete_epoch <= %4$L
                    ) as potential
                    LEFT JOIN LATERAL (
                        SELECT 1
                        FROM %1$I.%2$I metric_data
                        WHERE metric_data.series_id = potential.id
                        LIMIT 1
                    ) as lateral_exists(indicator) ON (TRUE)
                    WHERE indicator IS NULL
                ), deleted_series AS (
                    DELETE FROM prom_data_series.%3$I
                    WHERE delete_epoch <= %4$L
                        AND id IN (SELECT id FROM dead_series) -- concurrency means we need this qual in both
                    RETURNING id, labels
                ), resurrected_series AS (
                    UPDATE prom_data_series.%3$I
                    SET delete_epoch = NULL
                    WHERE delete_epoch <= %4$L
                        AND id NOT IN (SELECT id FROM dead_series) -- concurrency means we need this qual in both
                )
                SELECT ARRAY(SELECT DISTINCT unnest(labels) as label_id
                    FROM deleted_series)
            $query$, metric_schema, metric_table, metric_series_table, deletion_epoch) INTO label_array;
        
        
            IF array_length(label_array, 1) > 0 THEN
                --jit interacts poorly why the multi-partition query below
                SET LOCAL jit = 'off';
                --needs to be a separate query and not a CTE since this needs to "see"
                --the series rows deleted above as deleted.
                --Note: we never delete metric name keys since there are check constraints that
                --rely on those ids not changing.
                EXECUTE format($query$
                WITH check_local_series AS (
                        --the series table from which we just deleted is much more likely to have the label, so check that first to exclude most labels.
                        SELECT label_id
                        FROM unnest($1) as labels(label_id)
                        WHERE NOT EXISTS (
                            SELECT 1
                            FROM  prom_data_series.%1$I series_exists_local
                            WHERE series_exists_local.labels && ARRAY[labels.label_id]
                            LIMIT 1
                        )
                    ),
                    confirmed_drop_labels AS (
                        --do the global check to confirm
                        SELECT label_id
                        FROM check_local_series
                        WHERE NOT EXISTS (
                            SELECT 1
                            FROM  _prom_catalog.series series_exists
                            WHERE series_exists.labels && ARRAY[label_id]
                            LIMIT 1
                        )
                    )
                    DELETE FROM _prom_catalog.label
                    WHERE id IN (SELECT * FROM confirmed_drop_labels) AND key != '__name__';
                $query$, metric_series_table) USING label_array;
        
                SET LOCAL jit = DEFAULT;
            END IF;
        
            UPDATE _prom_catalog.ids_epoch
                SET (current_epoch, last_update_time) = (next_epoch, now())
                WHERE current_epoch < next_epoch;
            RETURN;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.delete_expired_series(text, text, text, timestamptz, BIGINT, timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.delete_expired_series(text, text, text, timestamptz, BIGINT, timestamptz) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.set_app_name(full_name text)
            RETURNS VOID
        AS $func$
            --setting a name that's too long create surpurflous NOTICE messages in the log
            SELECT set_config('application_name', substring(full_name for 63), false);
        $func$
        LANGUAGE SQL VOLATILE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.set_app_name(text) TO prom_maintenance;
        
        -- Get hypertable information for where data is stored for raw metrics and for
        -- the materialized hypertable for cagg metrics. For non-materialized views return
        -- no rows
        CREATE OR REPLACE FUNCTION _prom_catalog.get_storage_hypertable_info(metric_schema_name text, metric_table_name text, is_view boolean)
        RETURNS TABLE (id int, hypertable_relation text)
        AS $$
        DECLARE
            agg_schema name;
            agg_name name;
            _is_cagg boolean;
            _materialized_hypertable_id int;
            _storage_hypertable_relation text;
        BEGIN
                IF NOT _prom_catalog.is_timescaledb_installed() THEN
                    RETURN;
                END IF;
        
                IF NOT is_view THEN
                        RETURN QUERY
                        SELECT h.id, format('%I.%I', h.schema_name,  h.table_name)
                        FROM _timescaledb_catalog.hypertable h
                        WHERE h.schema_name = metric_schema_name
                        AND h.table_name = metric_table_name;
                        RETURN;
                END IF;
        
                SELECT is_cagg, materialized_hypertable_id, storage_hypertable_relation
                INTO _is_cagg, _materialized_hypertable_id, _storage_hypertable_relation
                FROM _prom_catalog.get_cagg_info(metric_schema_name, metric_table_name);
        
                IF NOT _is_cagg THEN
                    RETURN;
                END IF;
        
                RETURN QUERY SELECT _materialized_hypertable_id, _storage_hypertable_relation;
        END
        $$
        LANGUAGE PLPGSQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_storage_hypertable_info(text, text, boolean) TO prom_reader;
        
        
        --Get underlying metric view schema and name
        --we need to support up to two levels of views to support 2-step caggs
        CREATE OR REPLACE FUNCTION _prom_catalog.get_first_level_view_on_metric(metric_schema text, metric_table text)
        RETURNS TABLE (view_schema name, view_name name, metric_table_name name)
        AS $$
        BEGIN
            --RAISE WARNING 'checking view: % %', metric_schema, metric_table;
            RETURN QUERY
            SELECT v.view_schema::name, v.view_name::name, v.table_name::name
            FROM information_schema.view_table_usage v
            WHERE v.view_schema = metric_schema
            AND v.view_name = metric_table
            AND v.table_schema = 'prom_data';
        
            IF FOUND THEN
                RETURN;
            END IF;
        
            -- if first level not found, return 2nd level if any
            RETURN QUERY
            SELECT v2.view_schema::name, v2.view_name::name, v2.table_name::name
            FROM information_schema.view_table_usage v
            LEFT JOIN information_schema.view_table_usage v2
                ON (v2.view_schema = v.table_schema
                    AND v2.view_name = v.table_name)
            WHERE v.view_schema = metric_schema
            AND v.view_name = metric_table
            AND v2.table_schema = 'prom_data';
            RETURN;
        END
        $$
        LANGUAGE PLPGSQL STABLE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.get_first_level_view_on_metric(text, text) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_first_level_view_on_metric(text, text) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_cagg_info(
            metric_schema text, metric_table text,
            OUT is_cagg BOOLEAN, OUT cagg_schema name, OUT cagg_name name, OUT metric_table_name name,
            OUT materialized_hypertable_id INT, OUT storage_hypertable_relation TEXT)
        AS $$
        BEGIN
            is_cagg := FALSE;
            SELECT *
            FROM _prom_catalog.get_first_level_view_on_metric(metric_schema, metric_table)
            INTO cagg_schema, cagg_name, metric_table_name;
        
            IF NOT FOUND THEN
              RETURN;
            END IF;
        
            -- for TSDB 2.x we return the view schema and name because functions like
            -- show_chunks don't work on materialized hypertables, which is a difference
            -- from 1.x version
            IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                SELECT h.id, format('%I.%I', c.view_schema,  c.view_name)
                INTO materialized_hypertable_id, storage_hypertable_relation
                FROM timescaledb_information.continuous_aggregates c
                INNER JOIN _timescaledb_catalog.hypertable h
                    ON (h.schema_name = c.materialization_hypertable_schema
                        AND h.table_name = c.materialization_hypertable_name)
                WHERE c.view_schema = cagg_schema
                AND c.view_name = cagg_name;
            ELSE
                SELECT h.id, format('%I.%I', h.schema_name,  h.table_name)
                INTO materialized_hypertable_id, storage_hypertable_relation
                FROM timescaledb_information.continuous_aggregates c
                INNER JOIN _timescaledb_catalog.hypertable h
                    ON (c.materialization_hypertable::text = format('%I.%I', h.schema_name,  h.table_name))
                WHERE c.view_name::text = format('%I.%I', cagg_schema, cagg_name);
            END IF;
        
            IF NOT FOUND THEN
              cagg_schema := NULL;
              cagg_name := NULL;
              metric_table_name := NULL;
              RETURN;
            END IF;
        
            is_cagg := true;
            return;
        END
        $$
        LANGUAGE PLPGSQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_cagg_info(text, text) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.is_stale_marker(value double precision)
        RETURNS BOOLEAN
        AS $func$
            SELECT float8send(value) = '\x7ff0000000000002'
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.is_stale_marker(double precision)
        IS 'returns true if the value is a Prometheus stale marker';
        GRANT EXECUTE ON FUNCTION prom_api.is_stale_marker(double precision) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.is_normal_nan(value double precision)
        RETURNS BOOLEAN
        AS $func$
            SELECT float8send(value) = '\x7ff8000000000001'
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.is_normal_nan(double precision)
        IS 'returns true if the value is a NaN';
        GRANT EXECUTE ON FUNCTION prom_api.is_normal_nan(double precision) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.val(
                label_id INT)
            RETURNS TEXT
        AS $$
            SELECT
                value
            FROM _prom_catalog.label
            WHERE
                id = label_id
        $$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.val(INT)
        IS 'returns the label value from a label id';
        GRANT EXECUTE ON FUNCTION prom_api.val(INT) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.get_label_key_column_name_for_view(label_key text, id BOOLEAN)
            returns NAME
        AS $func$
        DECLARE
          is_reserved boolean;
        BEGIN
          SELECT label_key = ANY(ARRAY['time', 'value', 'series_id', 'labels'])
          INTO STRICT is_reserved;
        
          IF is_reserved THEN
            label_key := 'label_' || label_key;
          END IF;
        
          IF id THEN
            RETURN (_prom_catalog.get_or_create_label_key(label_key)).id_column_name;
          ELSE
            RETURN (_prom_catalog.get_or_create_label_key(label_key)).value_column_name;
          END IF;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_label_key_column_name_for_view(text, BOOLEAN) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.create_series_view(
                metric_name text)
            RETURNS BOOLEAN
        AS $func$
        DECLARE
           label_value_cols text;
           view_name text;
           metric_id int;
           view_exists boolean;
        BEGIN
            SELECT
                ',' || string_agg(
                    format ('prom_api.val(series.labels[%s]) AS %I',pos::int, _prom_catalog.get_label_key_column_name_for_view(key, false))
                , ', ' ORDER BY pos)
            INTO STRICT label_value_cols
            FROM _prom_catalog.label_key_position lkp
            WHERE lkp.metric_name = create_series_view.metric_name and key != '__name__';
        
            SELECT m.table_name, m.id
            INTO STRICT view_name, metric_id
            FROM _prom_catalog.metric m
            WHERE m.metric_name = create_series_view.metric_name
            AND m.table_schema = 'prom_data';
        
            SELECT COUNT(*) > 0 into view_exists
            FROM pg_class
            WHERE
              relname = view_name AND
              relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'prom_series');
        
            EXECUTE FORMAT($$
                CREATE OR REPLACE VIEW prom_series.%1$I AS
                SELECT
                    id AS series_id,
                    labels
                    %2$s
                FROM
                    prom_data_series.%1$I AS series
                WHERE delete_epoch IS NULL
            $$, view_name, label_value_cols);
        
            IF NOT view_exists THEN
                EXECUTE FORMAT('GRANT SELECT ON prom_series.%1$I TO prom_reader', view_name);
            END IF;
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.create_series_view(text) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_series_view(text) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.create_metric_view(
                metric_name text)
            RETURNS BOOLEAN
        AS $func$
        DECLARE
           label_value_cols text;
           table_name text;
           metric_id int;
           view_exists boolean;
        BEGIN
            SELECT
                ',' || string_agg(
                    format ('series.labels[%s] AS %I',pos::int, _prom_catalog.get_label_key_column_name_for_view(key, true))
                , ', ' ORDER BY pos)
            INTO STRICT label_value_cols
            FROM _prom_catalog.label_key_position lkp
            WHERE lkp.metric_name = create_metric_view.metric_name and key != '__name__';
        
            SELECT m.table_name, m.id
            INTO STRICT table_name, metric_id
            FROM _prom_catalog.metric m
            WHERE m.metric_name = create_metric_view.metric_name
            AND m.table_schema = 'prom_data';
        
            SELECT COUNT(*) > 0 into view_exists
            FROM pg_class
            WHERE
              relname = table_name AND
              relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'prom_metric');
        
            EXECUTE FORMAT($$
                CREATE OR REPLACE VIEW prom_metric.%1$I AS
                SELECT
                    data.time as time,
                    data.value as value,
                    data.series_id AS series_id,
                    series.labels
                    %2$s
                FROM
                    prom_data.%1$I AS data
                    LEFT JOIN prom_data_series.%1$I AS series ON (series.id = data.series_id)
            $$, table_name, label_value_cols);
        
            IF NOT view_exists THEN
                EXECUTE FORMAT('GRANT SELECT ON prom_metric.%1$I TO prom_reader', table_name);
            END IF;
        
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.create_metric_view(text) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_metric_view(text) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION prom_api.register_metric_view(schema_name name, view_name name, if_not_exists BOOLEAN = false)
            RETURNS BOOLEAN
        AS $func$
        DECLARE
           agg_schema name;
           agg_name name;
           metric_table_name name;
           column_count int;
        BEGIN
            -- check if table/view exists
            PERFORM * FROM information_schema.tables
            WHERE  table_schema = register_metric_view.schema_name
            AND    table_name   = register_metric_view.view_name;
        
            IF NOT FOUND THEN
                RAISE EXCEPTION 'cannot register non-existant metric view in specified schema';
            END IF;
        
            -- cannot register view in data schema
            IF schema_name = 'prom_data' THEN
                RAISE EXCEPTION 'cannot register metric view in prom_data schema';
            END IF;
        
            -- check if view is based on a metric from prom_data
            -- we check for two levels so we can support 2-step continuous aggregates
            SELECT v.view_schema, v.view_name, v.metric_table_name
            INTO agg_schema, agg_name, metric_table_name
            FROM _prom_catalog.get_first_level_view_on_metric(schema_name, view_name) v;
        
            IF NOT FOUND THEN
                RAISE EXCEPTION 'view not based on a metric table from prom_data schema';
            END IF;
        
            -- check if the view contains necessary columns with the correct types
            SELECT count(*) FROM information_schema.columns
            INTO column_count
            WHERE table_schema = register_metric_view.schema_name
            AND table_name   = register_metric_view.view_name
            AND ((column_name = 'time' AND data_type = 'timestamp with time zone')
            OR (column_name = 'series_id' AND data_type = 'bigint')
            OR data_type = 'double precision');
        
            IF column_count < 3 THEN
                RAISE EXCEPTION 'view must contain time (data type: timestamp with time zone), series_id (data type: bigint), and at least one column with double precision data type';
            END IF;
        
            -- insert into metric table
            INSERT INTO _prom_catalog.metric (metric_name, table_name, table_schema, series_table, is_view, creation_completed)
            VALUES (register_metric_view.view_name, register_metric_view.view_name, register_metric_view.schema_name, metric_table_name, true, true)
            ON CONFLICT DO NOTHING;
        
            IF NOT FOUND THEN
                IF register_metric_view.if_not_exists THEN
                    RAISE NOTICE 'metric with same name and schema already exists';
                    RETURN FALSE;
                ELSE
                    RAISE EXCEPTION 'metric with the same name and schema already exists, could not register';
                END IF;
            END IF;
        
            EXECUTE format('GRANT USAGE ON SCHEMA %I TO prom_reader', register_metric_view.schema_name);
            EXECUTE format('GRANT SELECT ON TABLE %I.%I TO prom_reader', register_metric_view.schema_name, register_metric_view.view_name);
            EXECUTE format('GRANT USAGE ON SCHEMA %I TO prom_reader', agg_schema);
            EXECUTE format('GRANT SELECT ON TABLE %I.%I TO prom_reader', agg_schema, agg_name);
        
            PERFORM *
            FROM _prom_catalog.get_storage_hypertable_info(agg_schema, agg_name, true);
        
            RETURN true;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION prom_api.register_metric_view(name, name, boolean) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION prom_api.register_metric_view(name, name, boolean) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION prom_api.unregister_metric_view(schema_name name, view_name name, if_exists BOOLEAN = false)
            RETURNS BOOLEAN
        AS $func$
        DECLARE
           metric_table_name name;
           column_count int;
        BEGIN
            DELETE FROM _prom_catalog.metric
            WHERE unregister_metric_view.schema_name = table_schema
            AND unregister_metric_view.view_name = table_name
            AND is_view = TRUE;
        
            IF NOT FOUND THEN
                IF unregister_metric_view.if_exists THEN
                    RAISE NOTICE 'metric with specified name and schema does not exist';
                    RETURN FALSE;
                ELSE
                    RAISE EXCEPTION 'metric with specified name and schema does not exist, could not unregister';
                END IF;
            END IF;
        
            RETURN TRUE;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION prom_api.unregister_metric_view(name, name, boolean) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION prom_api.unregister_metric_view(name, name, boolean) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.delete_series_from_metric(name text, series_ids bigint[])
        RETURNS BIGINT
        AS
        $$
        DECLARE
            metric_table name;
            delete_stmt text;
            delete_query text;
            rows_affected bigint;
            num_rows_deleted bigint := 0;
        BEGIN
            SELECT table_name INTO metric_table FROM _prom_catalog.metric m WHERE m.metric_name=name AND m.is_view = false;
            IF _prom_catalog.is_timescaledb_installed() THEN
                FOR delete_stmt IN
                    SELECT FORMAT('DELETE FROM %1$I.%2$I WHERE series_id = ANY($1)', schema_name, table_name)
                    FROM (
                        SELECT (COALESCE(chc, ch)).* FROM pg_class c
                            INNER JOIN pg_namespace n ON c.relnamespace = n.oid
                            INNER JOIN _timescaledb_catalog.chunk ch ON (ch.schema_name, ch.table_name) = (n.nspname, c.relname)
                            LEFT JOIN _timescaledb_catalog.chunk chc ON ch.compressed_chunk_id = chc.id
                        WHERE c.oid IN (SELECT public.show_chunks(format('%I.%I','prom_data', metric_table))::oid)
                        ) a
                LOOP
                    EXECUTE delete_stmt USING series_ids;
                    GET DIAGNOSTICS rows_affected = ROW_COUNT;
                    num_rows_deleted = num_rows_deleted + rows_affected;
                END LOOP;
            ELSE
                EXECUTE FORMAT('DELETE FROM prom_data.%1$I WHERE series_id = ANY($1)', metric_table) USING series_ids;
                GET DIAGNOSTICS rows_affected = ROW_COUNT;
                num_rows_deleted = num_rows_deleted + rows_affected;
            END IF;
            PERFORM _prom_catalog.delete_series_catalog_row(metric_table, series_ids);
            RETURN num_rows_deleted;
        END;
        $$
        LANGUAGE PLPGSQL VOLATILE
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.delete_series_from_metric(text, bigint[])FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.delete_series_from_metric(text, bigint[]) to prom_modifier;
        
        -- the following functions require timescaledb >= 2.0.0
        DO $block$
        BEGIN
            IF _prom_catalog.is_timescaledb_installed() AND _prom_catalog.get_timescale_major_version() >= 2 THEN
        
                CREATE OR REPLACE FUNCTION _prom_catalog.hypertable_local_size(schema_name_in name)
                RETURNS TABLE(hypertable_name name, table_bytes bigint, index_bytes bigint, toast_bytes bigint, total_bytes bigint)
                AS $function$
                BEGIN
                    IF _prom_catalog.get_timescale_minor_version() < 3 THEN
                        -- two columns in _timescaledb_internal.hypertable_chunk_local_size were renamed in version 2.2
                        -- schema_name -> hypertable_schema
                        -- table_name -> hypertable_name
                        -- we explicit aliases to deal with this
                        RETURN QUERY
                        SELECT
                            ch.hypertable_name,
                            (COALESCE(sum(ch.total_bytes), 0) - COALESCE(sum(ch.index_bytes), 0) - COALESCE(sum(ch.toast_bytes), 0) + COALESCE(sum(ch.compressed_heap_size), 0))::bigint + pg_relation_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS heap_bytes,
                            (COALESCE(sum(ch.index_bytes), 0) + COALESCE(sum(ch.compressed_index_size), 0))::bigint + pg_indexes_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS index_bytes,
                            (COALESCE(sum(ch.toast_bytes), 0) + COALESCE(sum(ch.compressed_toast_size), 0))::bigint AS toast_bytes,
                            (COALESCE(sum(ch.total_bytes), 0) + COALESCE(sum(ch.compressed_heap_size), 0) + COALESCE(sum(ch.compressed_index_size), 0) + COALESCE(sum(ch.compressed_toast_size), 0))::bigint + pg_total_relation_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS total_bytes
                        FROM _timescaledb_internal.hypertable_chunk_local_size ch
                        (
                            hypertable_schema,
                            hypertable_name,
                            hypertable_id,
                            chunk_id,
                            chunk_schema,
                            chunk_name,
                            total_bytes,
                            index_bytes,
                            toast_bytes,
                            compressed_heap_size,
                            compressed_index_size,
                            compressed_toast_size
                        )
                        WHERE ch.hypertable_schema = schema_name_in
                        GROUP BY ch.hypertable_name, ch.hypertable_schema;
                    ELSE
                        RETURN QUERY
                        SELECT
                            ch.hypertable_name,
                            (COALESCE(sum(ch.total_bytes), 0) - COALESCE(sum(ch.index_bytes), 0) - COALESCE(sum(ch.toast_bytes), 0) + COALESCE(sum(ch.compressed_heap_size), 0))::bigint + pg_relation_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS heap_bytes,
                            (COALESCE(sum(ch.index_bytes), 0) + COALESCE(sum(ch.compressed_index_size), 0))::bigint + pg_indexes_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS index_bytes,
                            (COALESCE(sum(ch.toast_bytes), 0) + COALESCE(sum(ch.compressed_toast_size), 0))::bigint AS toast_bytes,
                            (COALESCE(sum(ch.total_bytes), 0) + COALESCE(sum(ch.compressed_heap_size), 0) + COALESCE(sum(ch.compressed_index_size), 0) + COALESCE(sum(ch.compressed_toast_size), 0))::bigint + pg_total_relation_size(format('%I.%I', ch.hypertable_schema, ch.hypertable_name)::regclass)::bigint AS total_bytes
                        FROM _timescaledb_internal.hypertable_chunk_local_size ch
                        (
                            hypertable_schema,
                            hypertable_name,
                            hypertable_id,
                            chunk_id,
                            chunk_schema,
                            chunk_name,
                            total_bytes,
                            index_bytes,
                            toast_bytes,
                            compressed_total_size,
                            compressed_index_size,
                            compressed_toast_size,
                            compressed_heap_size
                        )
                        WHERE ch.hypertable_schema = schema_name_in
                        GROUP BY ch.hypertable_name, ch.hypertable_schema;
                    END IF;
                END;
                $function$
                LANGUAGE plpgsql STRICT STABLE
                SECURITY DEFINER
                --search path must be set for security definer
                SET search_path = pg_temp;
                REVOKE ALL ON FUNCTION _prom_catalog.hypertable_local_size(name) FROM PUBLIC;
                GRANT EXECUTE ON FUNCTION _prom_catalog.hypertable_local_size(name) to prom_reader;
        
                CREATE OR REPLACE FUNCTION _prom_catalog.hypertable_node_up(schema_name_in name)
                RETURNS TABLE(hypertable_name name, node_name name, node_up boolean)
                AS $function$
                    -- list of distributed hypertables and whether or not the associated data node is up
                    -- only ping each distinct data node once and no more
                    -- there is no guarantee that a node will stay "up" for the duration of a transaction
                    -- but we don't want to pay the penalty of asking more than once, so we mark this
                    -- function as stable to allow the results to be cached
                    WITH dht AS MATERIALIZED (
                        -- list of distributed hypertables
                        SELECT
                            ht.table_name,
                            s.node_name
                        FROM _timescaledb_catalog.hypertable ht
                        JOIN _timescaledb_catalog.hypertable_data_node s ON (
                            ht.replication_factor > 0 AND s.hypertable_id = ht.id
                        )
                        WHERE ht.schema_name = schema_name_in
                    ),
                    up AS MATERIALIZED (
                        -- list of nodes we care about and whether they are up
                        SELECT
                            x.node_name,
                            _timescaledb_internal.ping_data_node(x.node_name) AS node_up
                        FROM (
                            SELECT DISTINCT dht.node_name -- only ping each node once
                            FROM dht
                        ) x
                    )
                    SELECT
                        dht.table_name as hypertable_name,
                        dht.node_name,
                        up.node_up
                    FROM dht
                    JOIN up ON (dht.node_name = up.node_name)
                $function$
                LANGUAGE sql
                STRICT STABLE
                SECURITY DEFINER
                --search path must be set for security definer
                SET search_path = pg_temp;
                REVOKE ALL ON FUNCTION _prom_catalog.hypertable_node_up(name) FROM PUBLIC;
                GRANT EXECUTE ON FUNCTION _prom_catalog.hypertable_node_up(name) to prom_reader;
        
                CREATE OR REPLACE FUNCTION _prom_catalog.hypertable_remote_size(schema_name_in name)
                RETURNS TABLE(hypertable_name name, table_bytes bigint, index_bytes bigint, toast_bytes bigint, total_bytes bigint)
                AS $function$
                    SELECT
                        dht.hypertable_name,
                        sum(x.table_bytes)::bigint AS table_bytes,
                        sum(x.index_bytes)::bigint AS index_bytes,
                        sum(x.toast_bytes)::bigint AS toast_bytes,
                        sum(x.total_bytes)::bigint AS total_bytes
                    FROM _prom_catalog.hypertable_node_up(schema_name_in) dht
                    LEFT OUTER JOIN LATERAL _timescaledb_internal.data_node_hypertable_info(
                        CASE WHEN dht.node_up THEN
                            dht.node_name
                        ELSE
                            NULL
                        END, schema_name_in, dht.hypertable_name) x ON true
                    GROUP BY dht.hypertable_name
                $function$
                LANGUAGE sql
                STRICT STABLE
                SECURITY DEFINER
                --search path must be set for security definer
                SET search_path = pg_temp;
                REVOKE ALL ON FUNCTION _prom_catalog.hypertable_remote_size(name) FROM PUBLIC;
                GRANT EXECUTE ON FUNCTION _prom_catalog.hypertable_remote_size(name) to prom_reader;
        
                -- two columns in _timescaledb_internal.compressed_chunk_stats were renamed in version 2.2
                -- schema_name -> hypertable_schema
                -- table_name -> hypertable_name
                -- we use explicit column aliases on _timescaledb_internal.compressed_chunk_stats to rename the
                -- `schema_name` and `table_name` in the older versions to the new names
                CREATE OR REPLACE FUNCTION _prom_catalog.hypertable_compression_stats_for_schema(schema_name_in name)
                RETURNS TABLE(hypertable_name name, total_chunks bigint, number_compressed_chunks bigint, before_compression_total_bytes bigint, after_compression_total_bytes bigint)
                AS $function$
                    SELECT
                        x.hypertable_name,
                        count(*)::bigint AS total_chunks,
                        (count(*) FILTER (WHERE x.compression_status = 'Compressed'))::bigint AS number_compressed_chunks,
                        sum(x.before_compression_total_bytes)::bigint AS before_compression_total_bytes,
                        sum(x.after_compression_total_bytes)::bigint AS after_compression_total_bytes
                    FROM
                    (
                        -- local hypertables
                        SELECT
                            ch.hypertable_name,
                            ch.compression_status,
                            ch.uncompressed_total_size AS before_compression_total_bytes,
                            ch.compressed_total_size AS after_compression_total_bytes,
                            NULL::text AS node_name
                        FROM _timescaledb_internal.compressed_chunk_stats ch
                        (
                            hypertable_schema,
                            hypertable_name,
                            chunk_schema,
                            chunk_name,
                            compression_status,
                            uncompressed_heap_size,
                            uncompressed_index_size,
                            uncompressed_toast_size,
                            uncompressed_total_size,
                            compressed_heap_size,
                            compressed_index_size,
                            compressed_toast_size,
                            compressed_total_size
                        )
                        WHERE ch.hypertable_schema = schema_name_in
                        UNION ALL
                        -- distributed hypertables
                        SELECT
                            dht.hypertable_name,
                            ch.compression_status,
                            ch.before_compression_total_bytes,
                            ch.after_compression_total_bytes,
                            dht.node_name
                        FROM _prom_catalog.hypertable_node_up(schema_name_in) dht
                        LEFT OUTER JOIN LATERAL _timescaledb_internal.data_node_compressed_chunk_stats (
                            CASE WHEN dht.node_up THEN
                                dht.node_name
                            ELSE
                                NULL
                            END, schema_name_in, dht.hypertable_name) ch ON true
                        WHERE ch.chunk_name IS NOT NULL
                    ) x
                    GROUP BY x.hypertable_name
                $function$
                LANGUAGE sql
                STRICT STABLE
                SECURITY DEFINER
                --search path must be set for security definer
                SET search_path = pg_temp;
                REVOKE ALL ON FUNCTION _prom_catalog.hypertable_compression_stats_for_schema(name) FROM PUBLIC;
                GRANT EXECUTE ON FUNCTION _prom_catalog.hypertable_compression_stats_for_schema(name) to prom_reader;
        
            END IF;
        END;
        $block$
        ;
        
        --------------------------------- Views --------------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.metric_view()
        RETURNS TABLE(id int, metric_name text, table_name name, label_keys text[], retention_period interval,
                      chunk_interval interval, compressed_interval interval, total_interval interval,
                      before_compression_bytes bigint, after_compression_bytes bigint,
                      total_size_bytes bigint, total_size text, compression_ratio numeric,
                      total_chunks bigint, compressed_chunks bigint)
        AS $func$
        BEGIN
                IF NOT _prom_catalog.is_timescaledb_installed() THEN
                    RETURN QUERY
                        SELECT
                           i.id,
                           i.metric_name,
                           i.table_name,
                           i.label_keys,
                           i.retention_period,
                           i.chunk_interval,
                           NULL::interval compressed_interval,
                           NULL::interval total_interval,
                           pg_size_bytes(i.total_size) as before_compression_bytes,
                           NULL::bigint as after_compression_bytes,
                           pg_size_bytes(i.total_size) as total_size_bytes,
                           i.total_size,
                           i.compression_ratio,
                           i.total_chunks,
                           i.compressed_chunks
                        FROM
                        (
                            SELECT
                                m.id,
                                m.metric_name,
                                m.table_name,
                                ARRAY(
                                    SELECT key
                                    FROM _prom_catalog.label_key_position lkp
                                    WHERE lkp.metric_name = m.metric_name
                                    ORDER BY key) label_keys,
                                _prom_catalog.get_metric_retention_period(m.table_schema, m.metric_name) as retention_period,
                                NULL::interval as chunk_interval,
                                pg_size_pretty(pg_total_relation_size(format('prom_data.%I', m.table_name)::regclass)) as total_size,
                                0.0 as compression_ratio,
                                NULL::bigint as total_chunks,
                                NULL::bigint as compressed_chunks
                            FROM _prom_catalog.metric m
                        ) AS i;
                    RETURN;
                END IF;
        
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    RETURN QUERY
                    WITH ci AS (
                        SELECT
                            hypertable_name as hypertable_name,
                            COALESCE(SUM(range_end-range_start) FILTER(WHERE is_compressed), INTERVAL '0') AS compressed_interval,
                            COALESCE(SUM(range_end-range_start), INTERVAL '0') AS total_interval
                        FROM timescaledb_information.chunks c
                        WHERE hypertable_schema='prom_data'
                        GROUP BY hypertable_schema, hypertable_name
                    )
                    SELECT
                        m.id,
                        m.metric_name,
                        m.table_name,
                        ARRAY(
                            SELECT key
                            FROM _prom_catalog.label_key_position lkp
                            WHERE lkp.metric_name = m.metric_name
                            ORDER BY key) label_keys,
                        _prom_catalog.get_metric_retention_period(m.table_schema, m.metric_name) as retention_period,
                        dims.time_interval as chunk_interval,
                        ci.compressed_interval,
                        ci.total_interval,
                        hcs.before_compression_total_bytes::bigint,
                        hcs.after_compression_total_bytes::bigint,
                        hs.total_bytes::bigint as total_size_bytes,
                        pg_size_pretty(hs.total_bytes::bigint) as total_size,
                        (1.0 - (hcs.after_compression_total_bytes::NUMERIC / hcs.before_compression_total_bytes::NUMERIC)) * 100 as compression_ratio,
                        hcs.total_chunks::BIGINT,
                        hcs.number_compressed_chunks::BIGINT as compressed_chunks
                    FROM _prom_catalog.metric m
                    LEFT JOIN
                    (
                        SELECT
                          x.hypertable_name
                        , sum(x.total_bytes::bigint) as total_bytes
                        FROM
                        (
                            SELECT *
                            FROM _prom_catalog.hypertable_local_size('prom_data')
                            UNION ALL
                            SELECT *
                            FROM _prom_catalog.hypertable_remote_size('prom_data')
                        ) x
                        GROUP BY x.hypertable_name
                    ) hs ON (hs.hypertable_name = m.table_name)
                    LEFT JOIN timescaledb_information.dimensions dims ON
                        (dims.hypertable_schema = 'prom_data' AND dims.hypertable_name = m.table_name)
                    LEFT JOIN _prom_catalog.hypertable_compression_stats_for_schema('prom_data') hcs ON (hcs.hypertable_name = m.table_name)
                    LEFT JOIN ci ON (ci.hypertable_name = m.table_name)
                    ;
                ELSE
                    RETURN QUERY
                        SELECT
                            m.id,
                            m.metric_name,
                            m.table_name,
                            ARRAY(
                                SELECT key
                                    FROM _prom_catalog.label_key_position lkp
                                WHERE lkp.metric_name = m.metric_name
                                ORDER BY key
                            ) label_keys,
                            _prom_catalog.get_metric_retention_period(m.table_schema, m.metric_name) as retention_period,
                            (
                                SELECT _timescaledb_internal.to_interval(interval_length)
                                    FROM _timescaledb_catalog.dimension d
                                WHERE d.hypertable_id = h.id
                                ORDER BY d.id ASC LIMIT 1
                            ) as chunk_interval,
                            ci.compressed_interval,
                            ci.total_interval,
                            pg_size_bytes(chs.uncompressed_total_bytes) as before_compression_bytes,
                            pg_size_bytes(chs.compressed_total_bytes) as after_compression_bytes,
                            pg_size_bytes(hi.total_size) as total_bytes,
                            hi.total_size as total_size,
                            (1.0 - (pg_size_bytes(chs.compressed_total_bytes)::numeric / pg_size_bytes(chs.uncompressed_total_bytes)::numeric)) * 100 as compression_ratio,
                            chs.total_chunks,
                            chs.number_compressed_chunks as compressed_chunks
                        FROM _prom_catalog.metric m
                            LEFT JOIN timescaledb_information.hypertable hi ON
                                (hi.table_schema = 'prom_data' AND hi.table_name = m.table_name)
                            LEFT JOIN timescaledb_information.compressed_hypertable_stats chs ON
                                (chs.hypertable_name = format('%I.%I', 'prom_data', m.table_name)::regclass)
                            LEFT JOIN _timescaledb_catalog.hypertable h ON
                                (h.schema_name = 'prom_data' AND h.table_name = m.table_name)
                            LEFT JOIN LATERAL
                                (
                                    SELECT COALESCE(
                                            SUM(
                                                UPPER(rs.ranges[1]::TSTZRANGE) - LOWER(rs.ranges[1]::TSTZRANGE)
                                            ),
                                            INTERVAL '0'
                                        ) total_interval,
                                        COALESCE(
                                            SUM(
                                                UPPER(rs.ranges[1]::TSTZRANGE) - LOWER(rs.ranges[1]::TSTZRANGE)
                                            ) FILTER (WHERE cs.compression_status = 'Compressed'),
                                            INTERVAL '0'
                                        ) compressed_interval
                                    FROM public.chunk_relation_size_pretty(FORMAT('prom_data.%I', m.table_name)) rs
                                    LEFT JOIN timescaledb_information.compressed_chunk_stats cs ON
                                        (cs.chunk_name::text = rs.chunk_table::text)
                                ) as ci ON TRUE;
                END IF;
        END
        $func$
        LANGUAGE PLPGSQL STABLE
        SECURITY DEFINER
        --search path must be set for security definer
        --need to include public(the timescaledb schema) for some timescale functions to work.
        SET search_path = public, pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.metric_view() FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.metric_view() TO prom_reader;
        
        CREATE OR REPLACE VIEW prom_info.metric AS
           SELECT
             *
            FROM _prom_catalog.metric_view();
        GRANT SELECT ON prom_info.metric TO prom_reader;
        
        CREATE OR REPLACE VIEW prom_info.label AS
            SELECT
                lk.key,
                lk.value_column_name,
                lk.id_column_name,
                va.values as values,
                cardinality(va.values) as num_values
            FROM _prom_catalog.label_key lk
            INNER JOIN LATERAL(SELECT key, array_agg(value ORDER BY value) as values FROM _prom_catalog.label GROUP BY key)
            AS va ON (va.key = lk.key) ORDER BY num_values DESC;
        GRANT SELECT ON prom_info.label TO prom_reader;
        
        CREATE OR REPLACE VIEW prom_info.system_stats AS
            SELECT
            (
                SELECT _prom_catalog.safe_approximate_row_count('_prom_catalog.series'::REGCLASS)
            ) AS num_series_approx,
            (
                SELECT count(*) FROM _prom_catalog.metric
            ) AS num_metric,
            (
                SELECT count(*) FROM _prom_catalog.label_key
            ) AS num_label_keys,
            (
                SELECT count(*) FROM _prom_catalog.label
            ) AS num_labels;
        GRANT SELECT ON prom_info.system_stats TO prom_reader;
        
        CREATE OR REPLACE VIEW prom_info.metric_stats AS
            SELECT metric_name,
            _prom_catalog.safe_approximate_row_count(format('prom_series.%I', table_name)::regclass) AS num_series_approx,
            (SELECT _prom_catalog.safe_approximate_row_count(format('prom_data.%I',table_name)::regclass)) AS num_samples_approx
            FROM _prom_catalog.metric ORDER BY metric_name;
        GRANT SELECT ON prom_info.metric_stats TO prom_reader;
        
        --this should the only thing run inside the transaction. It's important the txn ends after calling this function
        --to release locks
        CREATE OR REPLACE FUNCTION _prom_catalog.delay_compression_job(ht_table name, new_start timestamptz) RETURNS VOID
        AS $$
        DECLARE
            bgw_job_id int;
        BEGIN
            UPDATE _prom_catalog.metric m
            SET delay_compression_until = new_start
            WHERE table_name = ht_table;
        
            IF _prom_catalog.get_timescale_major_version() < 2 THEN
                SELECT job_id INTO bgw_job_id
                FROM _timescaledb_config.bgw_policy_compress_chunks p
                INNER JOIN _timescaledb_catalog.hypertable h ON (h.id = p.hypertable_id)
                WHERE h.schema_name = 'prom_data' and h.table_name = ht_table;
        
                --alter job schedule is not currently concurrency-safe (timescaledb issue #2165)
                PERFORM pg_advisory_xact_lock(_prom_catalog.get_advisory_lock_prefix_job(), bgw_job_id);
        
                PERFORM public.alter_job_schedule(bgw_job_id, next_start=>GREATEST(new_start, (SELECT next_start FROM timescaledb_information.policy_stats WHERE job_id = bgw_job_id)));
            END IF;
        END
        $$
        LANGUAGE PLPGSQL
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.delay_compression_job(name, timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.delay_compression_job(name, timestamptz) TO prom_writer;
        
        CALL _prom_catalog.execute_everywhere('_prom_catalog.do_decompress_chunks_after', $ee$
        DO $DO$
        BEGIN
            --this function isolates the logic that needs to be security definer
            --cannot fold it into do_decompress_chunks_after because cannot have security
            --definer do txn-al stuff like commit
            CREATE OR REPLACE FUNCTION _prom_catalog.decompress_chunk_for_metric(metric_table TEXT, chunk_schema_name name, chunk_table_name name) RETURNS VOID
            AS $$
            DECLARE
                chunk_full_name text;
            BEGIN
        
               --double check chunk belongs to metric table
               SELECT
                format('%I.%I', c.schema_name, c.table_name)
               INTO chunk_full_name
               FROM _timescaledb_catalog.chunk c
               INNER JOIN  _timescaledb_catalog.hypertable h ON (h.id = c.hypertable_id)
               WHERE
                    c.schema_name = chunk_schema_name AND c.table_name = chunk_table_name AND
                    h.schema_name = 'prom_data' AND h.table_name = metric_table AND
                    c.compressed_chunk_id IS NOT NULL;
        
                IF NOT FOUND Then
                    RETURN;
                END IF;
        
               --lock the chunk exclusive.
               EXECUTE format('LOCK %I.%I;', chunk_schema_name, chunk_table_name);
        
               --double check it's still compressed.
               PERFORM c.*
               FROM _timescaledb_catalog.chunk c
               WHERE schema_name = chunk_schema_name AND table_name = chunk_table_name AND
               c.compressed_chunk_id IS NOT NULL;
        
               IF NOT FOUND Then
                  RETURN;
               END IF;
        
               RAISE NOTICE 'Promscale is decompressing chunk: %.%', chunk_schema_name, chunk_table_name;
               PERFORM public.decompress_chunk(chunk_full_name);
            END;
            $$
            LANGUAGE PLPGSQL
            SECURITY DEFINER
            --search path must be set for security definer
            SET search_path = pg_temp;
            REVOKE ALL ON FUNCTION _prom_catalog.decompress_chunk_for_metric(TEXT, name, name) FROM PUBLIC;
            GRANT EXECUTE ON FUNCTION _prom_catalog.decompress_chunk_for_metric(TEXT, name, name) TO prom_writer;
        
        
            --Decompression should take place in a procedure because we don't want locks held across
            --decompress_chunk calls since that function takes some heavier locks at the end.
            --Thus, transactional parameter should usually be false
            CREATE OR REPLACE PROCEDURE _prom_catalog.do_decompress_chunks_after(metric_table NAME, min_time TIMESTAMPTZ, transactional BOOLEAN = false)
            AS $$
            DECLARE
                chunk_row record;
                dimension_row record;
                hypertable_row record;
                min_time_internal bigint;
            BEGIN
                SELECT h.* INTO STRICT hypertable_row FROM _timescaledb_catalog.hypertable h
                WHERE table_name = metric_table AND schema_name = 'prom_data';
        
                SELECT d.* INTO STRICT dimension_row FROM _timescaledb_catalog.dimension d WHERE hypertable_id = hypertable_row.id ORDER BY id LIMIT 1;
        
                IF min_time = timestamptz '-Infinity' THEN
                    min_time_internal := -9223372036854775808;
                ELSE
                   SELECT _timescaledb_internal.time_to_internal(min_time) INTO STRICT min_time_internal;
                END IF;
        
                FOR chunk_row IN
                    SELECT c.*
                    FROM _timescaledb_catalog.dimension_slice ds
                    INNER JOIN _timescaledb_catalog.chunk_constraint cc ON cc.dimension_slice_id = ds.id
                    INNER JOIN _timescaledb_catalog.chunk c ON cc.chunk_id = c.id
                    WHERE dimension_id = dimension_row.id
                    -- the range_ends are non-inclusive
                    AND min_time_internal < ds.range_end
                    AND c.compressed_chunk_id IS NOT NULL
                    ORDER BY ds.range_start
                LOOP
                    PERFORM _prom_catalog.decompress_chunk_for_metric(metric_table, chunk_row.schema_name, chunk_row.table_name);
                    IF NOT transactional THEN
                      COMMIT;
                    END IF;
                END LOOP;
            END;
            $$ LANGUAGE PLPGSQL;
            GRANT EXECUTE ON PROCEDURE _prom_catalog.do_decompress_chunks_after(NAME, TIMESTAMPTZ, BOOLEAN) TO prom_writer;
        END
        $DO$;
        $ee$);
        
        CREATE OR REPLACE PROCEDURE _prom_catalog.decompress_chunks_after(metric_table NAME, min_time TIMESTAMPTZ, transactional BOOLEAN = false)
        AS $proc$
        BEGIN
            -- In early versions of timescale multinode the access node catalog does not
            -- store whether chunks were compressed, so we need to run the actual search
            -- for nodes in need of decompression on the data nodes, and /not/ the
            -- access node; right now executing on the access node will do a lot of work
            -- and locking for no result.
            IF _prom_catalog.is_multinode() THEN
                CALL public.distributed_exec(
                    format(
                        $dist$ CALL _prom_catalog.do_decompress_chunks_after(%L, %L, %L) $dist$,
                        metric_table, min_time, transactional),
                    transactional => false);
            ELSE
                CALL _prom_catalog.do_decompress_chunks_after(metric_table, min_time, transactional);
            END IF;
        END
        $proc$ LANGUAGE PLPGSQL;
        GRANT EXECUTE ON PROCEDURE _prom_catalog.decompress_chunks_after(name, TIMESTAMPTZ, boolean) TO prom_writer;
        
        CALL _prom_catalog.execute_everywhere('_prom_catalog.compress_old_chunks', $ee$
        DO $DO$
        BEGIN
            --this function isolates the logic that needs to be security definer
            --cannot fold it into compress_old_chunks because cannot have security
            --definer do txn-all stuff like commit
            CREATE OR REPLACE FUNCTION _prom_catalog.compress_chunk_for_metric(metric_table TEXT, chunk_schema_name name, chunk_table_name name) RETURNS VOID
            AS $$
            DECLARE
                chunk_full_name text;
            BEGIN
                SELECT
                    format('%I.%I', chunk_schema, chunk_name)
                INTO chunk_full_name
                FROM timescaledb_information.chunks
                WHERE hypertable_schema = 'prom_data'
                  AND hypertable_name = metric_table
                  AND chunk_schema = chunk_schema_name
                  AND chunk_name = chunk_table_name;
        
                PERFORM public.compress_chunk(chunk_full_name, if_not_compressed => true);
            END;
            $$
            LANGUAGE PLPGSQL
            SECURITY DEFINER
            --search path must be set for security definer
            SET search_path = pg_temp;
            REVOKE ALL ON FUNCTION _prom_catalog.compress_chunk_for_metric(TEXT, name, name) FROM PUBLIC;
            GRANT EXECUTE ON FUNCTION _prom_catalog.compress_chunk_for_metric(TEXT, name, name) TO prom_maintenance;
        
            CREATE OR REPLACE PROCEDURE _prom_catalog.compress_old_chunks(metric_table TEXT, compress_before TIMESTAMPTZ)
            AS $$
            DECLARE
                chunk_schema_name name;
                chunk_table_name name;
                chunk_range_end timestamptz;
                chunk_num INT;
            BEGIN
                FOR chunk_schema_name, chunk_table_name, chunk_range_end, chunk_num IN
                    SELECT
                        chunk_schema,
                        chunk_name,
                        range_end,
                        row_number() OVER (ORDER BY range_end DESC)
                    FROM timescaledb_information.chunks
                    WHERE hypertable_schema = 'prom_data'
                        AND hypertable_name = metric_table
                        AND NOT is_compressed
                    ORDER BY range_end ASC
                LOOP
                    CONTINUE WHEN chunk_num <= 1 OR chunk_range_end > compress_before;
                    PERFORM _prom_catalog.compress_chunk_for_metric(metric_table, chunk_schema_name, chunk_table_name);
                    COMMIT;
                END LOOP;
            END;
            $$ LANGUAGE PLPGSQL;
            GRANT EXECUTE ON PROCEDURE _prom_catalog.compress_old_chunks(TEXT, TIMESTAMPTZ) TO prom_maintenance;
        END
        $DO$;
        $ee$);
        
        CREATE OR REPLACE PROCEDURE _prom_catalog.compress_metric_chunks(metric_name TEXT)
        AS $$
        DECLARE
          metric_table NAME;
        BEGIN
            SELECT table_name
            INTO STRICT metric_table
            FROM _prom_catalog.get_metric_table_name_if_exists('prom_data', metric_name);
        
            -- as of timescaledb-2.0-rc4 the is_compressed column of the chunks view is
            -- not updated on the access node, therefore we need to one the compressor
            -- on all the datanodes to search for uncompressed chunks
            IF _prom_catalog.is_multinode() THEN
                CALL public.distributed_exec(format($dist$
                    CALL _prom_catalog.compress_old_chunks(%L, now() - INTERVAL '1 hour')
                $dist$, metric_table), transactional => false);
            ELSE
                CALL _prom_catalog.compress_old_chunks(metric_table, now() - INTERVAL '1 hour');
            END IF;
        END
        $$ LANGUAGE PLPGSQL;
        GRANT EXECUTE ON PROCEDURE _prom_catalog.compress_metric_chunks(text) TO prom_maintenance;
        
        --Order by random with stable marking gives us same order in a statement and different
        -- orderings in different statements
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metrics_that_need_compression()
        RETURNS SETOF _prom_catalog.metric
        AS $$
        DECLARE
        BEGIN
                RETURN QUERY
                SELECT m.*
                FROM _prom_catalog.metric m
                WHERE
                  is_view = false AND
                  _prom_catalog.get_metric_compression_setting(m.metric_name) AND
                  delay_compression_until IS NULL OR delay_compression_until < now() AND
                  is_view = FALSE
                ORDER BY random();
        END
        $$
        LANGUAGE PLPGSQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metrics_that_need_compression() TO prom_maintenance;
        
        --only for timescaledb 2.0 in 1.x we use compression policies
        CREATE OR REPLACE PROCEDURE _prom_catalog.execute_compression_policy(log_verbose boolean = false)
        AS $$
        DECLARE
            r _prom_catalog.metric;
            remaining_metrics _prom_catalog.metric[] DEFAULT '{}';
            startT TIMESTAMPTZ;
            lockStartT TIMESTAMPTZ;
        BEGIN
            --Do one loop with metric that could be locked without waiting.
            --This allows you to do everything you can while avoiding lock contention.
            --Then come back for the metrics that would have needed to wait on the lock.
            --Hopefully, that lock is now freed. The secoond loop waits for the lock
            --to prevent starvation.
            FOR r IN
                SELECT *
                FROM _prom_catalog.get_metrics_that_need_compression()
            LOOP
                IF NOT _prom_catalog.lock_metric_for_maintenance(r.id, wait=>false) THEN
                    remaining_metrics := remaining_metrics || r;
                    CONTINUE;
                END IF;
                IF log_verbose THEN
                    startT := clock_timestamp();
                    RAISE LOG 'promscale maintenance: compression: metric %: starting, without lock wait', r.metric_name;
                END IF;
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: compression: metric %s', r.metric_name));
                CALL _prom_catalog.compress_metric_chunks(r.metric_name);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: compression: metric %: finished in %', r.metric_name, clock_timestamp()-startT;
                END IF;
                PERFORM _prom_catalog.unlock_metric_for_maintenance(r.id);
        
                COMMIT;
            END LOOP;
        
            FOR r IN
                SELECT *
                FROM unnest(remaining_metrics)
            LOOP
                IF log_verbose THEN
                    lockStartT := clock_timestamp();
                    RAISE LOG 'promscale maintenance: compression: metric %: waiting for lock', r.metric_name;
                END IF;
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: compression: metric %s: waiting on lock', r.metric_name));
                PERFORM _prom_catalog.lock_metric_for_maintenance(r.id);
                IF log_verbose THEN
                    startT := clock_timestamp();
                    RAISE LOG 'promscale maintenance: compression: metric %: starting', r.metric_name;
                END IF;
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: compression: metric %s', r.metric_name));
                CALL _prom_catalog.compress_metric_chunks(r.metric_name);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: compression: metric %: finished in % (lock took %; compression took %)', r.metric_name, clock_timestamp()-lockStartT, startT-lockStartT, clock_timestamp()-startT;
                END IF;
                PERFORM _prom_catalog.unlock_metric_for_maintenance(r.id);
        
                COMMIT;
            END LOOP;
        END;
        $$ LANGUAGE PLPGSQL;
        COMMENT ON PROCEDURE _prom_catalog.execute_compression_policy(boolean)
        IS 'compress data according to the policy. This procedure should be run regularly in a cron job';
        GRANT EXECUTE ON PROCEDURE _prom_catalog.execute_compression_policy(boolean) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE prom_api.add_prom_node(node_name TEXT, attach_to_existing_metrics BOOLEAN = true)
        AS $func$
        DECLARE
            command_row record;
        BEGIN
            FOR command_row IN
                SELECT command, transactional
                FROM _prom_catalog.remote_commands
                ORDER BY seq asc
            LOOP
                CALL public.distributed_exec(command_row.command,node_list=>array[node_name]);
            END LOOP;
        
            IF attach_to_existing_metrics THEN
                PERFORM attach_data_node(node_name, hypertable => format('%I.%I', 'prom_data', table_name))
                FROM _prom_catalog.metric;
            END IF;
        END
        $func$ LANGUAGE PLPGSQL;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.insert_metric_row(
            metric_table name,
            time_array timestamptz[],
            value_array DOUBLE PRECISION[],
            series_id_array bigint[]
        ) RETURNS BIGINT AS
        $$
        DECLARE
          num_rows BIGINT;
        BEGIN
            --turns out there is a horrible CPU perf penalty on the DB for ON CONFLICT DO NOTHING.
            --yet in our data, conflicts are rare. So we first try inserting without ON CONFLICT
            --and fall back if there is a unique constraint violation.
            EXECUTE FORMAT(
             'INSERT INTO  prom_data.%1$I (time, value, series_id)
                  SELECT * FROM unnest($1, $2, $3) a(t,v,s) ORDER BY s,t',
                metric_table
            ) USING time_array, value_array, series_id_array;
            GET DIAGNOSTICS num_rows = ROW_COUNT;
            RETURN num_rows;
        EXCEPTION WHEN unique_violation THEN 
        	EXECUTE FORMAT(
        	'INSERT INTO  prom_data.%1$I (time, value, series_id)
        		 SELECT * FROM unnest($1, $2, $3) a(t,v,s) ORDER BY s,t ON CONFLICT DO NOTHING',
        	   metric_table
        	) USING time_array, value_array, series_id_array;
        	GET DIAGNOSTICS num_rows = ROW_COUNT;
        	RETURN num_rows;
        END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _prom_catalog.insert_metric_row(NAME, TIMESTAMPTZ[], DOUBLE PRECISION[], BIGINT[]) TO prom_writer;

    END;
$outer_migration_block$;
-- 002-tag-operators.sql
DO
$outer_migration_block$
    BEGIN
        -------------------------------------------------------------------------------
        -- jsonb_path_exists
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_jsonb_path_exists(_tag_key text, _value jsonpath)
        RETURNS ps_tag.tag_op_jsonb_path_exists AS $func$
            SELECT ROW(_tag_key, _value)::ps_tag.tag_op_jsonb_path_exists
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_jsonb_path_exists(text, jsonpath) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_jsonb_path_exists IS $$This function supports the @? operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.@? (
                LEFTARG = text,
                RIGHTARG = jsonpath,
                FUNCTION = ps_tag.tag_op_jsonb_path_exists
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- regexp_matches
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_regexp_matches(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_regexp_matches AS $func$
            SELECT ROW(_tag_key, _value)::ps_tag.tag_op_regexp_matches
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_regexp_matches(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_regexp_matches IS $$This function supports the ==~ operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.==~ (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_regexp_matches
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- regexp_not_matches
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_regexp_not_matches(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_regexp_not_matches AS $func$
            SELECT ROW(_tag_key, _value)::ps_tag.tag_op_regexp_not_matches
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_regexp_not_matches(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_regexp_not_matches IS $$This function supports the !=~ operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.!=~ (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_regexp_not_matches
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- equals
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_equals_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_equals AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_equals
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_equals_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_equals_text(text, text) IS $$This function supports the == operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.== (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_equals_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_equals(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_equals AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_equals
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_equals(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_equals(text, anyelement) IS $$This function supports the == operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.== (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_equals
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- not_equals
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_not_equals_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_not_equals AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_not_equals
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_not_equals_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_not_equals_text(text, text) IS $$This function supports the !== operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.!== (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_not_equals_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_not_equals(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_not_equals AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_not_equals
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_not_equals(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_not_equals(text, anyelement) IS $$This function supports the !== operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.!== (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_not_equals
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- less_than
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_less_than_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_less_than AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_less_than
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_less_than_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_less_than_text(text, text) IS $$This function supports the #< operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#< (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_less_than_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_less_than(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_less_than AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_less_than
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_less_than(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_less_than(text, anyelement) IS $$This function supports the #< operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#< (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_less_than
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- less_than_or_equal
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_less_than_or_equal_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_less_than_or_equal AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_less_than_or_equal
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_less_than_or_equal_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_less_than_or_equal_text(text, text) IS $$This function supports the #<= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#<= (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_less_than_or_equal_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_less_than_or_equal(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_less_than_or_equal AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_less_than_or_equal
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_less_than_or_equal(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_less_than_or_equal IS $$This function supports the #<= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#<= (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_less_than_or_equal
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- greater_than
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_greater_than_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_greater_than AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_greater_than
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_greater_than_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_greater_than_text(text, text) IS $$This function supports the #> operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#> (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_greater_than_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_greater_than(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_greater_than AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_greater_than
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_greater_than(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_greater_than(text, anyelement) IS $$This function supports the #> operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#> (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_greater_than
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- greater_than_or_equal
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_greater_than_or_equal_text(_tag_key text, _value text)
        RETURNS ps_tag.tag_op_greater_than_or_equal AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_greater_than_or_equal
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_greater_than_or_equal_text(text, text) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_greater_than_or_equal_text(text, text) IS $$This function supports the #>= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#>= (
                LEFTARG = text,
                RIGHTARG = text,
                FUNCTION = ps_tag.tag_op_greater_than_or_equal_text
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        CREATE OR REPLACE FUNCTION ps_tag.tag_op_greater_than_or_equal(_tag_key text, _value anyelement)
        RETURNS ps_tag.tag_op_greater_than_or_equal AS $func$
            SELECT ROW(_tag_key, to_jsonb(_value))::ps_tag.tag_op_greater_than_or_equal
        $func$ LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_tag.tag_op_greater_than_or_equal(text, anyelement) TO prom_reader;
        COMMENT ON FUNCTION ps_tag.tag_op_greater_than_or_equal IS $$This function supports the #>= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_tag.#>= (
                LEFTARG = text,
                RIGHTARG = anyelement,
                FUNCTION = ps_tag.tag_op_greater_than_or_equal
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;

    END;
$outer_migration_block$;
-- 003-matcher-functions.sql
DO
$outer_migration_block$
    BEGIN
        CREATE OR REPLACE FUNCTION prom_api.matcher(labels jsonb)
        RETURNS prom_api.matcher_positive
        AS $func$
            SELECT ARRAY(
                   SELECT coalesce(l.id, -1) -- -1 indicates no such label
                   FROM label_jsonb_each_text(labels-'__name__') e
                   LEFT JOIN _prom_catalog.label l
                       ON (l.key = e.key AND l.value = e.value)
                )::prom_api.matcher_positive
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.matcher(jsonb)
        IS 'returns a matcher for the JSONB, __name__ is ignored. The matcher can be used to match against a label array using @> or ? operators';
        GRANT EXECUTE ON FUNCTION prom_api.matcher(jsonb) TO prom_reader;
        
        ---------------- eq functions ------------------
        
        CREATE OR REPLACE FUNCTION prom_api.eq(labels1 prom_api.label_array, labels2 prom_api.label_array)
        RETURNS BOOLEAN
        AS $func$
            --assumes labels have metric name in position 1 and have no duplicate entries
            SELECT array_length(labels1, 1) = array_length(labels2, 1) AND labels1 @> labels2[2:]
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.eq(prom_api.label_array, prom_api.label_array)
        IS 'returns true if two label arrays are equal, ignoring the metric name';
        GRANT EXECUTE ON FUNCTION prom_api.eq(prom_api.label_array, prom_api.label_array) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.eq(labels1 prom_api.label_array, matchers prom_api.matcher_positive)
        RETURNS BOOLEAN
        AS $func$
            --assumes no duplicate entries
             SELECT array_length(labels1, 1) = (array_length(matchers, 1) + 1)
                    AND labels1 @> matchers
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.eq(prom_api.label_array, prom_api.matcher_positive)
        IS 'returns true if the label array and matchers are equal, there should not be a matcher for the metric name';
        GRANT EXECUTE ON FUNCTION prom_api.eq(prom_api.label_array, prom_api.matcher_positive) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION prom_api.eq(labels prom_api.label_array, json_labels jsonb)
        RETURNS BOOLEAN
        AS $func$
            --assumes no duplicate entries
            --do not call eq(label_array, matchers) to allow inlining
             SELECT array_length(labels, 1) = (_prom_catalog.count_jsonb_keys(json_labels-'__name__') + 1)
                    AND labels @> prom_api.matcher(json_labels)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        COMMENT ON FUNCTION prom_api.eq(prom_api.label_array, jsonb)
        IS 'returns true if the labels and jsonb are equal, ignoring the metric name';
        GRANT EXECUTE ON FUNCTION prom_api.eq(prom_api.label_array, jsonb) TO prom_reader;
        
        --------------------- op @> ------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_contains(labels prom_api.label_array, json_labels jsonb)
        RETURNS BOOLEAN
        AS $func$
            SELECT labels @> prom_api.matcher(json_labels)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_contains(prom_api.label_array, jsonb) TO prom_reader;
        
        
        --------------------- op ? ------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_match(labels prom_api.label_array, matchers prom_api.matcher_positive)
        RETURNS BOOLEAN
        AS $func$
            SELECT labels && matchers
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_match(prom_api.label_array, prom_api.matcher_positive) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_match(labels prom_api.label_array, matchers prom_api.matcher_negative)
        RETURNS BOOLEAN
        AS $func$
            SELECT NOT (labels && matchers)
        $func$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_match(prom_api.label_array, prom_api.matcher_negative) TO prom_reader;
        
        --------------------- op == !== ==~ !=~ ------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_equal(key_to_match prom_api.label_key, pat prom_api.pattern)
        RETURNS prom_api.matcher_positive
        AS $func$
            SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_positive
            FROM _prom_catalog.label l
            WHERE l.key = key_to_match and l.value = pat
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_find_key_equal(prom_api.label_key, prom_api.pattern) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_not_equal(key_to_match prom_api.label_key, pat prom_api.pattern)
        RETURNS prom_api.matcher_negative
        AS $func$
            SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_negative
            FROM _prom_catalog.label l
            WHERE l.key = key_to_match and l.value = pat
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_find_key_not_equal(prom_api.label_key, prom_api.pattern) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_regex(key_to_match prom_api.label_key, pat prom_api.pattern)
        RETURNS prom_api.matcher_positive
        AS $func$
            SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_positive
            FROM _prom_catalog.label l
            WHERE l.key = key_to_match and l.value ~ pat
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_find_key_regex(prom_api.label_key, prom_api.pattern) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.label_find_key_not_regex(key_to_match prom_api.label_key, pat prom_api.pattern)
        RETURNS prom_api.matcher_negative
        AS $func$
            SELECT COALESCE(array_agg(l.id), array[]::int[])::prom_api.matcher_negative
            FROM _prom_catalog.label l
            WHERE l.key = key_to_match and l.value ~ pat
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.label_find_key_not_regex(prom_api.label_key, prom_api.pattern) TO prom_reader;
        
        --------------------- op == !== ==~ !=~ ------------------------
        
        CREATE OR REPLACE FUNCTION _prom_catalog.match_equals(labels prom_api.label_array, _op ps_tag.tag_op_equals)
        RETURNS boolean
        AS $func$
            SELECT labels && label_find_key_equal(_op.tag_key, (_op.value#>>'{}'))::int[]
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
        GRANT EXECUTE ON FUNCTION _prom_catalog.match_equals(prom_api.label_array, ps_tag.tag_op_equals) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.match_not_equals(labels prom_api.label_array, _op ps_tag.tag_op_not_equals)
        RETURNS boolean
        AS $func$
            SELECT NOT (labels && label_find_key_not_equal(_op.tag_key, (_op.value#>>'{}'))::int[])
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
        GRANT EXECUTE ON FUNCTION _prom_catalog.match_not_equals(prom_api.label_array, ps_tag.tag_op_not_equals) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.match_regexp_matches(labels prom_api.label_array, _op ps_tag.tag_op_regexp_matches)
        RETURNS boolean
        AS $func$
            SELECT labels && label_find_key_regex(_op.tag_key, _op.value)::int[]
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
        GRANT EXECUTE ON FUNCTION _prom_catalog.match_regexp_matches(prom_api.label_array, ps_tag.tag_op_regexp_matches) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.match_regexp_not_matches(labels prom_api.label_array, _op ps_tag.tag_op_regexp_not_matches)
        RETURNS boolean
        AS $func$
            SELECT NOT (labels && label_find_key_not_regex(_op.tag_key, _op.value)::int[])
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE; -- do not make strict. it disables function inlining
        GRANT EXECUTE ON FUNCTION _prom_catalog.match_regexp_not_matches(prom_api.label_array, ps_tag.tag_op_regexp_not_matches) TO prom_reader;

    END;
$outer_migration_block$;
-- 004-ha.sql
DO
$outer_migration_block$
    BEGIN
        -- function that trigger to automatically keep the log calls
        CREATE OR REPLACE FUNCTION _prom_catalog.ha_leases_audit_fn()
            RETURNS TRIGGER
        AS
        $func$
        BEGIN
            -- update happened, leader didn't change, just lease bounds -> do nothing
            IF OLD IS NOT NULL AND OLD.leader_name = NEW.leader_name THEN
                RETURN NEW;
            END IF;
        
            -- leader changed, set lease until to existing log line
            IF OLD IS NOT NULL AND OLD.leader_name <> NEW.leader_name THEN
                UPDATE ha_leases_logs
                SET lease_until = OLD.lease_until
                WHERE cluster_name = OLD.cluster_name
                  AND leader_name = OLD.leader_name
                  AND lease_start = OLD.lease_start
                  AND lease_until IS NULL;
            END IF;
        
            -- insert happened or leader changed and new leader needs to be logged
            INSERT INTO ha_leases_logs (cluster_name, leader_name, lease_start, lease_until)
            VALUES (NEW.cluster_name, NEW.leader_name, NEW.lease_start, null);
        
            RETURN NEW;
        END;
        $func$ LANGUAGE plpgsql VOLATILE;
        
        -- ha api functions
        CREATE OR REPLACE FUNCTION _prom_catalog.update_lease(cluster TEXT, writer TEXT, min_time TIMESTAMPTZ,
                                                               max_time TIMESTAMPTZ) RETURNS ha_leases
        AS
        $func$
        DECLARE
            leader            TEXT;
            lease_start       TIMESTAMPTZ;
            lease_until       TIMESTAMPTZ;
            new_lease_timeout TIMESTAMPTZ;
            lease_state       ha_leases%ROWTYPE;
            lease_timeout INTERVAL;
            lease_refresh INTERVAL;
        BEGIN
        
            -- find lease_timeout setting;
            SELECT value::INTERVAL
            INTO lease_timeout
            FROM _prom_catalog.default
            WHERE key = 'ha_lease_timeout';
        
            -- find latest leader and their lease time range;
            SELECT h.leader_name, h.lease_start, h.lease_until
            INTO leader, lease_start, lease_until
            FROM _prom_catalog.ha_leases as h
            WHERE cluster_name = cluster;
        
            --only happens on very first call;
            IF NOT FOUND THEN
                -- no leader yet for cluster insert;
                INSERT INTO _prom_catalog.ha_leases
                VALUES (cluster, writer, min_time, max_time + lease_timeout)
                ON CONFLICT DO NOTHING;
                -- needed due to on-conflict clause;
                SELECT h.leader_name, h.lease_start, h.lease_until
                INTO leader, lease_start, lease_until
                FROM _prom_catalog.ha_leases as h
                WHERE cluster_name = cluster;
            END IF;
        
            IF leader <> writer THEN
                RAISE EXCEPTION 'LEADER_HAS_CHANGED' USING ERRCODE = 'PS010';
            END IF;
        
            -- find lease_refresh setting;
            SELECT value::INTERVAL
            INTO lease_refresh
            FROM _prom_catalog.default
            WHERE key = 'ha_lease_refresh';
        
            new_lease_timeout = max_time + lease_timeout;
            IF new_lease_timeout > lease_until + lease_refresh THEN
                UPDATE _prom_catalog.ha_leases h
                SET lease_until = new_lease_timeout
                WHERE h.cluster_name = cluster
                  AND h.leader_name = writer
                  AND h.lease_until + lease_refresh < new_lease_timeout;
                IF NOT FOUND THEN -- concurrent update
                    SELECT h.leader_name, h.lease_start, h.lease_until
                    INTO leader, lease_start, lease_until
                    FROM _prom_catalog.ha_leases as h
                    WHERE cluster_name = cluster;
                    IF leader <> writer OR lease_until <= max_time
                    THEN
                        RAISE EXCEPTION 'LEADER_HAS_CHANGED' USING ERRCODE = 'PS010';
                    END IF;
                END IF;
            END IF;
            SELECT * INTO STRICT lease_state FROM ha_leases WHERE cluster_name = cluster;
            RETURN lease_state;
        END;
        $func$ LANGUAGE plpgsql VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.update_lease(TEXT, TEXT, TIMESTAMPTZ, TIMESTAMPTZ) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.try_change_leader(cluster TEXT, new_leader TEXT,
                                                                    max_time TIMESTAMPTZ) RETURNS ha_leases
        AS
        $func$
        DECLARE
            lease_timeout INTERVAL;
            lease_state ha_leases%ROWTYPE;
        BEGIN
            -- find lease_timeout setting;
            SELECT value::INTERVAL
            INTO lease_timeout
            FROM _prom_catalog.default
            WHERE key = 'ha_lease_timeout';
        
            UPDATE _prom_catalog.ha_leases
            SET leader_name = new_leader,
                lease_start = lease_until,
                lease_until = max_time + lease_timeout
            WHERE cluster_name = cluster
              AND lease_until <= max_time;
        
            SELECT *
            INTO STRICT lease_state
            FROM ha_leases
            WHERE cluster_name = cluster;
            RETURN lease_state;
        
        END;
        $func$ LANGUAGE plpgsql VOLATILE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.try_change_leader(TEXT, TEXT, TIMESTAMPTZ) TO prom_writer;

    END;
$outer_migration_block$;
-- 005-metric-metadata.sql
DO
$outer_migration_block$
    BEGIN
        CREATE OR REPLACE FUNCTION _prom_catalog.insert_metric_metadatas(t TIMESTAMPTZ[], metric_family_name TEXT[], metric_type TEXT[], metric_unit TEXT[], metric_help TEXT[])
        RETURNS BIGINT
        AS
        $$
            DECLARE
                num_rows BIGINT;
            BEGIN
                INSERT INTO _prom_catalog.metadata (last_seen, metric_family, type, unit, help)
                    SELECT * FROM UNNEST($1, $2, $3, $4, $5) res(last_seen, metric_family, type, unit, help)
                        ORDER BY res.metric_family, res.type, res.unit, res.help
                ON CONFLICT (metric_family, type, unit, help) DO
                    UPDATE SET last_seen = EXCLUDED.last_seen;
                GET DIAGNOSTICS num_rows = ROW_COUNT;
                RETURN num_rows;
            END;
        $$ LANGUAGE plpgsql;
        GRANT EXECUTE ON FUNCTION _prom_catalog.insert_metric_metadatas(TIMESTAMPTZ[], TEXT[], TEXT[], TEXT[], TEXT[]) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION prom_api.get_metric_metadata(metric_family_name TEXT)
        RETURNS TABLE (metric_family TEXT, type TEXT, unit TEXT, help TEXT)
        AS
        $$
            SELECT metric_family, type, unit, help FROM _prom_catalog.metadata WHERE metric_family = metric_family_name ORDER BY last_seen DESC
        $$ LANGUAGE SQL;
        GRANT EXECUTE ON FUNCTION prom_api.get_metric_metadata(TEXT) TO prom_reader;
        
        -- metric_families should have unique elements, otherwise there will be duplicate rows in the returned table.
        CREATE OR REPLACE FUNCTION prom_api.get_multiple_metric_metadata(metric_families TEXT[])
        RETURNS TABLE (metric_family TEXT, type TEXT, unit TEXT, help TEXT)
        AS
        $$
            SELECT info.*
                FROM unnest(metric_families) AS family(name)
            INNER JOIN LATERAL (
                SELECT metric_family, type, unit, help FROM _prom_catalog.metadata WHERE metric_family = family.name ORDER BY last_seen DESC LIMIT 1
            ) AS info ON (true)
        $$ LANGUAGE SQL;
        GRANT EXECUTE ON FUNCTION prom_api.get_multiple_metric_metadata(TEXT[]) TO prom_reader;

    END;
$outer_migration_block$;
-- 006-exemplar.sql
DO
$outer_migration_block$
    BEGIN
        CREATE OR REPLACE FUNCTION _prom_catalog.get_exemplar_label_key_positions(metric_name TEXT)
        RETURNS JSON AS
        $$
            SELECT json_object_agg(row.key, row.position)
            FROM (
                SELECT p.key as key, p.pos as position
                FROM _prom_catalog.exemplar_label_key_position p
                WHERE p.metric_name=get_exemplar_label_key_positions.metric_name
                GROUP BY p.metric_name, p.key, p.pos
                ORDER BY p.pos
            ) AS row
        $$
        LANGUAGE SQL
        STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_exemplar_label_key_positions(TEXT) TO prom_reader;
        
        -- creates exemplar table in prom_data_exemplar schema if the table does not exists. This function
        -- must be called after the metric is created in _prom_catalog.metric as it utilizes the table_name
        -- from the metric table. It returns true if the table was created.
        CREATE OR REPLACE FUNCTION _prom_catalog.create_exemplar_table_if_not_exists(metric_name TEXT)
        RETURNS BOOLEAN
        AS
        $$
        DECLARE
            table_name_fetched TEXT;
            metric_name_fetched TEXT;
        BEGIN
            SELECT m.metric_name, m.table_name
            INTO metric_name_fetched, table_name_fetched
            FROM _prom_catalog.metric m
            WHERE m.metric_name=create_exemplar_table_if_not_exists.metric_name AND table_schema = 'prom_data';
        
            IF NOT FOUND THEN
                -- metric table entry does not exists in _prom_catalog.metric, hence we cannot create. Error out.
                -- Note: even though we can create an entry from here, we should not as it keeps the approach systematic.
                RAISE EXCEPTION '_prom_catalog.metric does not contain the table entry for % metric', metric_name;
            END IF;
            -- check if table is already created.
            IF (
                SELECT count(e.table_name) > 0 FROM _prom_catalog.exemplar e WHERE e.metric_name=create_exemplar_table_if_not_exists.metric_name
            ) THEN
                RETURN FALSE;
            END IF;
            -- table does not exists. Let's create it.
            EXECUTE FORMAT('CREATE TABLE prom_data_exemplar.%I (time TIMESTAMPTZ NOT NULL, series_id BIGINT NOT NULL, exemplar_label_values prom_api.label_value_array, value DOUBLE PRECISION NOT NULL) WITH (autovacuum_vacuum_threshold = 50000, autovacuum_analyze_threshold = 50000)',
                table_name_fetched);
            EXECUTE format('GRANT SELECT ON TABLE prom_data_exemplar.%I TO prom_reader', table_name_fetched);
            EXECUTE format('GRANT SELECT, INSERT ON TABLE prom_data_exemplar.%I TO prom_writer', table_name_fetched);
            EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE prom_data_exemplar.%I TO prom_modifier', table_name_fetched);
            EXECUTE format('CREATE UNIQUE INDEX ei_%s ON prom_data_exemplar.%I (series_id, time) INCLUDE (value)',
                           table_name_fetched, table_name_fetched);
            INSERT INTO _prom_catalog.exemplar (metric_name, table_name)
                VALUES (metric_name_fetched, table_name_fetched);
            RETURN TRUE;
        END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _prom_catalog.create_exemplar_table_if_not_exists(TEXT) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _prom_catalog.insert_exemplar_row(
            metric_table NAME,
            time_array TIMESTAMPTZ[],
            series_id_array BIGINT[],
            exemplar_label_values_array prom_api.label_value_array[],
            value_array DOUBLE PRECISION[]
        ) RETURNS BIGINT AS
        $$
        DECLARE
            num_rows BIGINT;
        BEGIN
            EXECUTE FORMAT(
                'INSERT INTO prom_data_exemplar.%1$I (time, series_id, exemplar_label_values, value)
                     SELECT * FROM unnest($1, $2::BIGINT[], $3::prom_api.label_value_array[], $4::DOUBLE PRECISION[]) a(t,s,lv,v) ORDER BY s,t ON CONFLICT DO NOTHING',
                metric_table
            ) USING time_array, series_id_array, exemplar_label_values_array, value_array;
            GET DIAGNOSTICS num_rows = ROW_COUNT;
            RETURN num_rows;
        END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _prom_catalog.insert_exemplar_row(NAME, TIMESTAMPTZ[], BIGINT[], prom_api.label_value_array[], DOUBLE PRECISION[]) TO prom_writer;

    END;
$outer_migration_block$;
-- 007-tracing-tags.sql
DO
$outer_migration_block$
    BEGIN
        
        -------------------------------------------------------------------------------
        -- get tag id
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.get_tag_id(_tag_map ps_trace.tag_map, _key ps_trace.tag_k)
        RETURNS bigint
        AS $func$
            SELECT (_tag_map->(SELECT k.id::text from _ps_trace.tag_key k WHERE k.key = _key LIMIT 1))::bigint
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.get_tag_id(ps_trace.tag_map, ps_trace.tag_k) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.get_tag_id IS $$This function supports the # operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.# (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_trace.tag_k,
                FUNCTION = _ps_trace.get_tag_id
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- has tag
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_tags_by_key(_key ps_trace.tag_k)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _key
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_tags_by_key(ps_trace.tag_k) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.has_tag(_tag_map ps_trace.tag_map, _key ps_trace.tag_k)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_tags_by_key(_key))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.has_tag(ps_trace.tag_map, ps_trace.tag_k) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.has_tag IS $$This function supports the #? operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.#? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_trace.tag_k,
                FUNCTION = _ps_trace.has_tag
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- jsonb path exists
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_jsonb_path_exists(_op ps_tag.tag_op_jsonb_path_exists)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND jsonb_path_exists(a.value, _op.value)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_jsonb_path_exists(ps_tag.tag_op_jsonb_path_exists) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_jsonb_path_exists(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_jsonb_path_exists)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_jsonb_path_exists(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_jsonb_path_exists(ps_trace.tag_map, ps_tag.tag_op_jsonb_path_exists) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_jsonb_path_exists IS $$This function supports the @? operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_jsonb_path_exists,
                FUNCTION = _ps_trace.match_jsonb_path_exists
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- regexp matches
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_regexp_matches(_op ps_tag.tag_op_regexp_matches)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            -- if the jsonb value is a string, apply the regex directly
            -- otherwise, convert the value to a text representation, back to a jsonb string, and then apply
            AND CASE jsonb_typeof(a.value)
                WHEN 'string' THEN jsonb_path_exists(a.value, format('$?(@ like_regex "%s")', _op.value)::jsonpath)
                ELSE jsonb_path_exists(to_jsonb(a.value#>>'{}'), format('$?(@ like_regex "%s")', _op.value)::jsonpath)
            END
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_regexp_matches(ps_tag.tag_op_regexp_matches) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_regexp_matches(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_regexp_matches)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_regexp_matches(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_regexp_matches(ps_trace.tag_map, ps_tag.tag_op_regexp_matches) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_regexp_matches IS $$This function supports the ==~ operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_regexp_matches,
                FUNCTION = _ps_trace.match_regexp_matches
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- regexp not matches
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_regexp_not_matches(_op ps_tag.tag_op_regexp_not_matches)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            -- if the jsonb value is a string, apply the regex directly
            -- otherwise, convert the value to a text representation, back to a jsonb string, and then apply
            AND CASE jsonb_typeof(a.value)
                WHEN 'string' THEN jsonb_path_exists(a.value, format('$?(!(@ like_regex "%s"))', _op.value)::jsonpath)
                ELSE jsonb_path_exists(to_jsonb(a.value#>>'{}'), format('$?(!(@ like_regex "%s"))', _op.value)::jsonpath)
            END
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_regexp_not_matches(ps_tag.tag_op_regexp_not_matches) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_regexp_not_matches(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_regexp_not_matches)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_regexp_not_matches(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_regexp_not_matches(ps_trace.tag_map, ps_tag.tag_op_regexp_not_matches) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_regexp_not_matches IS $$This function supports the !=~ operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_regexp_not_matches,
                FUNCTION = _ps_trace.match_regexp_not_matches
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- equals
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_equals(_op ps_tag.tag_op_equals)
        RETURNS jsonb
        AS $func$
            SELECT jsonb_build_object(a.key_id, a.id)
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND a.value = _op.value
            LIMIT 1
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_equals(ps_tag.tag_op_equals) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_equals(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_equals)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> (_ps_trace.eval_equals(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_equals(ps_trace.tag_map, ps_tag.tag_op_equals) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_equals IS $$This function supports the == operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_equals,
                FUNCTION = _ps_trace.match_equals
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- not equals
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_not_equals(_op ps_tag.tag_op_not_equals)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND a.value != _op.value
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_not_equals(ps_tag.tag_op_not_equals) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_not_equals(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_not_equals)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_not_equals(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_not_equals(ps_trace.tag_map, ps_tag.tag_op_not_equals) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_not_equals IS $$This function supports the !== operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_not_equals,
                FUNCTION = _ps_trace.match_not_equals
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- less than
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_less_than(_op ps_tag.tag_op_less_than)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND jsonb_path_exists(a.value, '$?(@ < $x)'::jsonpath, jsonb_build_object('x', _op.value))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_less_than(ps_tag.tag_op_less_than) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_less_than(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_less_than)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_less_than(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_less_than(ps_trace.tag_map, ps_tag.tag_op_less_than) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_less_than IS $$This function supports the #< operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_less_than,
                FUNCTION = _ps_trace.match_less_than
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- less than or equal
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_less_than_or_equal(_op ps_tag.tag_op_less_than_or_equal)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND jsonb_path_exists(a.value, '$?(@ <= $x)'::jsonpath, jsonb_build_object('x', _op.value))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_less_than_or_equal(ps_tag.tag_op_less_than_or_equal) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_less_than_or_equal(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_less_than_or_equal)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_less_than_or_equal(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_less_than_or_equal(ps_trace.tag_map, ps_tag.tag_op_less_than_or_equal) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_less_than_or_equal IS $$This function supports the #<= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_less_than_or_equal,
                FUNCTION = _ps_trace.match_less_than_or_equal
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- greater than
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_greater_than(_op ps_tag.tag_op_greater_than)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND jsonb_path_exists(a.value, '$?(@ > $x)'::jsonpath, jsonb_build_object('x', _op.value))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_greater_than(ps_tag.tag_op_greater_than) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_greater_than(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_greater_than)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_greater_than(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_greater_than(ps_trace.tag_map, ps_tag.tag_op_greater_than) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_greater_than IS $$This function supports the #> operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_greater_than,
                FUNCTION = _ps_trace.match_greater_than
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- greater than or equal
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION _ps_trace.eval_greater_than_or_equal(_op ps_tag.tag_op_greater_than_or_equal)
        RETURNS jsonb[]
        AS $func$
            SELECT coalesce(array_agg(jsonb_build_object(a.key_id, a.id)), array[]::jsonb[])
            FROM _ps_trace.tag a
            WHERE a.key = _op.tag_key
            AND jsonb_path_exists(a.value, '$?(@ >= $x)'::jsonpath, jsonb_build_object('x', _op.value))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.eval_greater_than_or_equal(ps_tag.tag_op_greater_than_or_equal) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION _ps_trace.match_greater_than_or_equal(_tag_map ps_trace.tag_map, _op ps_tag.tag_op_greater_than_or_equal)
        RETURNS boolean
        AS $func$
            SELECT _tag_map @> ANY(_ps_trace.eval_greater_than_or_equal(_op))
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION _ps_trace.match_greater_than_or_equal(ps_trace.tag_map, ps_tag.tag_op_greater_than_or_equal) TO prom_reader;
        COMMENT ON FUNCTION _ps_trace.match_greater_than_or_equal IS $$This function supports the #>= operator.$$;
        
        DO $do$
        BEGIN
            CREATE OPERATOR ps_trace.? (
                LEFTARG = ps_trace.tag_map,
                RIGHTARG = ps_tag.tag_op_greater_than_or_equal,
                FUNCTION = _ps_trace.match_greater_than_or_equal
            );
        EXCEPTION
            WHEN SQLSTATE '42723' THEN -- operator already exists
                null;
        END;
        $do$;
        
        -------------------------------------------------------------------------------
        -- jsonb
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.jsonb(_tag_map ps_trace.tag_map)
        RETURNS jsonb
        AS $func$
            /*
            takes an tag_map which is a map of tag_key.id to tag.id
            and returns a jsonb object containing the key value pairs of tags
            */
            SELECT jsonb_object_agg(a.key, a.value)
            FROM jsonb_each(_tag_map) x -- key is tag_key.id, value is tag.id
            INNER JOIN LATERAL -- inner join lateral enables partition elimination at execution time
            (
                SELECT
                    a.key,
                    a.value
                FROM _ps_trace.tag a
                WHERE a.id = x.value::text::bigint
                -- filter on a.key to eliminate all but one partition of the tag table
                AND a.key = (SELECT k.key from _ps_trace.tag_key k WHERE k.id = x.key::bigint)
                LIMIT 1
            ) a on (true)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.jsonb(ps_trace.tag_map) TO prom_reader;
        
        -------------------------------------------------------------------------------
        -- jsonb
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.jsonb(_tag_map ps_trace.tag_map, VARIADIC _keys ps_trace.tag_k[])
        RETURNS jsonb
        AS $func$
            /*
            takes an tag_map which is a map of tag_key.id to tag.id
            and returns a jsonb object containing the key value pairs of tags
            only the key/value pairs with keys passed as arguments are included in the output
            */
            SELECT jsonb_object_agg(a.key, a.value)
            FROM jsonb_each(_tag_map) x -- key is tag_key.id, value is tag.id
            INNER JOIN LATERAL -- inner join lateral enables partition elimination at execution time
            (
                SELECT
                    a.key,
                    a.value
                FROM _ps_trace.tag a
                WHERE a.id = x.value::text::bigint
                AND a.key = ANY(_keys) -- ANY works with partition elimination
            ) a on (true)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.jsonb(ps_trace.tag_map) TO prom_reader;
        
        -------------------------------------------------------------------------------
        -- val
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.val(_tag_map ps_trace.tag_map, _key ps_trace.tag_k)
        RETURNS ps_trace.tag_v
        AS $func$
            SELECT a.value
            FROM _ps_trace.tag a
            WHERE a.key = _key -- partition elimination
            AND a.id = (_tag_map->>(SELECT id::text FROM _ps_trace.tag_key WHERE key = _key))::bigint
            LIMIT 1
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.val(ps_trace.tag_map, ps_trace.tag_k) TO prom_reader;
        
        -------------------------------------------------------------------------------
        -- val_text
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.val_text(_tag_map ps_trace.tag_map, _key ps_trace.tag_k)
        RETURNS text
        AS $func$
            SELECT a.value#>>'{}'
            FROM _ps_trace.tag a
            WHERE a.key = _key -- partition elimination
            AND a.id = (_tag_map->>(SELECT id::text FROM _ps_trace.tag_key WHERE key = _key))::bigint
            LIMIT 1
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.val_text(ps_trace.tag_map, ps_trace.tag_k) TO prom_reader;

    END;
$outer_migration_block$;
-- 008-tracing-functions.sql
DO
$outer_migration_block$
    BEGIN
        
        -------------------------------------------------------------------------------
        -- tag type functions
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.span_tag_type()
        RETURNS ps_trace.tag_type
        AS $sql$
            SELECT (1<<0)::smallint::ps_trace.tag_type
        $sql$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.span_tag_type() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.resource_tag_type()
        RETURNS ps_trace.tag_type
        AS $sql$
            SELECT (1<<1)::smallint::ps_trace.tag_type
        $sql$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.resource_tag_type() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.event_tag_type()
        RETURNS ps_trace.tag_type
        AS $sql$
            SELECT (1<<2)::smallint::ps_trace.tag_type
        $sql$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.event_tag_type() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.link_tag_type()
        RETURNS ps_trace.tag_type
        AS $sql$
            SELECT (1<<3)::smallint::ps_trace.tag_type
        $sql$
        LANGUAGE SQL IMMUTABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.link_tag_type() TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.is_span_tag_type(_tag_type ps_trace.tag_type)
        RETURNS BOOLEAN
        AS $sql$
            SELECT _tag_type & ps_trace.span_tag_type() = ps_trace.span_tag_type()
        $sql$
        LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.is_span_tag_type(ps_trace.tag_type) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.is_resource_tag_type(_tag_type ps_trace.tag_type)
        RETURNS BOOLEAN
        AS $sql$
            SELECT _tag_type & ps_trace.resource_tag_type() = ps_trace.resource_tag_type()
        $sql$
        LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.is_resource_tag_type(ps_trace.tag_type) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.is_event_tag_type(_tag_type ps_trace.tag_type)
        RETURNS BOOLEAN
        AS $sql$
            SELECT _tag_type & ps_trace.event_tag_type() = ps_trace.event_tag_type()
        $sql$
        LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.is_event_tag_type(ps_trace.tag_type) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.is_link_tag_type(_tag_type ps_trace.tag_type)
        RETURNS BOOLEAN
        AS $sql$
            SELECT _tag_type & ps_trace.link_tag_type() = ps_trace.link_tag_type()
        $sql$
        LANGUAGE SQL IMMUTABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.is_link_tag_type(ps_trace.tag_type) TO prom_reader;
        
        -------------------------------------------------------------------------------
        -- trace tree functions
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.trace_tree(_trace_id ps_trace.trace_id)
        RETURNS TABLE
        (
            trace_id ps_trace.trace_id,
            parent_span_id bigint,
            span_id bigint,
            lvl int,
            path bigint[]
        )
        AS $func$
            WITH RECURSIVE x as
            (
                SELECT
                    s1.parent_span_id,
                    s1.span_id,
                    1 as lvl,
                    array[s1.span_id] as path
                FROM _ps_trace.span s1
                WHERE s1.trace_id = _trace_id
                AND s1.parent_span_id IS NULL
                UNION ALL
                SELECT
                    s2.parent_span_id,
                    s2.span_id,
                    x.lvl + 1 as lvl,
                    x.path || s2.span_id as path
                FROM x
                INNER JOIN LATERAL
                (
                    SELECT
                        s2.parent_span_id,
                        s2.span_id
                    FROM _ps_trace.span s2
                    WHERE s2.trace_id = _trace_id
                    AND s2.parent_span_id = x.span_id
                ) s2 ON (true)
            )
            SELECT
                _trace_id,
                x.parent_span_id,
                x.span_id,
                x.lvl,
                x.path
            FROM x
        $func$ LANGUAGE sql STABLE STRICT PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.trace_tree(ps_trace.trace_id) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.upstream_spans(_trace_id ps_trace.trace_id, _span_id bigint, _max_dist int default null)
        RETURNS TABLE
        (
            trace_id ps_trace.trace_id,
            parent_span_id bigint,
            span_id bigint,
            dist int,
            path bigint[]
        )
        AS $func$
            WITH RECURSIVE x as
            (
                SELECT
                  s1.parent_span_id,
                  s1.span_id,
                  0 as dist,
                  array[s1.span_id] as path
                FROM _ps_trace.span s1
                WHERE s1.trace_id = _trace_id
                AND s1.span_id = _span_id
                UNION ALL
                SELECT
                  s2.parent_span_id,
                  s2.span_id,
                  x.dist + 1 as dist,
                  s2.span_id || x.path as path
                FROM x
                INNER JOIN LATERAL
                (
                    SELECT
                        s2.parent_span_id,
                        s2.span_id
                    FROM _ps_trace.span s2
                    WHERE s2.trace_id = _trace_id
                    AND s2.span_id = x.parent_span_id
                ) s2 ON (true)
                WHERE (_max_dist IS NULL OR x.dist + 1 <= _max_dist)
            )
            SELECT
                _trace_id,
                x.parent_span_id,
                x.span_id,
                x.dist,
                x.path
            FROM x
        $func$ LANGUAGE sql STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.upstream_spans(ps_trace.trace_id, bigint, int) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.downstream_spans(_trace_id ps_trace.trace_id, _span_id bigint, _max_dist int default null)
        RETURNS TABLE
        (
            trace_id ps_trace.trace_id,
            parent_span_id bigint,
            span_id bigint,
            dist int,
            path bigint[]
        )
        AS $func$
            WITH RECURSIVE x as
            (
                SELECT
                  s1.parent_span_id,
                  s1.span_id,
                  0 as dist,
                  array[s1.span_id] as path
                FROM _ps_trace.span s1
                WHERE s1.trace_id = _trace_id
                AND s1.span_id = _span_id
                UNION ALL
                SELECT
                  s2.parent_span_id,
                  s2.span_id,
                  x.dist + 1 as dist,
                  x.path || s2.span_id as path
                FROM x
                INNER JOIN LATERAL
                (
                    SELECT *
                    FROM _ps_trace.span s2
                    WHERE s2.trace_id = _trace_id
                    AND s2.parent_span_id = x.span_id
                ) s2 ON (true)
                WHERE (_max_dist IS NULL OR x.dist + 1 <= _max_dist)
            )
            SELECT
                _trace_id,
                x.parent_span_id,
                x.span_id,
                x.dist,
                x.path
            FROM x
        $func$ LANGUAGE sql STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.downstream_spans(ps_trace.trace_id, bigint, int) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.sibling_spans(_trace_id ps_trace.trace_id, _span_id bigint)
        RETURNS TABLE
        (
            trace_id ps_trace.trace_id,
            parent_span_id bigint,
            span_id bigint
        )
        AS $func$
            SELECT
                _trace_id,
                s.parent_span_id,
                s.span_id
            FROM _ps_trace.span s
            WHERE s.trace_id = _trace_id
            AND s.parent_span_id =
            (
                SELECT parent_span_id
                FROM _ps_trace.span x
                WHERE x.trace_id = _trace_id
                AND x.span_id = _span_id
            )
        $func$ LANGUAGE sql STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.sibling_spans(ps_trace.trace_id, bigint) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.operation_calls(_start_time_min timestamptz, _start_time_max timestamptz)
        RETURNS TABLE
        (
            parent_operation_id bigint,
            child_operation_id bigint,
            cnt bigint
        )
        AS $func$
            SELECT
                parent.operation_id as parent_operation_id,
                child.operation_id as child_operation_id,
                count(*) as cnt
            FROM
                _ps_trace.span child
            INNER JOIN
                _ps_trace.span parent ON (parent.span_id = child.parent_span_id AND parent.trace_id = child.trace_id)
            WHERE
                child.start_time > _start_time_min AND child.start_time < _start_time_max AND
                parent.start_time > _start_time_min AND parent.start_time < _start_time_max
            GROUP BY parent.operation_id, child.operation_id
        $func$ LANGUAGE sql
        --Always prefer a mergejoin here since this is a rollup over a lot of data.
        --a nested loop is sometimes preferred by the planner but is almost never right
        --(it may only be right in cases where there is not a lot of data, and then it does
        -- not matter)
        SET  enable_nestloop = off
        STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.operation_calls(timestamptz, timestamptz) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.span_tree(_trace_id ps_trace.trace_id, _span_id bigint, _max_dist int default null)
        RETURNS TABLE
        (
            trace_id ps_trace.trace_id,
            parent_span_id bigint,
            span_id bigint,
            dist int,
            is_upstream bool,
            is_downstream bool,
            path bigint[]
        )
        AS $func$
            SELECT
                trace_id,
                parent_span_id,
                span_id,
                dist,
                true as is_upstream,
                false as is_downstream,
                path
            FROM ps_trace.upstream_spans(_trace_id, _span_id, _max_dist) u
            WHERE u.dist != 0
            UNION ALL
            SELECT
                trace_id,
                parent_span_id,
                span_id,
                dist,
                false as is_upstream,
                dist != 0 as is_downstream,
                path
            FROM ps_trace.downstream_spans(_trace_id, _span_id, _max_dist) d
        $func$ LANGUAGE sql STABLE PARALLEL SAFE;
        GRANT EXECUTE ON FUNCTION ps_trace.span_tree(ps_trace.trace_id, bigint, int) TO prom_reader;
        
        -------------------------------------------------------------------------------
        -- get / put functions
        -------------------------------------------------------------------------------
        CREATE OR REPLACE FUNCTION ps_trace.put_tag_key(_key ps_trace.tag_k, _tag_type ps_trace.tag_type)
        RETURNS bigint
        AS $func$
        DECLARE
            _tag_key _ps_trace.tag_key;
        BEGIN
            SELECT * INTO _tag_key
            FROM _ps_trace.tag_key k
            WHERE k.key = _key
            FOR UPDATE;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.tag_key as k (key, tag_type)
                VALUES (_key, _tag_type)
                ON CONFLICT (key) DO
                UPDATE SET tag_type = k.tag_type | EXCLUDED.tag_type
                WHERE k.tag_type & EXCLUDED.tag_type = 0;
        
                SELECT * INTO STRICT _tag_key
                FROM _ps_trace.tag_key k
                WHERE k.key = _key;
            ELSIF _tag_key.tag_type & _tag_type = 0 THEN
                UPDATE _ps_trace.tag_key k
                SET tag_type = k.tag_type | _tag_type
                WHERE k.id = _tag_key.id;
            END IF;
        
            RETURN _tag_key.id;
        END;
        $func$
        LANGUAGE plpgsql VOLATILE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.put_tag_key(ps_trace.tag_k, ps_trace.tag_type) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION ps_trace.put_tag(_key ps_trace.tag_k, _value ps_trace.tag_v, _tag_type ps_trace.tag_type)
        RETURNS BIGINT
        AS $func$
        DECLARE
            _tag _ps_trace.tag;
        BEGIN
            SELECT * INTO _tag
            FROM _ps_trace.tag
            WHERE key = _key
            AND value = _value
            FOR UPDATE;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.tag as t (tag_type, key_id, key, value)
                SELECT
                    _tag_type,
                    k.id,
                    _key,
                    _value
                FROM _ps_trace.tag_key k
                WHERE k.key = _key
                ON CONFLICT (key, value) DO
                UPDATE SET tag_type = t.tag_type | EXCLUDED.tag_type
                WHERE t.tag_type & EXCLUDED.tag_type = 0;
        
                SELECT * INTO STRICT _tag
                FROM _ps_trace.tag
                WHERE key = _key
                AND value = _value;
            ELSIF _tag.tag_type & _tag_type = 0 THEN
                UPDATE _ps_trace.tag as t
                SET tag_type = t.tag_type | _tag_type
                WHERE t.key = _key -- partition elimination
                AND t.id = _tag.id;
            END IF;
        
            RETURN _tag.id;
        END;
        $func$
        LANGUAGE plpgsql VOLATILE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.put_tag(ps_trace.tag_k, ps_trace.tag_v, ps_trace.tag_type) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION ps_trace.get_tag_map(_tags jsonb)
        RETURNS ps_trace.tag_map
        AS $func$
            SELECT coalesce(jsonb_object_agg(a.key_id, a.id), '{}')::ps_trace.tag_map
            FROM jsonb_each(_tags) x
            INNER JOIN LATERAL
            (
                SELECT a.key_id, a.id
                FROM _ps_trace.tag a
                WHERE x.key = a.key
                AND x.value = a.value
                LIMIT 1
            ) a on (true)
        $func$
        LANGUAGE SQL STABLE PARALLEL SAFE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.get_tag_map(jsonb) TO prom_reader;
        
        CREATE OR REPLACE FUNCTION ps_trace.put_operation(_service_name text, _span_name text, _span_kind ps_trace.span_kind)
        RETURNS bigint
        AS $func$
        DECLARE
            _service_name_id bigint;
            _operation_id bigint;
        BEGIN
            SELECT id INTO _service_name_id
            FROM _ps_trace.tag
            WHERE key = 'service.name'
            AND key_id = 1
            AND value = to_jsonb(_service_name::text)
            ;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.tag (tag_type, key, key_id, value)
                VALUES
                (
                    ps_trace.resource_tag_type(),
                    'service.name',
                    1,
                    to_jsonb(_service_name::text)
                )
                ON CONFLICT DO NOTHING
                RETURNING id INTO _service_name_id;
        
                IF _service_name_id IS NULL THEN
                    SELECT id INTO STRICT _service_name_id
                    FROM _ps_trace.tag
                    WHERE key = 'service.name'
                    AND key_id = 1
                    AND value = to_jsonb(_service_name::text);
                END IF;
            END IF;
        
            SELECT id INTO _operation_id
            FROM _ps_trace.operation
            WHERE service_name_id = _service_name_id
            AND span_kind = _span_kind
            AND span_name = _span_name;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.operation (service_name_id, span_kind, span_name)
                VALUES
                (
                    _service_name_id,
                    _span_kind,
                    _span_name
                )
                ON CONFLICT DO NOTHING
                RETURNING id INTO _operation_id;
        
                IF _operation_id IS NULL THEN
                    SELECT id INTO STRICT _operation_id
                    FROM _ps_trace.operation
                    WHERE service_name_id = _service_name_id
                    AND span_kind = _span_kind
                    AND span_name = _span_name;
                END IF;
            END IF;
        
            RETURN _operation_id;
        END;
        $func$
        LANGUAGE plpgsql VOLATILE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.put_operation(text, text, ps_trace.span_kind) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION ps_trace.put_schema_url(_schema_url text)
        RETURNS bigint
        AS $func$
        DECLARE
            _schema_url_id bigint;
        BEGIN
            SELECT id INTO _schema_url_id
            FROM _ps_trace.schema_url
            WHERE url = _schema_url;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.schema_url (url)
                VALUES
                (
                    _schema_url
                )
                ON CONFLICT DO NOTHING
                RETURNING id INTO _schema_url_id;
        
                IF _schema_url_id IS NULL THEN
                    SELECT id INTO _schema_url_id
                    FROM _ps_trace.schema_url
                    WHERE url = _schema_url;
                END IF;
            END IF;
        
            RETURN _schema_url_id;
        END;
        $func$
        LANGUAGE plpgsql VOLATILE STRICT;
        GRANT EXECUTE ON FUNCTION ps_trace.put_schema_url(text) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION ps_trace.put_instrumentation_lib(_name text, _version text, _schema_url_id bigint)
        RETURNS bigint
        AS $func$
        DECLARE
            _inst_lib_id bigint;
        BEGIN
            SELECT id INTO _inst_lib_id
            FROM _ps_trace.instrumentation_lib
            WHERE name = _name
            AND version = _version
            AND schema_url_id = _schema_url_id;
        
            IF NOT FOUND THEN
                INSERT INTO _ps_trace.instrumentation_lib (name, version, schema_url_id)
                VALUES
                (
                    _name,
                    _version,
                    _schema_url_id
                )
                ON CONFLICT DO NOTHING
                RETURNING id INTO _inst_lib_id;
        
                IF _inst_lib_id IS NULL THEN
                    SELECT id INTO STRICT _inst_lib_id
                    FROM _ps_trace.instrumentation_lib
                    WHERE name = _name
                    AND version = _version
                    AND schema_url_id = _schema_url_id;
                END IF;
            END IF;
        
            RETURN _inst_lib_id;
        END;
        $func$
        LANGUAGE plpgsql VOLATILE;
        GRANT EXECUTE ON FUNCTION ps_trace.put_instrumentation_lib(text, text, bigint) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION ps_trace.delete_all_traces()
        RETURNS void
        AS $func$
            TRUNCATE _ps_trace.link;
            TRUNCATE _ps_trace.event;
            TRUNCATE _ps_trace.span;
            TRUNCATE _ps_trace.instrumentation_lib RESTART IDENTITY;
            TRUNCATE _ps_trace.operation RESTART IDENTITY;
            TRUNCATE _ps_trace.schema_url RESTART IDENTITY CASCADE;
            TRUNCATE _ps_trace.tag RESTART IDENTITY;
            DELETE FROM _ps_trace.tag_key WHERE id >= 1000; -- keep the "standard" tag keys
            PERFORM setval('_ps_trace.tag_key_id_seq', 1000);
        $func$
        LANGUAGE sql VOLATILE;
        GRANT EXECUTE ON FUNCTION ps_trace.delete_all_traces() TO prom_writer;
        COMMENT ON FUNCTION ps_trace.delete_all_traces IS
        $$WARNING: this function deletes all spans and related tracing data in the system and restores it to a "just installed" state.$$;

    END;
$outer_migration_block$;
-- 009-tracing-views.sql
DO
$outer_migration_block$
    BEGIN
        
        CREATE OR REPLACE VIEW ps_trace.span AS
        SELECT
            s.trace_id,
            s.span_id,
            s.trace_state,
            s.parent_span_id,
            s.parent_span_id is null as is_root_span,
            t.value#>>'{}' as service_name,
            o.span_name,
            o.span_kind,
            s.start_time,
            s.end_time,
            tstzrange(s.start_time, s.end_time, '[]') as time_range,
            s.duration_ms,
            s.span_tags,
            s.dropped_tags_count,
            s.event_time,
            s.dropped_events_count,
            s.dropped_link_count,
            s.status_code,
            s.status_message,
            il.name as instrumentation_lib_name,
            il.version as instrumentation_lib_version,
            u1.url as instrumentation_lib_schema_url,
            s.resource_tags,
            s.resource_dropped_tags_count,
            u2.url as resource_schema_url
        FROM _ps_trace.span s
        LEFT OUTER JOIN _ps_trace.operation o ON (s.operation_id = o.id)
        LEFT OUTER JOIN _ps_trace.tag t ON (o.service_name_id = t.id AND t.key = 'service.name') -- partition elimination
        LEFT OUTER JOIN _ps_trace.instrumentation_lib il ON (s.instrumentation_lib_id = il.id)
        LEFT OUTER JOIN _ps_trace.schema_url u1 on (il.schema_url_id = u1.id)
        LEFT OUTER JOIN _ps_trace.schema_url u2 on (il.schema_url_id = u2.id)
        ;
        GRANT SELECT ON ps_trace.span to prom_reader;
        
        CREATE OR REPLACE VIEW ps_trace.event AS
        SELECT
            e.trace_id,
            e.span_id,
            e.time,
            e.name as event_name,
            e.tags as event_tags,
            e.dropped_tags_count,
            s.trace_state,
            t.value#>>'{}' as service_name,
            o.span_name,
            o.span_kind,
            s.start_time as span_start_time,
            s.end_time as span_end_time,
            tstzrange(s.start_time, s.end_time, '[]') as span_time_range,
            s.duration_ms as span_duration_ms,
            s.span_tags,
            s.dropped_tags_count as dropped_span_tags_count,
            s.resource_tags,
            s.resource_dropped_tags_count,
            s.status_code,
            s.status_message
        FROM _ps_trace.event e
        LEFT OUTER JOIN _ps_trace.span s on (e.span_id = s.span_id AND e.trace_id = s.trace_id)
        LEFT OUTER JOIN _ps_trace.operation o ON (s.operation_id = o.id)
        LEFT OUTER JOIN _ps_trace.tag t ON (o.service_name_id = t.id AND t.key = 'service.name') -- partition elimination
        ;
        GRANT SELECT ON ps_trace.event to prom_reader;
        
        CREATE OR REPLACE VIEW ps_trace.link AS
        SELECT
            s1.trace_id                         ,
            s1.span_id                          ,
            s1.trace_state                      ,
            s1.parent_span_id                   ,
            s1.is_root_span                     ,
            s1.service_name                     ,
            s1.span_name                        ,
            s1.span_kind                        ,
            s1.start_time                       ,
            s1.end_time                         ,
            s1.time_range                       ,
            s1.duration_ms                      ,
            s1.span_tags                        ,
            s1.dropped_tags_count               ,
            s1.event_time                       ,
            s1.dropped_events_count             ,
            s1.dropped_link_count               ,
            s1.status_code                      ,
            s1.status_message                   ,
            s1.instrumentation_lib_name         ,
            s1.instrumentation_lib_version      ,
            s1.instrumentation_lib_schema_url   ,
            s1.resource_tags                    ,
            s1.resource_dropped_tags_count      ,
            s1.resource_schema_url              ,
            s2.trace_id                         as linked_trace_id                   ,
            s2.span_id                          as linked_span_id                    ,
            s2.trace_state                      as linked_trace_state                ,
            s2.parent_span_id                   as linked_parent_span_id             ,
            s2.is_root_span                     as linked_is_root_span               ,
            s2.service_name                     as linked_service_name               ,
            s2.span_name                        as linked_span_name                  ,
            s2.span_kind                        as linked_span_kind                  ,
            s2.start_time                       as linked_start_time                 ,
            s2.end_time                         as linked_end_time                   ,
            s2.time_range                       as linked_time_range                 ,
            s2.duration_ms                      as linked_duration_ms                ,
            s2.span_tags                        as linked_span_tags                  ,
            s2.dropped_tags_count               as linked_dropped_tags_count         ,
            s2.event_time                       as linked_event_time                 ,
            s2.dropped_events_count             as linked_dropped_events_count       ,
            s2.dropped_link_count               as linked_dropped_link_count         ,
            s2.status_code                      as linked_status_code                ,
            s2.status_message                   as linked_status_message             ,
            s2.instrumentation_lib_name         as linked_inst_lib_name              ,
            s2.instrumentation_lib_version      as linked_inst_lib_version           ,
            s2.instrumentation_lib_schema_url   as linked_inst_lib_schema_url        ,
            s2.resource_tags                    as linked_resource_tags              ,
            s2.resource_dropped_tags_count      as linked_resource_dropped_tags_count,
            s2.resource_schema_url              as linked_resource_schema_url        ,
            k.tags as link_tags,
            k.dropped_tags_count as dropped_link_tags_count
        FROM _ps_trace.link k
        LEFT OUTER JOIN ps_trace.span s1 on (k.span_id = s1.span_id and k.trace_id = s1.trace_id)
        LEFT OUTER JOIN ps_trace.span s2 on (k.linked_span_id = s2.span_id and k.linked_trace_id = s2.trace_id)
        ;
        GRANT SELECT ON ps_trace.link to prom_reader;

    END;
$outer_migration_block$;
-- 010-telemetry.sql
DO
$outer_migration_block$
    BEGIN
        -- promscale_telemetry_housekeeping() does telemetry housekeeping stuff, which includes
        -- searching the table for telemetry_sync_duration, looking for stale promscales, if found,
        -- adding their values into the counter_reset row, and then cleaning up the stale
        -- promscale instances.
        -- It is concurrency safe, since it takes lock on the promscale_instance_information table,
        -- making sure that at one time, only one housekeeping is being done.
        -- 
        -- It returns TRUE if last run was beyond telemetry_sync_duration, otherwise FALSE.
        CREATE OR REPLACE FUNCTION _ps_catalog.promscale_telemetry_housekeeping(telemetry_sync_duration INTERVAL DEFAULT INTERVAL '1 HOUR')
        RETURNS BOOLEAN AS
        $$
            DECLARE
                should_update_telemetry BOOLEAN;
            BEGIN
                BEGIN
                    LOCK TABLE _ps_catalog.promscale_instance_information IN ACCESS EXCLUSIVE MODE NOWAIT; -- Do not wait for the lock as some promscale is already cleaning up the stuff.
                EXCEPTION
                    WHEN SQLSTATE '55P03' THEN
                        RETURN FALSE;
                END;
        
                -- This guarantees that we update our telemetry once every telemetry_sync_duration.
                SELECT count(*) = 0 INTO should_update_telemetry FROM _ps_catalog.promscale_instance_information
                    WHERE is_counter_reset_row = TRUE AND current_timestamp - last_updated < telemetry_sync_duration;
        
                IF NOT should_update_telemetry THEN
                    -- Some Promscale did the housekeeping work within the expected interval. Hence, nothing to do, so exit.
                    RETURN FALSE;
                END IF;
        
        
                WITH deleted_rows AS (
                    DELETE FROM _ps_catalog.promscale_instance_information
                    WHERE is_counter_reset_row = FALSE AND current_timestamp - last_updated > (telemetry_sync_duration * 2) -- consider adding stats of deleted rows to persist counter reset behaviour.
                    RETURNING *
                )
                UPDATE _ps_catalog.promscale_instance_information SET
                    promscale_ingested_samples_total                    = promscale_ingested_samples_total + COALESCE(x.del_promscale_ingested_samples_total, 0),
                    promscale_metrics_queries_executed_total            = promscale_metrics_queries_executed_total + COALESCE(x.del_promscale_metrics_queries_executed_total, 0),
                    promscale_metrics_queries_timedout_total            = promscale_metrics_queries_timedout_total + COALESCE(x.del_promscale_metrics_queries_timedout_total, 0),
                    promscale_metrics_queries_failed_total              = promscale_metrics_queries_failed_total + COALESCE(x.del_promscale_metrics_queries_failed_total, 0),
                    promscale_trace_query_requests_executed_total       = promscale_trace_query_requests_executed_total + COALESCE(x.del_promscale_trace_query_requests_executed_total, 0),
                    promscale_trace_dependency_requests_executed_total  = promscale_trace_dependency_requests_executed_total + COALESCE(x.del_promscale_trace_dependency_requests_executed_total, 0),
                    last_updated = current_timestamp
                FROM
                (
                    SELECT
                        sum(promscale_ingested_samples_total)  			        as del_promscale_ingested_samples_total,
                        sum(promscale_metrics_queries_executed_total)  		    as del_promscale_metrics_queries_executed_total,
                        sum(promscale_metrics_queries_timedout_total)  		    as del_promscale_metrics_queries_timedout_total,
                        sum(promscale_metrics_queries_failed_total)  		    as del_promscale_metrics_queries_failed_total,
                        sum(promscale_trace_query_requests_executed_total)      as del_promscale_trace_query_requests_executed_total,
                        sum(promscale_trace_dependency_requests_executed_total) as del_promscale_trace_dependency_requests_executed_total
                    FROM
                        deleted_rows
                ) x
                WHERE is_counter_reset_row = TRUE;
        
                RETURN TRUE;
            END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _ps_catalog.promscale_telemetry_housekeeping(INTERVAL) TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _ps_catalog.promscale_sql_telemetry() RETURNS VOID AS
        $$
            DECLARE result TEXT;
            BEGIN
                -- Metrics telemetry.
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.metric;
                PERFORM _ps_catalog.apply_telemetry('metrics_total', result);
        
                SELECT sum(hypertable_size(format('prom_data.%I', table_name)))::TEXT INTO result FROM _prom_catalog.metric;
                PERFORM _ps_catalog.apply_telemetry('metrics_bytes_total', result);
        
                SELECT approximate_row_count('_prom_catalog.series')::TEXT INTO result;
                PERFORM _ps_catalog.apply_telemetry('metrics_series_total_approx', result);
        
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.label WHERE key = '__tenant__';
                PERFORM _ps_catalog.apply_telemetry('metrics_multi_tenancy_tenant_count', result);
        
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.label_key WHERE key = '__cluster__';
                PERFORM _ps_catalog.apply_telemetry('metrics_ha_cluster_count', result);
        
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.metric WHERE is_view IS true;
                PERFORM _ps_catalog.apply_telemetry('metrics_registered_views', result);
        
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.exemplar;
                PERFORM _ps_catalog.apply_telemetry('metrics_exemplar_total', result);
        
                SELECT count(*)::TEXT INTO result FROM _prom_catalog.metadata;
                PERFORM _ps_catalog.apply_telemetry('metrics_metadata_total', result);
        
                SELECT value INTO result FROM _prom_catalog.default WHERE key = 'retention_period';
                PERFORM _ps_catalog.apply_telemetry('metrics_default_retention', result);
        
                SELECT value INTO result FROM _prom_catalog.default WHERE key = 'chunk_interval';
                PERFORM _ps_catalog.apply_telemetry('metrics_default_chunk_interval', result);
        
                -- Traces telemetry.
                SELECT (CASE
                            WHEN n_distinct >= 0 THEN
                                --positive values represent an absolute number of distinct elements
                                n_distinct
                            ELSE
                                --negative values represent number of distinct elements as a proportion of the total
                                -n_distinct * approximate_row_count('_ps_trace.span')
                        END)::TEXT INTO result
                FROM pg_stats
                WHERE schemaname='_ps_trace' AND tablename='span' AND attname='trace_id' AND inherited;
                PERFORM _ps_catalog.apply_telemetry('traces_total_approx', result);
        
                SELECT approximate_row_count('_ps_trace.span')::TEXT INTO result;
                PERFORM _ps_catalog.apply_telemetry('traces_spans_total_approx', result);
        
                SELECT hypertable_size('_ps_trace.span')::TEXT INTO result;
                PERFORM _ps_catalog.apply_telemetry('traces_spans_bytes_total', result);
        
                -- Others.
                -- The -1 is to ignore the row summing deleted rows i.e., the counter reset row. 
                SELECT (count(*) - 1)::TEXT INTO result FROM _ps_catalog.promscale_instance_information;
                PERFORM _ps_catalog.apply_telemetry('connector_instance_total', result);
        
                SELECT count(*)::TEXT INTO result FROM timescaledb_information.data_nodes;
                PERFORM _ps_catalog.apply_telemetry('db_node_count', result);
            END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _ps_catalog.promscale_sql_telemetry() TO prom_writer;
        
        CREATE OR REPLACE FUNCTION _ps_catalog.apply_telemetry(telemetry_name TEXT, telemetry_value TEXT) RETURNS VOID AS
        $$
            BEGIN
                IF telemetry_value IS NULL THEN
                    telemetry_value := '0';
                END IF;
        
                -- First try to use promscale_extension to fill the metadata table.
                PERFORM _prom_ext.update_tsprom_metadata(telemetry_name, telemetry_value, TRUE);
        
                -- If promscale_extension is not installed, the above line will fail. Hence, catch the exception and try the manual way.
                EXCEPTION WHEN OTHERS THEN
                    -- If this fails, throw an error so that the connector can log (or not) as appropriate.
                    INSERT INTO _timescaledb_catalog.metadata(key, value, include_in_telemetry) VALUES ('promscale_' || telemetry_name, telemetry_value, TRUE) ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, include_in_telemetry = EXCLUDED.include_in_telemetry;
            END;
        $$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON FUNCTION _ps_catalog.apply_telemetry(TEXT, TEXT) TO prom_writer;

    END;
$outer_migration_block$;
-- 011-maintenance.sql
DO
$outer_migration_block$
    BEGIN
        --Order by random with stable marking gives us same order in a statement and different
        -- orderings in different statements
        CREATE OR REPLACE FUNCTION _prom_catalog.get_metrics_that_need_drop_chunk()
        RETURNS SETOF _prom_catalog.metric
        AS $$
        BEGIN
                IF NOT _prom_catalog.is_timescaledb_installed() THEN
                            -- no real shortcut to figure out if deletion needed, return all
                            RETURN QUERY
                            SELECT m.*
                            FROM _prom_catalog.metric m
                            WHERE is_view = FALSE
                            ORDER BY random();
                            RETURN;
                END IF;
        
                RETURN QUERY
                SELECT m.*
                FROM _prom_catalog.metric m
                WHERE EXISTS (
                    SELECT 1 FROM
                    _prom_catalog.get_storage_hypertable_info(m.table_schema, m.table_name, m.is_view) hi
                    INNER JOIN public.show_chunks(hi.hypertable_relation,
                                 older_than=>NOW() - _prom_catalog.get_metric_retention_period(m.table_schema, m.metric_name)) sc ON TRUE)
                --random order also to prevent starvation
                ORDER BY random();
                RETURN;
        END
        $$
        LANGUAGE PLPGSQL STABLE;
        GRANT EXECUTE ON FUNCTION _prom_catalog.get_metrics_that_need_drop_chunk() TO prom_reader;
        
        --drop chunks from metrics tables and delete the appropriate series.
        CREATE OR REPLACE FUNCTION _prom_catalog.drop_metric_chunk_data(
            schema_name TEXT, metric_name TEXT, older_than TIMESTAMPTZ
        ) RETURNS VOID AS $func$
        DECLARE
            metric_schema NAME;
            metric_table NAME;
            metric_view BOOLEAN;
            _is_cagg BOOLEAN;
        BEGIN
            SELECT table_schema, table_name, is_view
            INTO STRICT metric_schema, metric_table, metric_view
            FROM _prom_catalog.get_metric_table_name_if_exists(schema_name, metric_name);
        
            -- need to check for caggs when dealing with metric views
            IF metric_view THEN
                SELECT is_cagg, cagg_schema, cagg_name
                INTO _is_cagg, metric_schema, metric_table
                FROM _prom_catalog.get_cagg_info(schema_name, metric_name);
                IF NOT _is_cagg THEN
                  RETURN;
                END IF;
            END IF;
        
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    PERFORM public.drop_chunks(
                        relation=>format('%I.%I', metric_schema, metric_table),
                        older_than=>older_than
                    );
                ELSE
                    PERFORM public.drop_chunks(
                        table_name=>metric_table,
                        schema_name=> metric_schema,
                        older_than=>older_than,
                        cascade_to_materializations=>FALSE
                    );
                END IF;
            ELSE
                EXECUTE format($$ DELETE FROM %I.%I WHERE time < %L $$, metric_schema, metric_table, older_than);
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION _prom_catalog.drop_metric_chunk_data(text, text, timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION _prom_catalog.drop_metric_chunk_data(text, text, timestamptz) TO prom_maintenance;
        
        --drop chunks from metrics tables and delete the appropriate series.
        CREATE OR REPLACE PROCEDURE _prom_catalog.drop_metric_chunks(
            schema_name TEXT, metric_name TEXT, older_than TIMESTAMPTZ, ran_at TIMESTAMPTZ = now(), log_verbose BOOLEAN = FALSE
        ) AS $func$
        DECLARE
            metric_id int;
            metric_schema NAME;
            metric_table NAME;
            metric_series_table NAME;
            is_metric_view BOOLEAN;
            check_time TIMESTAMPTZ;
            time_dimension_id INT;
            last_updated TIMESTAMPTZ;
            present_epoch BIGINT;
            lastT TIMESTAMPTZ;
            startT TIMESTAMPTZ;
        BEGIN
            SELECT id, table_schema, table_name, series_table, is_view
            INTO STRICT metric_id, metric_schema, metric_table, metric_series_table, is_metric_view
            FROM _prom_catalog.get_metric_table_name_if_exists(schema_name, metric_name);
        
            SELECT older_than + INTERVAL '1 hour'
            INTO check_time;
        
            startT := clock_timestamp();
        
            PERFORM _prom_catalog.set_app_name(format('promscale maintenance: data retention: metric %s', metric_name));
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: data retention: metric %: starting', metric_name;
            END IF;
        
            -- transaction 1
                IF _prom_catalog.is_timescaledb_installed() THEN
                    --Get the time dimension id for the time dimension
                    SELECT d.id
                    INTO STRICT time_dimension_id
                    FROM _timescaledb_catalog.dimension d
                    INNER JOIN _prom_catalog.get_storage_hypertable_info(metric_schema, metric_table, is_metric_view) hi ON (hi.id = d.hypertable_id)
                    ORDER BY d.id ASC
                    LIMIT 1;
        
                    --Get a tight older_than (EXCLUSIVE) because we want to know the
                    --exact cut-off where things will be dropped
                    SELECT _timescaledb_internal.to_timestamp(range_end)
                    INTO older_than
                    FROM _timescaledb_catalog.chunk c
                    INNER JOIN _timescaledb_catalog.chunk_constraint cc ON (c.id = cc.chunk_id)
                    INNER JOIN _timescaledb_catalog.dimension_slice ds ON (ds.id = cc.dimension_slice_id)
                    --range_end is exclusive so this is everything < older_than (which is also exclusive)
                    WHERE ds.dimension_id = time_dimension_id AND ds.range_end <= _timescaledb_internal.to_unix_microseconds(older_than)
                    ORDER BY range_end DESC
                    LIMIT 1;
                END IF;
                -- end this txn so we're not holding any locks on the catalog
        
                SELECT current_epoch, last_update_time INTO present_epoch, last_updated FROM
                    _prom_catalog.ids_epoch LIMIT 1;
            COMMIT;
        
            IF older_than IS NULL THEN
                -- even though there are no new Ids in need of deletion,
                -- we may still have old ones to delete
                lastT := clock_timestamp();
                PERFORM _prom_catalog.set_app_name(format('promscale maintenance: data retention: metric %s: delete expired series', metric_name));
                PERFORM _prom_catalog.delete_expired_series(metric_schema, metric_table, metric_series_table, ran_at, present_epoch, last_updated);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: metric %: done deleting expired series as only action in %', metric_name, clock_timestamp()-lastT;
                    RAISE LOG 'promscale maintenance: data retention: metric %: finished in %', metric_name, clock_timestamp()-startT;
                END IF;
                RETURN;
            END IF;
        
            -- transaction 2
                lastT := clock_timestamp();
                PERFORM _prom_catalog.set_app_name(format('promscale maintenance: data retention: metric %s: mark unused series', metric_name));
                PERFORM _prom_catalog.mark_unused_series(metric_schema, metric_table, metric_series_table, older_than, check_time);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: metric %: done marking unused series in %', metric_name, clock_timestamp()-lastT;
                END IF;
            COMMIT;
        
            -- transaction 3
                lastT := clock_timestamp();
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: data retention: metric %s: drop chunks', metric_name));
                PERFORM _prom_catalog.drop_metric_chunk_data(metric_schema, metric_name, older_than);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: metric %: done dropping chunks in %', metric_name, clock_timestamp()-lastT;
                END IF;
                SELECT current_epoch, last_update_time INTO present_epoch, last_updated FROM
                    _prom_catalog.ids_epoch LIMIT 1;
            COMMIT;
        
        
            -- transaction 4
                lastT := clock_timestamp();
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: data retention: metric %s: delete expired series', metric_name));
                PERFORM _prom_catalog.delete_expired_series(metric_schema, metric_table, metric_series_table, ran_at, present_epoch, last_updated);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: metric %: done deleting expired series in %', metric_name, clock_timestamp()-lastT;
                    RAISE LOG 'promscale maintenance: data retention: metric %: finished in %', metric_name, clock_timestamp()-startT;
                END IF;
            RETURN;
        END
        $func$
        LANGUAGE PLPGSQL;
        GRANT EXECUTE ON PROCEDURE _prom_catalog.drop_metric_chunks(text, text, timestamptz, timestamptz, boolean) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE _ps_trace.drop_span_chunks(_older_than timestamptz)
        AS $func$
        BEGIN
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    PERFORM public.drop_chunks(
                        relation=>'_ps_trace.span',
                        older_than=>_older_than
                    );
                ELSE
                    PERFORM public.drop_chunks(
                        table_name=>'span',
                        schema_name=> '_ps_trace',
                        older_than=>_older_than,
                        cascade_to_materializations=>FALSE
                    );
                END IF;
            ELSE
                DELETE FROM _ps_trace.span WHERE start_time < _older_than;
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON PROCEDURE _ps_trace.drop_span_chunks(timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON PROCEDURE _ps_trace.drop_span_chunks(timestamptz) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE _ps_trace.drop_link_chunks(_older_than timestamptz)
        AS $func$
        BEGIN
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    PERFORM public.drop_chunks(
                        relation=>'_ps_trace.link',
                        older_than=>_older_than
                    );
                ELSE
                    PERFORM public.drop_chunks(
                        table_name=>'link',
                        schema_name=> '_ps_trace',
                        older_than=>_older_than,
                        cascade_to_materializations=>FALSE
                    );
                END IF;
            ELSE
                DELETE FROM _ps_trace.link WHERE span_start_time < _older_than;
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON PROCEDURE _ps_trace.drop_link_chunks(timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON PROCEDURE _ps_trace.drop_link_chunks(timestamptz) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE _ps_trace.drop_event_chunks(_older_than timestamptz)
        AS $func$
        BEGIN
            IF _prom_catalog.is_timescaledb_installed() THEN
                IF _prom_catalog.get_timescale_major_version() >= 2 THEN
                    PERFORM public.drop_chunks(
                        relation=>'_ps_trace.event',
                        older_than=>_older_than
                    );
                ELSE
                    PERFORM public.drop_chunks(
                        table_name=>'event',
                        schema_name=> '_ps_trace',
                        older_than=>_older_than,
                        cascade_to_materializations=>FALSE
                    );
                END IF;
            ELSE
                DELETE FROM _ps_trace.event WHERE time < _older_than;
            END IF;
        END
        $func$
        LANGUAGE PLPGSQL
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON PROCEDURE _ps_trace.drop_event_chunks(timestamptz) FROM PUBLIC;
        GRANT EXECUTE ON PROCEDURE _ps_trace.drop_event_chunks(timestamptz) TO prom_maintenance;
        
        CREATE OR REPLACE FUNCTION ps_trace.set_trace_retention_period(_trace_retention_period INTERVAL)
        RETURNS BOOLEAN
        AS $$
            INSERT INTO _prom_catalog.default(key, value) VALUES ('trace_retention_period', _trace_retention_period::text)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
            SELECT true;
        $$
        LANGUAGE SQL VOLATILE;
        COMMENT ON FUNCTION ps_trace.set_trace_retention_period(INTERVAL)
        IS 'set the retention period for trace data';
        GRANT EXECUTE ON FUNCTION ps_trace.set_trace_retention_period(INTERVAL) TO prom_admin;
        
        CREATE OR REPLACE FUNCTION ps_trace.get_trace_retention_period()
        RETURNS INTERVAL
        AS $$
            SELECT value::interval
            FROM _prom_catalog.default
            WHERE key = 'trace_retention_period'
        $$
        LANGUAGE SQL STABLE;
        COMMENT ON FUNCTION ps_trace.get_trace_retention_period()
        IS 'get the retention period for trace data';
        GRANT EXECUTE ON FUNCTION ps_trace.get_trace_retention_period() TO prom_reader;
        
        CREATE OR REPLACE PROCEDURE _ps_trace.execute_data_retention_policy(log_verbose boolean)
        AS $$
        DECLARE
            _trace_retention_period interval;
            _older_than timestamptz;
            _last timestamptz;
            _start timestamptz;
            _message_text text;
            _pg_exception_detail text;
            _pg_exception_hint text;
        BEGIN
            _start := clock_timestamp();
        
            PERFORM _prom_catalog.set_app_name('promscale maintenance: data retention: tracing');
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: data retention: tracing: starting';
            END IF;
        
            _trace_retention_period = ps_trace.get_trace_retention_period();
            IF _trace_retention_period is null THEN
                RAISE EXCEPTION 'promscale maintenance: data retention: tracing: trace_retention_period is null.';
            END IF;
        
            _older_than = now() - _trace_retention_period;
            IF _older_than >= now() THEN -- bail early. no need to continue
                RAISE WARNING 'promscale maintenance: data retention: tracing: aborting. trace_retention_period set to zero or negative interval';
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: tracing: finished in %', clock_timestamp()-_start;
                END IF;
                RETURN;
            END IF;
        
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: data retention: tracing: dropping trace chunks older than %s', _older_than;
            END IF;
        
            _last := clock_timestamp();
            PERFORM _prom_catalog.set_app_name('promscale maintenance: data retention: tracing: deleting link data');
            BEGIN
                CALL _ps_trace.drop_link_chunks(_older_than);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: tracing: done deleting link data in %', clock_timestamp()-_last;
                END IF;
            EXCEPTION WHEN OTHERS THEN
                GET STACKED DIAGNOSTICS
                    _message_text = MESSAGE_TEXT,
                    _pg_exception_detail = PG_EXCEPTION_DETAIL,
                    _pg_exception_hint = PG_EXCEPTION_HINT;
                RAISE WARNING 'promscale maintenance: data retention: tracing: failed to delete link data. % % % %',
                    _message_text, _pg_exception_detail, _pg_exception_hint, clock_timestamp()-_last;
            END;
            COMMIT;
        
            _last := clock_timestamp();
            PERFORM _prom_catalog.set_app_name('promscale maintenance: data retention: tracing: deleting event data');
            BEGIN
                CALL _ps_trace.drop_event_chunks(_older_than);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: tracing: done deleting event data in %', clock_timestamp()-_last;
                END IF;
            EXCEPTION WHEN OTHERS THEN
                GET STACKED DIAGNOSTICS
                    _message_text = MESSAGE_TEXT,
                    _pg_exception_detail = PG_EXCEPTION_DETAIL,
                    _pg_exception_hint = PG_EXCEPTION_HINT;
                RAISE WARNING 'promscale maintenance: data retention: tracing: failed to delete event data. % % % %',
                    _message_text, _pg_exception_detail, _pg_exception_hint, clock_timestamp()-_last;
            END;
            COMMIT;
        
            _last := clock_timestamp();
            PERFORM _prom_catalog.set_app_name('promscale maintenance: data retention: tracing: deleting span data');
            BEGIN
                CALL _ps_trace.drop_span_chunks(_older_than);
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: data retention: tracing: done deleting span data in %', clock_timestamp()-_last;
                END IF;
            EXCEPTION WHEN OTHERS THEN
                GET STACKED DIAGNOSTICS
                    _message_text = MESSAGE_TEXT,
                    _pg_exception_detail = PG_EXCEPTION_DETAIL,
                    _pg_exception_hint = PG_EXCEPTION_HINT;
                RAISE WARNING 'promscale maintenance: data retention: tracing: failed to delete span data. % % % %',
                    _message_text, _pg_exception_detail, _pg_exception_hint, clock_timestamp()-_last;
            END;
            COMMIT;
        
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: data retention: tracing: finished in %', clock_timestamp()-_start;
            END IF;
        END;
        $$ LANGUAGE PLPGSQL;
        COMMENT ON PROCEDURE _ps_trace.execute_data_retention_policy(boolean)
        IS 'drops old data according to the data retention policy. This procedure should be run regularly in a cron job';
        GRANT EXECUTE ON PROCEDURE _ps_trace.execute_data_retention_policy(boolean) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE _prom_catalog.execute_data_retention_policy(log_verbose boolean)
        AS $$
        DECLARE
            r _prom_catalog.metric;
            remaining_metrics _prom_catalog.metric[] DEFAULT '{}';
        BEGIN
            --Do one loop with metric that could be locked without waiting.
            --This allows you to do everything you can while avoiding lock contention.
            --Then come back for the metrics that would have needed to wait on the lock.
            --Hopefully, that lock is now freed. The second loop waits for the lock
            --to prevent starvation.
            FOR r IN
                SELECT *
                FROM _prom_catalog.get_metrics_that_need_drop_chunk()
            LOOP
                IF NOT _prom_catalog.lock_metric_for_maintenance(r.id, wait=>false) THEN
                    remaining_metrics := remaining_metrics || r;
                    CONTINUE;
                END IF;
                CALL _prom_catalog.drop_metric_chunks(r.table_schema, r.metric_name, NOW() - _prom_catalog.get_metric_retention_period(r.table_schema, r.metric_name), log_verbose=>log_verbose);
                PERFORM _prom_catalog.unlock_metric_for_maintenance(r.id);
        
                COMMIT;
            END LOOP;
        
            IF log_verbose AND array_length(remaining_metrics, 1) > 0 THEN
                RAISE LOG 'promscale maintenance: data retention: need to wait to grab locks on % metrics', array_length(remaining_metrics, 1);
            END IF;
        
            FOR r IN
                SELECT *
                FROM unnest(remaining_metrics)
            LOOP
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: data retention: metric %s: wait for lock', r.metric_name));
                PERFORM _prom_catalog.lock_metric_for_maintenance(r.id);
                CALL _prom_catalog.drop_metric_chunks(r.table_schema, r.metric_name, NOW() - _prom_catalog.get_metric_retention_period(r.table_schema, r.metric_name), log_verbose=>log_verbose);
                PERFORM _prom_catalog.unlock_metric_for_maintenance(r.id);
        
                COMMIT;
            END LOOP;
        END;
        $$ LANGUAGE PLPGSQL;
        COMMENT ON PROCEDURE _prom_catalog.execute_data_retention_policy(boolean)
        IS 'drops old data according to the data retention policy. This procedure should be run regularly in a cron job';
        GRANT EXECUTE ON PROCEDURE _prom_catalog.execute_data_retention_policy(boolean) TO prom_maintenance;
        
        --public procedure to be called by cron
        --right now just does data retention but name is generic so that
        --we can add stuff later without needing people to change their cron scripts
        --should be the last thing run in a session so that all session locks
        --are guaranteed released on error.
        CREATE OR REPLACE PROCEDURE prom_api.execute_maintenance(log_verbose boolean = false)
        AS $$
        DECLARE
           startT TIMESTAMPTZ;
        BEGIN
            startT := clock_timestamp();
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: data retention: starting';
            END IF;
        
            PERFORM _prom_catalog.set_app_name( format('promscale maintenance: data retention'));
            CALL _prom_catalog.execute_data_retention_policy(log_verbose=>log_verbose);
            CALL _ps_trace.execute_data_retention_policy(log_verbose=>log_verbose);
        
            IF NOT _prom_catalog.is_timescaledb_oss() AND _prom_catalog.get_timescale_major_version() >= 2 THEN
                IF log_verbose THEN
                    RAISE LOG 'promscale maintenance: compression: starting';
                END IF;
        
                PERFORM _prom_catalog.set_app_name( format('promscale maintenance: compression'));
                CALL _prom_catalog.execute_compression_policy(log_verbose=>log_verbose);
            END IF;
        
            IF log_verbose THEN
                RAISE LOG 'promscale maintenance: finished in %', clock_timestamp()-startT;
            END IF;
        
            IF clock_timestamp()-startT > INTERVAL '12 hours' THEN
                RAISE WARNING 'promscale maintenance jobs are taking too long (one run took %)', clock_timestamp()-startT
                      USING HINT = 'Please consider increasing the number of maintenance jobs using config_maintenance_jobs()';
            END IF;
        END;
        $$ LANGUAGE PLPGSQL;
        COMMENT ON PROCEDURE prom_api.execute_maintenance(boolean)
        IS 'Execute maintenance tasks like dropping data according to retention policy. This procedure should be run regularly in a cron job';
        GRANT EXECUTE ON PROCEDURE prom_api.execute_maintenance(boolean) TO prom_maintenance;
        
        CREATE OR REPLACE PROCEDURE _prom_catalog.execute_maintenance_job(job_id int, config jsonb)
        AS $$
        DECLARE
           log_verbose boolean;
           ae_key text;
           ae_value text;
           ae_load boolean := FALSE;
        BEGIN
            log_verbose := coalesce(config->>'log_verbose', 'false')::boolean;
        
            --if auto_explain enabled in config, turn it on in a best-effort way
            --i.e. if it fails (most likely due to lack of superuser priviliges) move on anyway.
            BEGIN
                FOR ae_key, ae_value IN
                   SELECT * FROM jsonb_each_text(config->'auto_explain')
                LOOP
                    IF NOT ae_load THEN
                        ae_load := true;
                        LOAD 'auto_explain';
                    END IF;
        
                    PERFORM set_config('auto_explain.'|| ae_key, ae_value, FALSE);
                END LOOP;
            EXCEPTION WHEN OTHERS THEN
                RAISE WARNING 'could not set auto_explain options';
            END;
        
        
            CALL prom_api.execute_maintenance(log_verbose=>log_verbose);
        END
        $$ LANGUAGE PLPGSQL;
        
        CREATE OR REPLACE FUNCTION prom_api.config_maintenance_jobs(number_jobs int, new_schedule_interval interval, new_config jsonb = NULL)
        RETURNS BOOLEAN
        AS $func$
        DECLARE
          cnt int;
          log_verbose boolean;
        BEGIN
            --check format of config
            log_verbose := coalesce(new_config->>'log_verbose', 'false')::boolean;
        
            PERFORM public.delete_job(job_id)
            FROM timescaledb_information.jobs
            WHERE proc_schema = '_prom_catalog' AND proc_name = 'execute_maintenance_job' AND (schedule_interval != new_schedule_interval OR new_config IS DISTINCT FROM config) ;
        
        
            SELECT count(*) INTO cnt
            FROM timescaledb_information.jobs
            WHERE proc_schema = '_prom_catalog' AND proc_name = 'execute_maintenance_job';
        
            IF cnt < number_jobs THEN
                PERFORM public.add_job('_prom_catalog.execute_maintenance_job', new_schedule_interval, config=>new_config)
                FROM generate_series(1, number_jobs-cnt);
            END IF;
        
            IF cnt > number_jobs THEN
                PERFORM public.delete_job(job_id)
                FROM timescaledb_information.jobs
                WHERE proc_schema = '_prom_catalog' AND proc_name = 'execute_maintenance_job'
                LIMIT (cnt-number_jobs);
            END IF;
        
            RETURN TRUE;
        END
        $func$
        LANGUAGE PLPGSQL VOLATILE
        --security definer to add jobs as the logged-in user
        SECURITY DEFINER
        --search path must be set for security definer
        SET search_path = pg_temp;
        --redundant given schema settings but extra caution for security definers
        REVOKE ALL ON FUNCTION prom_api.config_maintenance_jobs(int, interval, jsonb) FROM PUBLIC;
        GRANT EXECUTE ON FUNCTION prom_api.config_maintenance_jobs(int, interval, jsonb) TO prom_admin;
        COMMENT ON FUNCTION prom_api.config_maintenance_jobs(int, interval, jsonb)
        IS 'Configure the number of maintence jobs run by the job scheduler, as well as their scheduled interval';

    END;
$outer_migration_block$;
-- 012-remote-commands.sql
DO
$outer_migration_block$
    BEGIN
        
        /*
            Some remote commands are registered in the preinstall or upgrade scripts.
        
            Two remote commands are registered in the idempotent scripts which get run
            at the end of a fresh install and after every version upgrade. Thus, it's
            difficult to know where in the sequence these two will show up.
        
            This update will ensure a consistent ordering of our remote commands and
            place any potential user defined remote commands at the end of ours in
            original order.
        */
        WITH x(key, seq) AS
        (
            VALUES
            ('create_prom_reader'                        ,  1),
            ('create_prom_writer'                        ,  2),
            ('create_prom_modifier'                      ,  3),
            ('create_prom_admin'                         ,  4),
            ('create_prom_maintenance'                   ,  5),
            ('grant_prom_reader_prom_writer'             ,  6),
            ('create_schemas'                            ,  7),
            ('tracing_types'                             ,  8),
            ('_prom_catalog.do_decompress_chunks_after' ,  9),
            ('_prom_catalog.compress_old_chunks'        , 10)
        )
        UPDATE _prom_catalog.remote_commands u SET seq = z.seq
        FROM
        (
            -- our remote commands from above
            SELECT key, seq
            FROM x
            UNION
            -- any other remote commands get listed afterwards
            SELECT key, (SELECT max(seq) FROM x) + row_number() OVER (ORDER BY seq)
            FROM _prom_catalog.remote_commands k
            WHERE NOT EXISTS
            (
                SELECT 1
                FROM x
                WHERE x.key = k.key
            )
            ORDER BY seq
        ) z
        WHERE u.key = z.key
        ;
    END;
$outer_migration_block$;
-- 013-apply-permissions.sql
DO
$outer_migration_block$
    BEGIN
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA ps_tag FROM PUBLIC;
        REVOKE ALL ON ALL PROCEDURES IN SCHEMA ps_tag FROM PUBLIC;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA _prom_catalog FROM PUBLIC;
        REVOKE ALL ON ALL PROCEDURES IN SCHEMA _prom_catalog FROM PUBLIC;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA prom_api FROM PUBLIC;
        REVOKE ALL ON ALL PROCEDURES IN SCHEMA prom_api FROM PUBLIC;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA _ps_trace FROM PUBLIC;
        REVOKE ALL ON ALL PROCEDURES IN SCHEMA _ps_trace FROM PUBLIC;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA ps_trace FROM PUBLIC;
        REVOKE ALL ON ALL PROCEDURES IN SCHEMA ps_trace FROM PUBLIC;
    END;
$outer_migration_block$;
