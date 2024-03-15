# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Create procedures required on utils DB.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $remote_db -h 10.5.2.4 -U $trfm_user -f $pl_pg_sql/proc_utils_error_log.sql -t > $stdout/proc_utils_error_log.lst 2> $error_log/proc_utils_error_log.err
cat $error_log/proc_utils_error_log.err
