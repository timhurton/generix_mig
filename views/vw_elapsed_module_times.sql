CREATE OR REPLACE VIEW vw_elapsed_module_times AS 
SELECT s.run_id AS "Run Id"
      ,s.module_name AS "Module Name"
      ,s.audit_datetime AS "Start Time"
      ,e.audit_datetime - s.audit_datetime AS "Elapsed 'HH:MI:SS.DDDDDD'"
  FROM transform_log s
  JOIN transform_log e ON (s.module_name = e.module_name AND s.run_id = e.run_id AND e.event_name = 'END')
 WHERE s.event_name = 'START'
   AND s.module_name NOT IN ('BUILD_INDEX','REBUILD_INDEX','PROC_INSERT_PIVOT')
   AND s.run_id = (SELECT MAX(run_id) 
                     FROM transform_log)
   AND e.run_id = s.run_id                    
ORDER BY 4 DESC;
