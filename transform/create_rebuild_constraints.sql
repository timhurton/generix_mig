/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Creates script to rebuild constraints after transformation. 
   * 
   ***************************************************************************************************************  
*/   
SELECT FORMAT('SELECT ''CREATE %s''; ', pgc.conname) ||
       FORMAT('ALTER TABLE %s ADD CONSTRAINT %s %s;'
--              ,nsp.nspname
              ,pgc.conrelid::REGCLASS
              ,pgc.conname
              ,pg_get_constraintdef(pgc.OID))
  FROM pg_catalog.pg_constraint pgc
  JOIN pg_namespace nsp ON (nsp.OID = pgc.connamespace)
  JOIN client_parameters cp ON (cp.target_schema = nsp.nspname) 
 WHERE pgc.contype NOT IN  ('c','p');
