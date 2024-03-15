DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 21/02/2024  Tim Hurton  Initial Revision. Take a before image of the indexes for later reconciliation. 
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'BEFORE_INDEXES_SNAPSHOT.SQL';
  --
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
BEGIN 

  -- Make sure we have the connection to the remote DB needed for logging and error handling.
  CALL proc_connect_dblink('UtilsConnection');

  v_step := 10;
  INSERT INTO index_audit (audit_type
                          ,audit_datetime
                          ,schema_name
                          ,index_name
                          ,unique_index
                          ,table_name
                          ,index_definition
                          )
  SELECT 'BEFORE'
        ,NOW()
        ,schemaname
        ,indexname
        ,CASE SUBSTR(indexdef,8,6)
           WHEN 'UNIQUE' THEN
             TRUE
           ELSE
             FALSE
         END
        ,tablename
        ,indexdef
    FROM pg_catalog.pg_indexes i
    JOIN client_parameters cp1 ON (cp1.target_schema = i.schemaname)
   WHERE indexname IN (SELECT indexname 
                        FROM pg_catalog.pg_indexes c
                        JOIN client_parameters cp ON (cp.target_schema = c.schemaname)
                       WHERE indexname NOT LIKE '%pkey'
                      EXCEPT -- Not interest in indexes created from unique constraints
                      SELECT pgc.conname
                        FROM pg_constraint pgc
                        JOIN pg_namespace nsp ON (nsp.oid = pgc.connamespace)
                        JOIN client_parameters cp ON (cp.target_schema = nsp.nspname)
                       WHERE pgc.contype ='u');
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