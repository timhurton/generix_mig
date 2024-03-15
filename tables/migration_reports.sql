/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create migration_reports table.
   * 
   ***************************************************************************************************************  
*/   
DROP TABLE IF EXISTS migration_reports CASCADE;
CREATE TABLE migration_reports(id             SERIAL      NOT NULL
                              ,audit_datetime TIMESTAMP   DEFAULT NOW() NOT NULL 
                              ,report_name    VARCHAR(80) NOT NULL 
                              ,record_cnt     INTEGER     NOT NULL 
                              ,success_flag   CHAR(1)     NOT NULL
                              );
ALTER TABLE migration_reports ADD CONSTRAINT pk_migration_reports PRIMARY KEY (id);                                 

