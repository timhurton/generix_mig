/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create index_audit table.
   * 
   ***************************************************************************************************************  
*/   
DROP TABLE IF EXISTS index_audit CASCADE;
CREATE TABLE index_audit (id SERIAL NOT NULL
                         ,audit_type VARCHAR(10) NOT NULL
                         ,audit_datetime TIMESTAMP NOT NULL
                         ,schema_name VARCHAR(80) NOT NULL
                         ,index_name VARCHAR(80) NOT NULL  
                         ,unique_index BOOLEAN  NOT NULL DEFAULT FALSE
                         ,table_name VARCHAR(80) NOT NULL 
                         ,index_definition VARCHAR(200) NOT NULL);
ALTER TABLE index_audit ADD CONSTRAINT pk_index_audit PRIMARY KEY (id);                            
