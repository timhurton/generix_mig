psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f neowms_tables.sql > $stdout/neowms_tables.lst 2> $error_log/neowms_tables.err 
cat $error_log/neowms_tables.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f $tools/build_target_views.sql > $stdout/build_target_views.lst 2> $error_log/build_target_views.err 
cat $error_log/build_target_views.err
