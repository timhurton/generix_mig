DROP VIEW IF EXISTS vw_failed_reconciliation;
CREATE VIEW vw_failed_reconciliation AS
SELECT i.run_id
      ,i.module_name
      ,i.input_count
      ,o.output_count
  FROM (SELECT module_name 
              ,run_id
              ,SUM(record_count) AS input_count
          FROM transform_log 
         WHERE event_name = 'RECORDCOUNT' 
           AND description LIKE '%INPUT'
           AND run_id = (SELECT MAX(run_id) FROM transform_log)
        GROUP BY module_name, run_id) i
  LEFT OUTER JOIN (SELECT module_name 
                        ,run_id
                         ,SUM(record_count) AS output_count
                     FROM transform_log 
                    WHERE event_name = 'RECORDCOUNT' 
                      AND description LIKE '%OUTPUT'
                   GROUP BY module_name, run_id) o
                   ON (i.module_name = o.module_name AND i.run_id = o.run_id)
 WHERE i.input_count <> COALESCE(o.output_count,0)
ORDER BY i.module_name; 