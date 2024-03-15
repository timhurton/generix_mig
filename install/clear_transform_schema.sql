CREATE OR REPLACE FUNCTION delete_all_objects_in_schema(schema_name text)
RETURNS void AS $$
DECLARE
    object_name text;
BEGIN
    -- Drop tables
    FOR object_name IN (SELECT table_name FROM information_schema.tables WHERE table_schema = schema_name AND table_type = 'BASE TABLE') 
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop sequences
    FOR object_name IN (SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = schema_name) 
    LOOP
        EXECUTE 'DROP SEQUENCE IF EXISTS ' || schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop views
    FOR object_name IN (SELECT table_name FROM information_schema.tables WHERE table_schema = schema_name AND table_type = 'VIEW') 
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS ' || schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop functions
    FOR object_name IN (SELECT routine_name FROM information_schema.routines WHERE routine_schema = schema_name AND routine_type = 'FUNCTION') 
    LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || schema_name || '.' || object_name || ' CASCADE';
    END LOOP;
END;
$$ LANGUAGE plpgsql;
