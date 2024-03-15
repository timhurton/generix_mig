DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 26/02/2024  Tim Hurton  Initial Revision. Loop through index_audit table recreating indexes that were 
   *                         dropped earlier in the transform process.
   * 
   ***************************************************************************************************************  
*/   
DECLARE
   c_indexes CURSOR FOR 
     SELECT index_name
       FROM index_audit ca 
      WHERE audit_type = 'BEFORE';
           
  v_module transform_log.module_name%TYPE := 'REBUILD_INDEXES.SQL';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_result VARCHAR(20); 
  r_index  RECORD;


    
BEGIN
  v_step := 10;
  -- Make sure we have the connection to the remote DB needed for logging and error handling.
  CALL proc_connect_dblink('UtilsConnection');

  v_step := 20;
  CALL proc_log(p_module => v_module
               ,p_event => 'START');


  OPEN c_indexes;                              
                              
  v_step := 20;
  LOOP

    FETCH c_indexes INTO r_index;
    EXIT WHEN NOT FOUND; -- No more processing if there wasn't a new record.

    CALL proc_rebuild_index(p_index_name => r_index.index_name
                           ,p_allow_unique => TRUE); 
  
  END LOOP;
  
  v_step := 30;
  CALL proc_log(p_module => v_module
               ,p_event => 'END');
  
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