# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Create infrastructure tables required for the transformation.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $db -h 10.5.2.4 -U $trfm_user -f $tables/client_parameters.sql -t > $stdout/client_parameters.lst 2> $error_log/client_parameters.err
cat $error_log/client_parameters.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $tables/migration_reports.sql -t > $stdout/migration_reports.lst 2> $error_log/migration_reports.err
cat $error_log/migration_reports.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $tables/index_audit.sql -t > $stdout/index_audit.lst 2> $error_log/index_audit.err
cat $error_log/index_audit.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $tables/constraint_audit.sql -t > $stdout/constraint_audit.lst 2> $error_log/constraint_audit.err
cat $error_log/constraint_audit.err
