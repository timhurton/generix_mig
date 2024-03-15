/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create client_parameters table.
   * 
   ***************************************************************************************************************  
*/   
DROP TABLE IF EXISTS client_parameters CASCADE;
CREATE TABLE client_parameters(id                SERIAL      NOT NULL
                              ,source_schema     VARCHAR(40) NOT NULL  
                              ,target_schema     VARCHAR(40) NOT NULL  
                              ,transform_schema  VARCHAR(40) NOT NULL  
                              ,client            VARCHAR(40) NOT NULL 
                              );
ALTER TABLE client_parameters ADD CONSTRAINT pk_client_parameters PRIMARY KEY (id);                                 

