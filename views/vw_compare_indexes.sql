CREATE OR REPLACE VIEW vw_compare_indexes AS
SELECT *
  FROM (SELECT 'Additional indexes found' AS "Report Title" 
              ,schema_name AS "Schema Name"
              ,table_name AS "Table Name"
              ,index_name AS "Index Name"
              ,unique_index AS "Unique Index?"
               ,index_definition AS "Index Definition"
         FROM index_audit ia 
         WHERE ia.audit_type = 'BEFORE'
        EXCEPT 
        SELECT 'Additional indexes found' AS "Report Title" 
              ,schema_name
              ,table_name
              ,index_name
              ,unique_index
              ,index_definition
          FROM index_audit ia 
         WHERE ia.audit_type = 'AFTER') c
UNION
SELECT *
  FROM (SELECT 'Missing ''Before'' transformation indexes' AS "Report Title" 
              ,schema_name
              ,table_name
              ,index_name
              ,unique_index
              ,index_definition
          FROM index_audit ia 
         WHERE ia.audit_type = 'AFTER'
        EXCEPT 
        SELECT 'Missing ''Before'' transformation indexes' AS "Report Title" 
              ,schema_name
              ,table_name
              ,index_name
              ,unique_index
              ,index_definition
          FROM index_audit ia 
         WHERE ia.audit_type = 'BEFORE') d
ORDER BY 1 DESC, 2,3,4;
  
 
