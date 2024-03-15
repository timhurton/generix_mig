# Not sure yet how we rae going to manage parameterising the schema name for different environments.
psql -d neowms -h 10.5.2.4 -p 5432 -U dblidl -f recreate.sql > $stdout/recreate.lst 2> $error_log/recreate.err 
cat $error_log/recreate.err
