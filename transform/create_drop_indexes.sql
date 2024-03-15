/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim hurton  Initial Revision. Create script to drop indexes not wanted during transformation.
   * 
   ***************************************************************************************************************  
*/   
SELECT FORMAT('SELECT ''DROP INDEX %s''; ',indexname) ||
       FORMAT('DROP INDEX "%s".%s;',schemaname,indexname)  
  FROM pg_catalog.pg_indexes
  JOIN client_parameters cp ON (cp.target_schema = schemaname)
 WHERE indexname IN (SELECT indexname 
                      FROM pg_catalog.pg_indexes
                     WHERE schemaname = cp.target_schema
                       AND indexname NOT LIKE '%pkey'
                    EXCEPT -- Not interest in indexes created from unique constraints
                    SELECT pgc.conname
                      FROM pg_constraint pgc
                      JOIN pg_namespace nsp ON (nsp.oid = pgc.connamespace)
                     WHERE pgc.contype ='u'
                       AND nsp.nspname = cp.target_schema);
