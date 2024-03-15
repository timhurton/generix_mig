DROP VIEW IF EXISTS vw_foreign_cons_source CASCADE; 
CREATE VIEW vw_foreign_cons_source 
  AS SELECT * 
       FROM public.crosstab('SELECT constraint_name
                                   ,con_col_ordinality
                                   ,constrained_column
                              FROM constraint_audit ca 
                             WHERE audit_type = ''BEFORE''
                               AND constraint_type = ''Foreign key''
                             ORDER BY constraint_name
                                     ,con_col_ordinality
                                     ,constrained_column')
      AS ct (constraint_name   VARCHAR
            ,column_1          VARCHAR
            ,column_2          VARCHAR
            ,column_3          VARCHAR
            ,column_4          VARCHAR
            ,column_5          VARCHAR);