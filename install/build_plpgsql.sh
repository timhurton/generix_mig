# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Create the procedure required for the transformation.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_connect_dblink.sql -t > $stdout/proc_connect_dblink.lst 2> $error_log/proc_connect_dblink.err
cat $error_log/proc_connect_dblink.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_error.sql -t > $stdout/proc_error.lst 2> $error_log/proc_error.err
cat $error_log/proc_error.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_log.sql -t > $stdout/proc_log.lst 2> $error_log/proc_log.err
cat $error_log/proc_log.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_build_index.sql -t > $stdout/proc_build_index.lst 2> $error_log/proc_build_index.err
cat $error_log/proc_build_index.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_rebuild_index.sql -t > $stdout/proc_rebuild_index.lst 2> $error_log/proc_rebuild_index.err
cat $error_log/proc_rebuild_index.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_transform_facility.sql -t > $stdout/proc_transform_facility.lst 2> $error_log/proc_transform_facility.err
cat $error_log/proc_transform_facility.err
