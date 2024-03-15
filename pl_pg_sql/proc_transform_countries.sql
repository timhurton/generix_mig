CREATE OR REPLACE PROCEDURE proc_transform_countries()
  LANGUAGE plpgsql AS $$
/* **********************************************************************************  
   *
   * Date        Developer  _description
   * ==========  =========  ===========
   * 20/02/2024  T. Hurton  Initial Revision. Transform countries.
   * 
   **********************************************************************************  
*/   
DECLARE 
  -- start standard declarations
  v_module transform_log.module_name%TYPE := 'TRANSFORM_COUNTRIES';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
  v_result  VARCHAR(20);
BEGIN 
  v_step := 10;
  CALL proc_log(p_module => v_module
               ,p_event => 'START');
             
  v_step := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezpay;

  v_step := 30;
  CALL proc_log(p_module => v_module
               ,p_event => 'RECORDCOUNT'
               ,p_desc => 'GEZPAY INPUT'
               ,p_rec_count => v_count);
  
  v_step := 40;
  INSERT INTO countries(country_name 
                       ,alpha2_code
--                     ,alpha3_code
                       )
  SELECT libpay
        ,codpay
    FROM gezpay;

  v_step := 50;
  SELECT COUNT(1)
    INTO v_count 
    FROM countries;

  v_step := 60;
  CALL proc_log(p_module => v_module
               ,p_event => 'RECORDCOUNT'
               ,p_desc => 'COUNTRIES OUTPUT'
               ,p_rec_count => v_count);

       
  v_step := 70;
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