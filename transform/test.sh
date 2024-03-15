psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f gen_rebuild_constraints.sql > $stdout/gen_rebuild_constraints.lst 2> $error_log/gen_rebuild_constraints.err
cat $error_log/gen_rebuild_constraints.err
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f rebuild_indexes.sql > $stdout/rebuild_indexes.lst 2> $error_log/rebuild_indexes.err
cat $error_log/rebuild_indexes.err
