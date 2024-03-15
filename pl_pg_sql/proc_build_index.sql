CREATE OR REPLACE PROCEDURE proc_build_index(p_index_name       IN VARCHAR
                                            ,p_index_definition IN VARCHAR
                                            ,p_ignore_if_exists IN BOOLEAN DEFAULT TRUE) 
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 26/02/2024  Tim Hurton  Initial Revision. create an index based on the script passed in.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_BUILD_INDEX';
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
               ,p_event => 'START');
             
  v_step := 20;
  -- if "ignore if exists" parameter is set, only create if the index already exists
  IF p_ignore_if_exists THEN 
    v_index_definition := REPLACE(p_index_definition,'INDEX','INDEX IF NOT EXISTS');
  ELSE 
    v_index_definition := p_index_definition;
  END IF;

  IF POSITION(';' IN v_index_definition) = 0 THEN
    v_index_definition := v_index_definition || ';';
  END IF;

  CALL proc_log(p_module => v_module
               ,p_event => 'BULIDING INDEX: '|| p_index_name
               ,p_desc => v_index_definition
               ,p_rec_count => NULL);
  
  v_step := 30;
  EXECUTE v_index_definition;

  v_step := 40;
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