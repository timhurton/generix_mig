/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 26/02/2024  Tim Hurton  Initial Revision. Take an after image of the constraints for later reconciliation. 
   * 
   ***************************************************************************************************************  
*/   
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
SELECT 'AFTER'
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
SELECT 'AFTER'
      ,now()
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
