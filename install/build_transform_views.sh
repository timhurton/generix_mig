# 
#  ***************************************************************************************************************  
#  *
#  * Date        Developer   Description
#  * ==========  ==========  ===========
#  * 13/03/2024  Tim Hurton  Initial Revision. Create infrastructure views required for the transformation.
#  * 
#  ***************************************************************************************************************  
#    
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_foreign_cons_source.sql -t > $stdout/vw_foreign_cons_source.lst 2> $error_log/vw_foreign_cons_source.err
cat $error_log/vw_foreign_cons_source.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_foreign_cons_ref.sql -t > $stdout/vw_foreign_cons_ref.lst 2> $error_log/vw_foreign_cons_ref.err
cat $error_log/vw_foreign_cons_ref.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_unique_constraints.sql -t > $stdout/vw_unique_constraints.lst 2> $error_log/vw_unique_constraints.err
cat $error_log/vw_unique_constraints.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_foreign_constraints.sql -t > $stdout/vw_foreign_constraints.lst 2> $error_log/vw_foreign_constraints.err
cat $error_log/vw_foreign_constraints.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_constraint_reports.sql -t > $stdout/vw_constraint_reports.lst 2> $error_log/vw_constraint_reports.err
cat $error_log/vw_constraint_reports.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_final_record_count.sql -t > $stdout/vw_final_record_count.lst 2> $error_log/vw_final_record_count.err
cat $error_log/vw_final_record_count.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_compare_indexes.sql -t > $stdout/vw_compare_indexes.lst 2> $error_log/vw_compare_indexes.err
cat $error_log/vw_compare_indexes.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_compare_constraints.sql -t > $stdout/vw_compare_constraints.lst 2> $error_log/vw_compare_constraints.err
cat $error_log/vw_compare_constraints.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_failed_reconciliation.sql -t > $stdout/vw_failed_reconciliation.lst 2> $error_log/vw_failed_reconciliation.err
cat $error_log/vw_failed_reconciliation.err
psql -d $db -h 10.5.2.4 -U $trfm_user -f $views/vw_elapsed_module_times.sql -t > $stdout/vw_elapsed_module_times.lst 2> $error_log/vw_elapsed_module_times.err
cat $error_log/vw_elapsed_module_times.err
