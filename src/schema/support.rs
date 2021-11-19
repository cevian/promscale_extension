//! Here we redefine functions which are defined in `promscale`, attaching the
//! support function to them. It's undesirable to redefine those functions from
//! `promscale` because adding a support function requires superuser privileges.
//!
//! The original definition for these can found in the `pkg/migrations` of the
//! [promscale] project.
//!
//! [promscale]: https://www.github.com/timescale/promscale

use pgx::*;

// First we need to define some objects which should be defined by `promscale`
// This is mostly so that the extension can be installed standalone, which is
// convenient for development.
extension_sql!(r#"
CREATE OR REPLACE FUNCTION swallow_error(query text) RETURNS VOID AS
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

DROP FUNCTION swallow_error(text);
"#,
    name = "create_promscale_objects"
);


extension_sql!(
    r#"
CREATE OR REPLACE FUNCTION @extschema@.label_find_key_equal(key_to_match label_key, pat pattern)
RETURNS matcher_positive
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_positive
    FROM label l
    WHERE l.key = key_to_match and l.value = pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.make_call_subquery_support;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_not_equal(key_to_match label_key, pat pattern)
RETURNS matcher_negative
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_negative
    FROM label l
    WHERE l.key = key_to_match and l.value = pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.make_call_subquery_support;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_regex(key_to_match label_key, pat pattern)
RETURNS matcher_positive
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_positive
    FROM label l
    WHERE l.key = key_to_match and l.value ~ pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.make_call_subquery_support;

CREATE OR REPLACE FUNCTION @extschema@.label_find_key_not_regex(key_to_match label_key, pat pattern)
RETURNS matcher_negative
AS $func$
    SELECT COALESCE(array_agg(l.id), array[]::int[])::matcher_negative
    FROM label l
    WHERE l.key = key_to_match and l.value ~ pat
$func$
LANGUAGE SQL STABLE PARALLEL SAFE
SUPPORT @extschema@.make_call_subquery_support;

"#,
    name = "attach_support_to_label_find_key_equal",
    requires = ["create_promscale_objects"]
);

extension_sql!(
    r#"
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_equal(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_not_equal(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_regex(label_key, pattern) TO prom_reader;
GRANT EXECUTE ON FUNCTION @extschema@.label_find_key_not_regex(label_key, pattern) TO prom_reader;
"#,
    name = "grant_exec_label_find_key_equal",
    requires = ["attach_support_to_label_find_key_equal"]
);

extension_sql!(
    r#"
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
"#,
    name = "create_label_key_operators",
    requires = ["attach_support_to_label_find_key_equal"]
);

