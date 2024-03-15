/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create script to drop constraints not wanted during transformation.
   * 
   ***************************************************************************************************************  
*/   
SELECT FORMAT('SELECT ''DROP %s''; ',conname) ||
       FORMAT('ALTER TABLE %s DROP CONSTRAINT %s;'
--              ,nsp.nspname
      ,pgc.conrelid::REGCLASS
      ,pgc.conname)
  FROM pg_catalog.pg_constraint pgc
  JOIN pg_namespace nsp ON (nsp.oid = pgc.connamespace)
  JOIN client_parameters cp ON (cp.target_schema = nsp.nspname)
 WHERE pgc.contype NOT IN  ('c','p')
ORDER BY pgc.contype;

