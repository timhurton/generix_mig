DROP VIEW IF EXISTS vw_unique_constraints CASCADE;
CREATE VIEW vw_unique_constraints AS
SELECT ca.table_name
      ,ct.constraint_name   
      ,ct.column_1          
      ,ct.column_2          
      ,ct.column_3          
      ,ct.column_4          
      ,ct.column_5          
       FROM public.crosstab('SELECT constraint_name
                                   ,con_col_ordinality
                                   ,constrained_column
                              FROM constraint_audit ca 
                             WHERE audit_type = ''BEFORE''
                               AND constraint_type = ''Unique''
                             ORDER BY constraint_name
                                     ,con_col_ordinality
                                     ,constrained_column')
          AS ct (constraint_name   VARCHAR
                ,column_1          VARCHAR
                ,column_2          VARCHAR
                ,column_3          VARCHAR
                ,column_4          VARCHAR
                ,column_5          VARCHAR)
      ,(SELECT DISTINCT constraint_name
                       ,SUBSTR(constrained_table,POSITION('.' IN constrained_table)+1) AS table_name
          FROM constraint_audit
         WHERE audit_type = 'BEFORE'
           AND constraint_type = 'Unique') ca
 WHERE ca.constraint_name = ct.constraint_name;           
