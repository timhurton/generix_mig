psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f gen_rebuild_constraints.sql > $stdout/gen_rebuild_constraints.lst 2> $error_log/gen_rebuild_constraints.err
cat $error_log/gen_rebuild_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f rebuild_indexes.sql > $stdout/rebuild_indexes.lst 2> $error_log/rebuild_indexes.err
cat $error_log/rebuild_indexes.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f after_constraints_snapshot.sql > $stdout/after_constraints_snapshot.lst 2> $error_log/after_constraints_snapshot.err
cat $error_log/after_constraints_snapshot.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f after_indexes_snapshot.sql > $stdout/after_indexes_snapshot.lst 2> $error_log/after_indexes_snapshot.err
cat $error_log/after_indexes_snapshot.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f set_run_id.sql > $stdout/set_run_id.lst 2> $error_log/set_run_id.err
cat $error_log/set_run_id.err
# ***********************************************
# *
# * Start Reporting/Diagnostics
# *
# ***********************************************
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -c "copy (SELECT * FROM vw_failed_reconciliation) TO STDOUT WITH CSV DELIMITER ',' HEADER" > $reports/failed_reconciliation.csv 2> $error_log/failed_reconciliation.err
cat $error_log/failed_reconciliation.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -c "copy (SELECT * FROM vw_final_record_count) TO STDOUT WITH CSV DELIMITER ',' HEADER" > $reports/final_record_count.csv 2> $error_log/final_record_count.err
cat $error_log/final_record_count.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -c "copy (SELECT * FROM vw_compare_constraints) TO STDOUT WITH CSV DELIMITER ',' HEADER" > $reports/compare_constraints.csv 2> $error_log/compare_constraints.err
cat $error_log/compare_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -c "copy (SELECT * FROM vw_compare_indexes) TO STDOUT WITH CSV DELIMITER ',' HEADER" > $reports/compare_indexes.csv 2> $error_log/compare_indexes.err
cat $error_log/compare_indexes.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -c "copy (SELECT * FROM vw_elapsed_module_times) TO STDOUT WITH CSV DELIMITER ',' HEADER" > $reports/elapsed_module_times.csv 2> $error_log/elapsed_module_times.err
cat $error_log/elapsed_module_times.err
