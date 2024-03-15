DROP PROCEDURE IF EXISTS proc_error;
CREATE OR REPLACE PROCEDURE proc_error(p_module      VARCHAR
                                      ,p_error_state VARCHAR
                                      ,p_error_msg   VARCHAR
                                      ,p_error_dtl   VARCHAR DEFAULT NULL
                                      ,p_step        INTEGER DEFAULT NULL
                                      )
/* **********************************************************************************  
   *
   * Date        Developer  Description
   * ==========  =========  ===========
   * 06/03/2024  T. Hurton  Initial Revision. Error logging utility for neoWMS-side.
   *                        Passes values to an equivalent procedure on Utils, which
   *                        can then autonomously commit the data.
   * 
   **********************************************************************************  
*/   
LANGUAGE plpgsql AS $$
DECLARE   
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_ERROR';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_sql    VARCHAR(1000);
  v_result VARCHAR(20);
  v_user   VARCHAR(80) := SESSION_USER;
BEGIN 
  v_sql := 'CALL public.proc_utils_error_log(' ||
             'p_module => ''' || p_module || '''' ||
			 ',p_user => ''' || v_user || '''' || 
			 ',p_error_state => ''' || p_error_state || '''' ||
			 ',p_error_msg=> ''' || p_error_msg || '''';

  IF p_error_dtl IS NOT NULL THEN 
    v_sql := v_sql || ',p_error_dtl => ''' || p_error_dtl || '''';
  ELSE 
    v_sql := v_sql || ',p_error_dtl => NULL::VARCHAR';
  END IF;

  IF p_step IS NOT NULL THEN 
    v_sql := v_sql || ',p_step => ' || p_step::varchar || '';
  ELSE 
    v_sql := v_sql || ',p_step => NULL::INT';
  END IF;

  v_sql := v_sql || ');';
  
  RAISE NOTICE 'Sql %', v_sql;  -- Only required for debugging purposes

  SELECT dblink_exec('UtilsConnection', v_sql)
    INTO v_result;
	
EXCEPTION
-- If there is an erorr here we just report it. Can't call error routine as we 
-- would just get stuck in a loop.
-- Begin standard error handling
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      v_state := returned_sqlstate
     ,v_msg := message_text
     ,v_detail := pg_exception_detail;
    RAISE NOTICE E' Module % encountered exception at % state: %
      MESSAGE: %
      DETAIL: %
      STEP: %'
      ,v_module
      ,clock_timestamp()
      ,v_state
      ,v_msg
      ,v_detail
      ,v_step;
	RAISE;
-- End standard error handling
END;
$$;
