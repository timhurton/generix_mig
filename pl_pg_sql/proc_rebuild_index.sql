CREATE OR REPLACE PROCEDURE proc_rebuild_index(p_index_name   IN VARCHAR
                                              ,p_allow_unique IN BOOLEAN DEFAULT TRUE) 
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 26/02/2024  Tim Hurton  Initial Revision. Retrieve the creation script for the index parameter, adjust as 
   *                         required and call the index to replace it.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_REBUILD_INDEX';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_index_definition VARCHAR(200);
BEGIN 
  v_step := 10;
  CALL proc_log(p_module => v_module
               ,p_event => 'START'
               ,p_desc => 'Index: ' || p_index_name || ' allow unique: ' || p_allow_unique);
             
  SELECT index_definition
    INTO v_index_definition
    FROM index_audit ia
   WHERE ia.audit_type = 'BEFORE'
     AND index_name = p_index_name;
   
  IF NOT FOUND THEN 
    CALL proc_log(p_module => v_module
                 ,p_event => 'FAILURE'
                 ,p_desc => 'Failed to find details of index: ' || p_index_name);
    RAISE EXCEPTION USING
      ERRCODE = 'A0001',
      MESSAGE = 'ERROR - SEE LOG';
  END IF;
  
  v_step := 20;

  IF NOT p_allow_unique THEN  
    v_index_definition := REPLACE(v_index_definition,'UNIQUE ','');
  END IF;

  v_step := 30;
  CALL proc_log(p_Module => v_module
               ,p_event => 'CALL PROC_BUILD_INDEX'
               ,p_desc => 'p_index_definition: ' || v_index_definition || ' p_ignore_if_exists: TRUE'
               ,p_rec_count => NULL);

  CALL proc_build_index(p_index_name => p_index_name 
                       ,p_index_definition => v_index_definition
                       ,p_ignore_if_exists => TRUE
                       );
       
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