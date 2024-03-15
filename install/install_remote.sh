# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Install the objects required to carry out a transformation.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/create_utils_db.sql > $stdout/create_utils_db.lst 2> $error_log/create_utils_db.err 
cat $error_log/create_utils_db.err
./build_utils_tables.sh > $stdout/build_utils_tables.lst 2> $error_log/build_utils_tables.err
cat $error_log/build_utils_tables.err
./build_utils_plpgsql.sh > $stdout/build_utils_plpgsql.lst 2> $error_log/build_utils_plpgsql.err
cat $error_log/build_utils_plpgsql.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/create_extensions.sql > $stdout/create_extensions.lst 2> $error_log/create_extensions.err 
cat $error_log/create_extensions.err
./build_transform_tables.sh > $stdout/build_transform_tables.lst 2> $error_log/build_transform_tables.err
cat $error_log/build_transform_tables.err
./build_transform_views.sh > $stdout/build_transform_views.lst 2> $error_log/build_transform_views.err
cat $error_log/build_transform_views.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f populate_client_parameters.sql > $stdout/populate_client_parameters.lst 2> $error_log/populate_client_parameters.err 
cat $error_log/populate_client_parameters.err
# workaround for storing db link credentials. This will need to change. note that as it is in the scr directory it will not be copied into GIT.
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $scr/table_dblink_credentials.sql > $stdout/table_dblink_credentials.lst 2> $error_log/table_dblink_credentials.err 
cat $error_log/table_dblink_credentials.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f build_source_views.sql > $stdout/build_source_views.lst 2> $error_log/build_source_views.err 
cat $error_log/build_source_views.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f build_target_views.sql > $stdout/build_target_views.lst 2> $error_log/build_target_views.err 
cat $error_log/build_target_views.err
