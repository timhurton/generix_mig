# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Create tables require on the utils DB.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $remote_db -h 10.5.2.4 -U $trfm_user -f $tables/error_log.sql -t > $stdout/error_log.lst 2> $error_log/error_log.err
cat $error_log/error_log.err
psql -d $remote_db -h 10.5.2.4 -U $trfm_user -f $tables/transform_log.sql -t > $stdout/transform_log.lst 2> $error_log/transform_log.err
cat $error_log/transform_log.err
