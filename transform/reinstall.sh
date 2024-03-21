# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Remove all objects from the 'transform' remote schemas and
#  *                         re-install everything. 
#  * 
#  ***************************************************************************************************************  
#    
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/drop_extensions.sql > $stdout/drop_extensions.lst 2> $error_log/drop_extensions.err 
cat $error_log/drop_extensions.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/clear_schema.sql -v v_schema=$trfm_user > $stdout/clear_schema_$db.lst 2> $error_log/clear_schema_$db.err 
cat $error_log/clear_schema_$db.err
psql -d $remote_db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/clear_schema.sql -v v_schema=$trfm_user > $stdout/clear_schema_$remote_db.lst 2> $error_log/clear_schema_$remote_db.err 
cat $error_log/clear_schema_$remote_db.err
psql -d $db -h 10.5.2.4 -p 5432 -U $trfm_user -f $install/drop_utils_db.sql > $stdout/drop_utils_db.lst 2> $error_log/drop_utils_db.err 
cat $error_log/drop_utils_db.err
./install.sh > $stdout/install.lst 2> $error_log/install.err
cat $error_log/install.err
