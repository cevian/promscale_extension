
-- {{filename}}
DO
$outer_migration_block$
    BEGIN
        {{body|indent(8)}}
        RAISE LOG 'Applied idempotent {{filename}}';
    END;
$outer_migration_block$;
