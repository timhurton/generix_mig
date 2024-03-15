DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 07/03/2024  Tim Hurton  Initial Revision. Group all new log records under a single run id. Carried out at
   *                         the end of a successful run and before a new run, in case the previous run failed
   *                         before this step.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'SET_RUN_ID';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
BEGIN 
  v_step := 10;

  WITH new_run_id AS (SELECT COALESCE(max(run_id),0)+1 AS id FROM transform_log)
  UPDATE transform_log 
     SET run_id = (SELECT id FROM new_run_id)
   WHERE run_id IS NULL;

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