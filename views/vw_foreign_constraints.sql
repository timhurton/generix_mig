DROP VIEW IF EXISTS vw_foreign_constraints;
CREATE VIEW vw_foreign_constraints AS 
SELECT s.constraint_name
      ,ca.constrained_table
      ,ca.referenced_table
      ,s.column_1
      ,s.column_2
      ,s.column_3
      ,s.column_4
      ,s.column_5
      ,r.ref_column_1
      ,r.ref_column_2
      ,r.ref_column_3
      ,r.ref_column_4
      ,r.ref_column_5
  FROM vw_foreign_cons_source s
  JOIN vw_foreign_cons_ref r ON (r.constraint_name = s.constraint_name)
  JOIN (SELECT DISTINCT constraint_name
                       ,SUBSTR(constrained_table,POSITION('.' IN constrained_table)+1) AS constrained_table
                       ,SUBSTR(referenced_table,POSITION('.' IN referenced_table)+1) AS referenced_table
          FROM constraint_audit ca 
         WHERE audit_type = 'BEFORE'
           AND constraint_type = 'Foreign key') ca ON (ca.constraint_name = s.constraint_name);
