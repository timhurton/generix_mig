# These variables should not change between migrations to different clients
tools=/home/$USER/git/generix_mig/tools
transform=/home/$USER/git/generix_mig/transform
pl_pg_sql=/home/$USER/git/generix_mig/pl_pg_sql
tables=/home/$USER/git/generix_mig/tables
views=/home/$USER/git/generix_mig/views
install=/home/$USER/git/generix_mig/install
scr=/home/$USER/git/generix_mig/scr
redundant=/home/$USER/git/generix_mig/redundant
reports=/home/$USER/git/generix_mig/output/reports
stdout=/home/$USER/git/generix_mig/output/stdout
error_log=/home/$USER/git/generix_mig/output/error_log
export transform
export pl_pg_sql
export tables
export views
export tools
export reports
export stdout
export error_log
export install
export scr
export redundant
# These vairables might be client specific
db="neowms"
remote_db="utils"
trfm_user="dblidl"
export db
export remote_db
export trfm_user
