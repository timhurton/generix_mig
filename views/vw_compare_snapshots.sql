CREATE OR REPLACE VIEW vw_compare_constraints AS
SELECT *
  FROM (SELECT 'Missing ''Before'' transformation constraints' AS "Report Title"
              ,schema_name AS "Schema Name"
              ,constrained_table AS "Constrained Table"
              ,constraint_name AS "Constraint Name"
              ,constraint_type AS "Constraint Type"
              ,constrained_column AS "Constrained Column"
              ,referenced_table AS "Referenced Table"
              ,referenced_column AS "Referenced Column"
              ,constraint_definition AS "Constraint Definition"
          FROM constraint_audit ca 
         WHERE ca.audit_type = 'BEFORE'
        EXCEPT 
        SELECT 'Missing ''Before'' transformation constraints' AS "Report Title"
              ,schema_name
              ,constrained_table
              ,constraint_name
              ,constraint_type
              ,constrained_column
              ,referenced_table
              ,referenced_column
              ,constraint_definition
          FROM constraint_audit ca 
         WHERE ca.audit_type = 'AFTER') a
UNION
SELECT *
  FROM (SELECT 'Additional constraints found' AS "Report Title"
              ,schema_name
              ,constrained_table
              ,constraint_name
              ,constraint_type
              ,constrained_column
              ,referenced_table
              ,referenced_column
              ,constraint_definition
          FROM constraint_audit ca 
         WHERE ca.audit_type = 'AFTER'
        EXCEPT 
        SELECT 'Additional constraints found' AS "Report Title" 
              ,schema_name
              ,constrained_table
              ,constraint_name
              ,constraint_type
              ,constrained_column
              ,referenced_table
              ,referenced_column
              ,constraint_definition
          FROM constraint_audit ca 
         WHERE ca.audit_type = 'BEFORE') b
ORDER BY 1 DESC, 2,3,4,5,6;
DROP VIEW IF EXISTS vw_compare_indexes;
CREATE VIEW vw_compare_indexes AS
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
  FROM (SELECT 'Missing ''Before'' tranformation indexes' AS "Report Title" 
              ,schema_name
              ,table_name
              ,index_name
              ,unique_index
              ,index_definition
         FROM index_audit ia 
         WHERE ia.audit_type = 'AFTER'
        EXCEPT 
        SELECT 'Missing ''Before'' tranformation indexes' AS "Report Title" 
              ,schema_name
              ,table_name
              ,index_name
              ,unique_index
              ,index_definition
          FROM index_audit ia 
         WHERE ia.audit_type = 'BEFORE') d
ORDER BY 1 DESC, 2,3,4;
  
 
