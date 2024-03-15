DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Build views to source schema so we do not have to access WMS data
   *                         with a qualifying schema name.
   * 
   ***************************************************************************************************************  
*/   
DECLARE
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'BUILD_SOURCE_VIEWS.SQL';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_hint    TEXT;
  v_context TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  c_build_source_views CURSOR FOR 
    SELECT 'DROP VIEW IF EXISTS "' || tablename || '";' AS drop_view
          ,'CREATE VIEW "' || tablename || '" AS SELECT * FROM "'|| schemaname || '".' || tablename || ';' AS create_view
	  FROM pg_catalog.pg_tables 
	  JOIN client_parameters cp ON (cp.source_schema = schemaname);  

  r_build_source_views RECORD;
  
  v_result VARCHAR(80);
BEGIN

  CALL proc_connect_dblink('UtilsConnection');

  v_step := 10;
  OPEN c_build_source_views;

  LOOP
    v_step := 20;
    FETCH c_build_source_views INTO r_build_source_views;
    
    EXIT WHEN NOT FOUND; -- No more processing if there wasn't a new record.

    v_step := 30;
    EXECUTE r_build_source_views.drop_view;
    v_step := 30;
    EXECUTE r_build_source_views.create_view;
  END LOOP;
  
  v_step := 40;
  CLOSE c_build_source_views;
EXCEPTION
  -- START standard error logging
  WHEN OTHERS THEN
    GET stacked DIAGNOSTICS
      v_state := returned_sqlstate
     ,v_msg := message_text
     ,v_detail := pg_exception_detail;
    CALL proc_error(p_module      => v_module
                   ,p_error_state => v_state
                   ,p_error_msg   => v_msg
                   ,p_error_dtl   => v_detail
                   ,p_step        => v_step
                   );
    RAISE;
  -- END standard error logging
END;
$$