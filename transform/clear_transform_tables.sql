DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 06/03/2024  T. Hurton   Initial Revision. Clear down infrasctructure tabls of previous run's data.
   * 
   ***************************************************************************************************************  
*/   
DECLARE
  --
  -- BEGIN standard declarations
  --
  v_module transform_log.module_name%TYPE := 'CLEAR_TRANSFORM_TABLES.SQL';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  --
  -- END standard declarations
  --
  vReturn varchar(20); 
    
BEGIN
  --
  CALL proc_connect_dblink('UtilsConnection');

  -- Ensure we start with emtpy tables
  v_step := 10;
  --  Clear down infrastructure tables
  DELETE FROM client_parameters;
  DELETE FROM migration_reports;
  DELETE FROM index_audit;
  DELETE FROM constraint_audit;
        
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