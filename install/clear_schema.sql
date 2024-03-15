/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 11/03/2024  Tim Hurton  Initial Revision. Clear down all the existing objects ina parameterised schema.
   *                         The SET command is one way we can get around passing a parameter into a PL/pfSQL 
   *                         script without having to create a procedure as a work around. We do not want to
   *                         this as a procedure as these are part of what w are trying to drop. For the same
   *                         reason there is no error handling.
   * 
   ***************************************************************************************************************  
*/   
set myvars.v_schema TO :'v_schema';
DO $$
DECLARE
    v_schema_name VARCHAR(40) := current_setting('myvars.v_schema',TRUE);
    object_name text;
BEGIN
    -- Drop tables

    FOR object_name IN (SELECT table_name
                          FROM information_schema.tables 
                         WHERE table_schema = v_schema_name 
                           AND table_type = 'BASE TABLE') 
    LOOP
      EXECUTE'DROP TABLE IF EXISTS ' || v_schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop sequences
    FOR object_name IN (SELECT sequence_name 
                          FROM information_schema.sequences 
                         WHERE sequence_schema = v_schema_name) 
    LOOP
        EXECUTE 'DROP SEQUENCE IF EXISTS ' || v_schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop views
    FOR object_name IN (SELECT table_name 
                          FROM information_schema.tables 
                         WHERE table_schema = v_schema_name 
                          AND table_type = 'VIEW') 
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS ' || v_schema_name || '.' || object_name || ' CASCADE';
    END LOOP;

    -- Drop functions

    FOR object_name IN (SELECT routine_name 
                          FROM information_schema.routines 
                         WHERE routine_schema = v_schema_name 
                          AND routine_type = 'FUNCTION'
                          AND routine_name NOT LIKE 'dblink%'
                          AND routine_name NOT LIKE 'postgres_fdw%') 
    LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || v_schema_name || '.' || object_name || ' CASCADE';
    END LOOP;
    
    -- Drop procedures
    FOR object_name IN (SELECT routine_name 
                          FROM information_schema.routines 
                         WHERE routine_schema = v_schema_name 
                          AND routine_type = 'PROCEDURE') 
    LOOP
        EXECUTE 'DROP PROCEDURE IF EXISTS ' || v_schema_name || '.' || object_name || ' CASCADE';
    END LOOP;
END;
$$ LANGUAGE plpgsql;
