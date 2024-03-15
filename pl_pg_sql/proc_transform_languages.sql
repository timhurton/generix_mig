CREATE OR REPLACE PROCEDURE proc_transform_languages()
  LANGUAGE plpgsql AS $$
/* **********************************************************************************  
   *
   * Date        Developer  Description
   * ==========  =========  ===========
   * 20/02/2024  T. Hurton  Initial Revision. Transform lagnuages.
   * 
   **********************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_TRANSFORM_LANGUAGES';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
  v_result  VARCHAR(20);
BEGIN 

  CALL proc_connect_dblink('UtilsConnection');

  v_step := 10;
  call proc_log(p_module => v_module
               ,p_event => 'START');
             
  v_step := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezlge;

  v_step := 30;
  call proc_log(p_module => v_module
               ,p_event => 'RECORDCOUNT'
               ,p_desc => 'GEZLGE INPUT'
               ,p_rec_count => v_count);
  
  v_step := 40;
  INSERT INTO languages(language_code
                       ,language_name)
  SELECT codlge
        ,liblge
    FROM gezlge;

  v_step := 50;
  SELECT COUNT(1)
    INTO v_count 
    FROM languages;

  v_step := 60;
  call proc_log(p_module => v_module
			   ,p_event => 'RECORDCOUNT'
			   ,p_desc => 'LANGUAGES OUTPUT'
			   ,p_rec_count => v_count);

  v_step := 70;
  call proc_log(p_module => v_module
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