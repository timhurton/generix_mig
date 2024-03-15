# make sure there are on unset run ids on the transform log from a previous run
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f set_run_id.sql > $stdout/first_time_set_run_id.lst 2> $error_log/first_time_set_run_id.err 
cat $error_log/first_time_set_run_id.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f clear_transform_tables.sql > $stdout/clear_transform_tables.lst 2> $error_log/clear_transform_tables.err 
cat $error_log/clear_transform_tables.err 
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f populate_client_parameters.sql -t > $stdout/populate_client_parameters.lst 2> $error_log/populate_client_parameters.err 
cat $error_log/populate_client_parameters.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f before_constraints_snapshot.sql -t > $stdout/before_constraints_snapshot.lst 2> $error_log/before_constraints_snapshot.err 
cat $error_log/before_constraints_snapshot.err 
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f before_indexes_snapshot.sql -t > $stdout/before_indexes_snapshot.lst 2> $error_log/before_indexes_snapshot.err 
cat $error_log/before_indexes_snapshot.err 
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f create_drop_constraints.sql -t -o gen_drop_constraints.sql 2> $error_log/create_drop_constraints.err  
cat $error_log/create_drop_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f create_drop_indexes.sql -t -o gen_drop_indexes.sql 2> $error_log/create_drop_indexes.err 
cat $error_log/create_drop_indexes.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f create_rebuild_constraints.sql -t -o gen_rebuild_constraints.sql 2> $error_log/create_rebuild_constraints.err 
cat $error_log/create_rebuild_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f gen_drop_constraints.sql -t > $stdout/gen_drop_constraints.lst 2> $error_log/gen_drop_constraints.err 
cat $error_log/gen_drop_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f gen_drop_indexes.sql -t > $stdout/gen_drop_indexes.lst 2> $error_log/gen_drop_indexes.err 
cat $error_log/gen_drop_indexes.err
# Commented out until we have something more substantial to run against
# psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f transform_master.sql -t > $stdout/transform_master.lst 2> $error_log/transform_master.err 
# cat $error_log/transform_master.err 
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f create_reports.sql -t -o gen_run_reports.sh 2> $error_log/create_reports.err 
cat $error_log/create_reports.err
chmod 777 gen_run_reports.sh
./gen_run_reports.sh > $stdout/gen_run_reports.lst 2> $error_log/gen_run_reports.err 
cat $error_log/gen_run_reports.err
