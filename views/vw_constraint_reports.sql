DROP VIEW IF EXISTS vw_constraint_reports;
CREATE VIEW vw_constraint_reports AS 
WITH unique_base AS (SELECT table_name
                           ,constraint_name
                           ,'SELECT ' || column_1 ||
                              CASE WHEN column_2 IS NOT NULL THEN ',' || column_2 ELSE '' END ||
                              CASE WHEN column_3 IS NOT NULL THEN ',' || column_3 ELSE '' END ||
                              CASE WHEN column_4 IS NOT NULL THEN ',' || column_4 ELSE '' END ||
                              CASE WHEN column_5 IS NOT NULL THEN ',' || column_5 ELSE '' END ||
                              ', count(1) FROM ' || table_name || ' group by ' || column_1 ||
                              CASE WHEN column_2 IS NOT NULL THEN ',' || column_2 ELSE '' END ||
                              CASE WHEN column_3 IS NOT NULL THEN ',' || column_3 ELSE '' END ||
                              CASE WHEN column_4 IS NOT NULL THEN ',' || column_4 ELSE '' END ||
                              CASE WHEN column_5 IS NOT NULL THEN ',' || column_5 ELSE '' END ||
                              ' HAVING COUNT(1) > 1' AS select_statement
                       FROM vw_unique_constraints)
    ,foreign_base AS (SELECT constrained_table AS table_name
                            ,constraint_name
                            ,'SELECT ' || column_1 ||
                               CASE WHEN column_2 IS NOT NULL THEN ',' || column_2 ELSE '' END ||
                               CASE WHEN column_3 IS NOT NULL THEN ',' || column_3 ELSE '' END ||
                               CASE WHEN column_4 IS NOT NULL THEN ',' || column_4 ELSE '' END ||
                               CASE WHEN column_5 IS NOT NULL THEN ',' || column_5 ELSE '' END ||
                               ' FROM ' || constrained_table || ' EXCEPT ' ||
                               'SELECT ' || ref_column_1 ||
                               CASE WHEN ref_column_2 IS NOT NULL THEN ',' || ref_column_2 ELSE '' END ||
                               CASE WHEN ref_column_3 IS NOT NULL THEN ',' || ref_column_3 ELSE '' END ||
                               CASE WHEN ref_column_4 IS NOT NULL THEN ',' || ref_column_4 ELSE '' END ||
                               CASE WHEN ref_column_5 IS NOT NULL THEN ',' || ref_column_5 ELSE '' END ||
                               ' FROM ' || referenced_table AS select_statement
                        FROM vw_foreign_constraints)
SELECT 'UNIQUE' AS constraint_type
      ,table_name
      ,constraint_name
      ,REPLACE(select_statement,'"','""') AS select_statement
      ,'UK_Dupicates_' || table_name || '_' || constraint_name  AS filename
      ,'INSERT INTO migration_reports (report_name, record_cnt, success_flag) SELECT ''UK_Dupicates_' || table_name || '_' || constraint_name || ''', rec_count, CASE rec_count WHEN 0 THEN ''Y'' ELSE ''N'' END FROM (SELECT COUNT(1) AS rec_count FROM (' || 
        select_statement || ') xxx )yyy;' AS insert_statement
  FROM unique_base
UNION
SELECT DISTINCT 'FOREIGN KEY' AS constraint_type
      ,table_name
      ,constraint_name
      ,REPLACE(select_statement,'"','""') AS select_statement
      ,'FK_Violations_' || table_name || '_' || constraint_name  AS filename
--      ,'FK_Violations_' || replace(table_name, '"NeoWMS".', '') || '_' || constraint_name  AS filename
      ,'INSERT INTO migration_reports (report_name, record_cnt, success_flag) SELECT ''UK_FK_Violations_' || table_name || '_' || constraint_name || ''', rec_count, CASE rec_count WHEN 0 THEN ''Y'' ELSE ''N'' END FROM (SELECT COUNT(1) AS rec_count FROM (' || 
        select_statement || ') xxx ) yyy;' AS insert_statement
  FROM foreign_base;