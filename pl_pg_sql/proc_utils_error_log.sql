CREATE OR REPLACE PROCEDURE public.proc_utils_error_log(p_module      VARCHAR
													   ,p_user        VARCHAR
													   ,p_error_state VARCHAR 
													   ,p_error_msg   VARCHAR DEFAULT NULL
													   ,p_error_dtl   VARCHAR DEFAULT NULL
													   ,p_step        INTEGER DEFAULT NULL
														)
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 12/02/2024  Tim Hurton  Initial Revision. Autonomous error logging procedure that resides on the utils DB.
   *                         Obviously cannot do error logging itself, just report it.
   * 
   ***************************************************************************************************************  
*/   
DECLARE  
  -- BEGIN standard declarations
  v_module public.transform_log.module_name%TYPE := 'PROC_UTILS_ERROR_LOG';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    integer DEFAULT -1;
  -- END standard declarations
BEGIN 
  v_step := 10;
  INSERT INTO public.error_log(module_name
							  ,username
                              ,error_state
                              ,error_message
                              ,error_detail
                              ,error_step
							  )
  VALUES (p_module
		 ,p_user       
		 ,p_error_state 
		 ,p_error_msg   
		 ,p_error_dtl   
		 ,p_step       
         );
EXCEPTION
  WHEN OTHERS THEN
    GET stacked DIAGNOSTICS
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
