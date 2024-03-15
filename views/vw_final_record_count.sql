DROP VIEW IF EXISTS vw_final_record_count;
CREATE VIEW vw_final_record_count AS
SELECT run_id
      ,SUBSTR(description,1,LENGTH(description)-7) AS table_name
      ,record_count
  FROM transform_log
 WHERE event_name = 'RECORDCOUNT'
   AND description LIKE '%OUTPUT'
   AND run_id = (SELECT MAX(run_id) 
                   FROM transform_log)
ORDER BY 1;