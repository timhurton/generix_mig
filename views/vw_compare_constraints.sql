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
