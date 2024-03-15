/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 26/02/2024  Tim Hurton  Initial Revision. Take an after image of the indexes for later reconciliation. 
   * 
   ***************************************************************************************************************  
*/   
INSERT INTO index_audit (audit_type
                        ,audit_datetime
                        ,schema_name
                        ,index_name
                        ,unique_index
                        ,table_name
                        ,index_definition
                        )
SELECT 'AFTER'
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
                     WHERE c.indexname NOT LIKE '%pkey'
                    EXCEPT -- Not interest in indexes created from unique constraints
                    SELECT pgc.conname
                      FROM pg_constraint pgc
                      JOIN pg_namespace nsp ON (nsp.OID = pgc.connamespace)
                      JOIN client_parameters cp ON (cp.target_schema = nsp.nspname)
                     WHERE pgc.contype ='u');
