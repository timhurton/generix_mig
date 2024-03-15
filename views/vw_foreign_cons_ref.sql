DROP VIEW IF EXISTS vw_foreign_cons_ref CASCADE;
CREATE VIEW vw_foreign_cons_ref 
  AS SELECT * 
       FROM public.crosstab('SELECT constraint_name
                                   ,ref_col_ordinality
                                   ,referenced_column
                              FROM constraint_audit ca 
                             WHERE audit_type = ''BEFORE''
                               AND constraint_type = ''Foreign key''
                             ORDER BY constraint_name
                                     ,ref_col_ordinality
                                   ,referenced_column')
      AS ct (constraint_name   VARCHAR
            ,ref_column_1          VARCHAR
            ,ref_column_2          VARCHAR
            ,ref_column_3          VARCHAR
            ,ref_column_4          VARCHAR
            ,ref_column_5          VARCHAR);
