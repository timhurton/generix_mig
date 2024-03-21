CREATE OR REPLACE PROCEDURE public.proc_utils_transform_log(p_module    VARCHAR
                               ,p_user      VARCHAR
                               ,p_event     VARCHAR 
                               ,p_desc      VARCHAR DEFAULT NULL
                               ,p_rec_count INTEGER DEFAULT NULL
                               )
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 12/03/2024  Tim Hurton  Initial Revision. Write to the transform_log table. This is installed on the utils
   *                         DB to allow them to be added as autonomous transactions.
   * 
   ***************************************************************************************************************  
*/   
DECLARE  
  -- BEGIN standard declarations
  v_module public.transform_log.module_name%TYPE := 'PROC_UTILS_TRANSFORM_LOG';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
BEGIN 
  INSERT INTO public.transform_log(module_name
                  ,username
                  ,event_name
                  ,description
                  ,record_count
                  )
  VALUES (p_module
         ,p_user
         ,p_event    
         ,p_desc    
         ,p_rec_count
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
$$