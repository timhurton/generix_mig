DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 21/02/2024  Tim Hurton  Initial Revision. Capture details of constraints for later reconciliation before they
   *                         are dropped.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'BEFORE_CONSTRAINTS_SNAPSHOT.SQL';  -- Keep this in uppercase
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
  INSERT INTO constraint_audit (audit_type
                               ,audit_datetime
                               ,schema_name
                               ,constraint_name
                               ,constraint_type
                               ,constrained_table
                               ,constrained_column
                               ,con_col_ordinality
                               ,referenced_table
                               ,referenced_column
                               ,ref_col_ordinality
                               ,constraint_definition)
  SELECT 'BEFORE'
        ,NOW()
        ,con.schema_name
        ,con.conname constraint_name
        ,'Foreign key'
        ,con.constrained_table
        ,ca.attname constrained_column
        ,con.ConOrdinality con_col_ordinality
        ,con.referenced_table
        ,ra.attname referenced_column
        ,con.RefOrdinality ref_col_ordinality
        ,con.constraint_definition
  -- Next columns left for debugging      
  --      ,con.ConColId
  --      ,con.conrelid
  --      ,con.RefColId
    FROM (SELECT ct.conname
                ,ct.conrelid::REGCLASS AS constrained_table
                ,ConColId
                ,ConOrdinality
                ,ct.conrelid
                ,ct.confrelid::REGCLASS AS referenced_table
                ,ct.confrelid
                ,RefColId
                ,RefOrdinality
                ,pg_get_constraintdef(ct.OID) constraint_definition
                ,ct.schema_name
           FROM (SELECT pgc.*
                       ,nsp.nspname schema_name
                   FROM pg_constraint pgc
                   JOIN pg_namespace nsp ON (nsp.OID = pgc.connamespace)
                   JOIN client_parameters cp ON (cp.target_schema = nsp.nspname)
                  WHERE pgc.contype ='f') ct
               ,UNNEST(ct.conkey) WITH ORDINALITY AS c(ConColId, ConOrdinality)
               ,UNNEST(ct.confkey) WITH ORDINALITY AS r(RefColId, RefOrdinality)) con
    LEFT OUTER JOIN pg_attribute ca ON (con.ConColId = ca.attnum
                            AND con.conrelid = ca.attrelid) -- constrained attributes
    LEFT OUTER JOIN pg_attribute ra ON (con.RefColId = ra.attnum
                            AND con.confrelid = ra.attrelid) -- referenced ATTRIBUTES                          
   WHERE con.RefOrdinality = con.ConOrdinality
  UNION
  SELECT 'BEFORE'
        ,NOW()
        ,con.nspname schema_name
        ,con.conname AS constraint_name 
        ,'Unique' constraint_type
        ,con.conrelid::REGCLASS constrained_table -- regclass turns an oid INTO the OBJECT name
        ,a.attname AS constrained_column
        ,con.ConOrdinality ref_col_ordinality
        ,NULL referenced_table
        ,NULL referenced_column
        ,NULL ref_col_ordinality
        ,pg_get_constraintdef(con.OID) constraint_definition
    FROM (SELECT ct.*
                ,c.ConColId
                ,c.ConOrdinality
            FROM (SELECT pgc.*
                         ,nsp.nspname
                     FROM pg_constraint pgc
                     JOIN pg_namespace nsp ON (nsp.OID = pgc.connamespace)
                     JOIN client_parameters cp ON (cp.target_schema = nsp.nspname)
                    WHERE pgc.contype ='u') ct
                 ,UNNEST(ct.conkey) WITH ORDINALITY AS c(ConColId, ConOrdinality)) con
    JOIN pg_attribute a ON (a.attnum = con.ConColId AND a.attrelid = con.conrelid);
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