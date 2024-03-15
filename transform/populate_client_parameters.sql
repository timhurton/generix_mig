/* ***************************************************************************************************************  
   *
   * Not sure if this will be a stand alone script at the moment. 
   *
   ***************************************************************************************************************  
*/   
DELETE FROM client_parameters;
INSERT INTO client_parameters(source_schema  
                             ,target_schema  
                             ,transform_schema  
                             ,client 
                             )
VALUES('lidl_neowms'
      ,'wms'
      ,'dblidl'
      ,'LIDL');                                 

SELECT * FROM client_parameters;