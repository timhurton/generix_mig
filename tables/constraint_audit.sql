/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create constraint_audit table.
   * 
   ***************************************************************************************************************  
*/   
DROP TABLE IF EXISTS constraint_audit CASCADE;
CREATE TABLE constraint_audit (id SERIAL NOT NULL
                              ,audit_type VARCHAR(10) NOT NULL
                              ,audit_datetime TIMESTAMP NOT NULL
                              ,schema_name VARCHAR(80) NULL
                              ,constraint_name VARCHAR(80) NOT NULL
                              ,constraint_type VARCHAR(80) NOT NULL
                              ,constrained_table VARCHAR(80) NOT NULL
                              ,constrained_column VARCHAR(80) NOT NULL
                              ,con_col_ordinality INTEGER NOT NULL
                              ,referenced_table VARCHAR(80) NULL
                              ,referenced_column VARCHAR(80) NULL
                              ,ref_col_ordinality INTEGER NULL
                              ,constraint_definition TEXT NULL);
ALTER TABLE constraint_audit ADD CONSTRAINT pk_constraint_audit PRIMARY KEY (id);   