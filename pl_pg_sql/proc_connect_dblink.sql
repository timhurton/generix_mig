CREATE OR REPLACE PROCEDURE proc_connect_dblink(p_connection_name VARCHAR)
  LANGUAGE plpgsql AS $$
/* **********************************************************************************  
   *
   * Date        Developer  Description
   * ==========  =========  ===========
   * 15/02/2024  T. Hurton  Initial Revision. Connect to Utils DB is not already
   *                        connected.
   * 
   **********************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_CONNECT_DBLINK';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_result    VARCHAR(80);
  v_connected BOOLEAN;
  v_connection_str VARCHAR(200);
	v_host_name VARCHAR(20);
  v_username  VARCHAR(40);
  v_password  VARCHAR(40);
  v_dbname    VARCHAR(40);
BEGIN 
  -- Logging not required for this module, as a) might be called many times and
  -- b) may not be connected to the remote DB at this so wont work!
  v_step := 10;
  v_connected := COALESCE((SELECT p_connection_name = ANY (dblink_get_connections())),FALSE);

  IF NOT v_connected THEN
    v_step := 20;
    SELECT host_name
          ,username
	  	    ,user_password
	  	    ,dbname
	  INTO STRICT v_host_name
               ,v_username
               ,v_password
               ,v_dbname
	  FROM dblink_credentials
     WHERE connect_name = p_connection_name;

    v_step := 30;
    v_connection_str := 'host=' || v_host_name || ' user=' || v_username || ' password=' || v_password || ' dbname=' || v_dbname;
--     RAISE INFO 'Connection string %', v_connection_str;
	
    SELECT dblink_connect('UtilsConnection', v_connection_str)
	    INTO v_result;
      
--   ELSE
--     RAISE INFO 'Already connected!';
  END IF;
  
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