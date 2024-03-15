-- ****************************************************************
-- *
-- *  Logging utility from NeoWMS-side. Carrys out call to log on 
-- *  the remote database.
-- *
-- ****************************************************************
DROP PROCEDURE  IF EXISTS proc_log;
CREATE OR REPLACE PROCEDURE proc_log(p_module    VARCHAR
                                    ,p_event     VARCHAR 
                                    ,p_desc      VARCHAR DEFAULT NULL
                                    ,p_rec_count INTEGER DEFAULT NULL
                                    )
  LANGUAGE plpgsql AS $$
/* **********************************************************************************  
   *
   * Date        Developer  Description
   * ==========  =========  ===========
   * 15/02/2024  T. Hurton  Initial Revision. Loggine utility from neoWMS-side.
   *                        Passes values to an equivalnt procedure on Utils, which
   *                        can then autonomously commit the data.
   * 
   **********************************************************************************  
*/   
DECLARE   
  --
  -- BEGIN standard declarations
  --
  v_module transform_log.module_name%TYPE := 'PROC_LOG';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  --
  -- END standard declarations
  --
  v_sql    VARCHAR(1000);
  v_result VARCHAR(20);
  v_user   VARCHAR(80) := SESSION_USER;
BEGIN 
  v_sql := 'CALL public.proc_utils_transform_log(' ||
             'p_module => ''' || p_module || '''' ||
			 ',p_user => ''' || v_user || '''' || 
			 ',p_event => ''' || p_event || '''';

  IF p_desc IS NOT NULL THEN 
    v_sql := v_sql || ',p_desc => ''' || p_desc || '''';
  ELSE 
    v_sql := v_sql || ',p_desc => NULL::VARCHAR';
  END IF;

  IF p_rec_count IS NOT NULL THEN 
    v_sql := v_sql || ',p_rec_count => ' || p_rec_count::varchar || '';
  ELSE 
    v_sql := v_sql || ',p_rec_count => NULL::INT';
  END IF;

  v_sql := v_sql || ');';
  
--   RAISE NOTICE 'Sql %', v_sql;  -- Only required for debugging

  SELECT dblink_exec('UtilsConnection', v_sql)
    INTO v_result;

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