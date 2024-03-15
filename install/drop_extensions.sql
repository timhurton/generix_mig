/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 11/03/2024  T. Hurton   Initial Revision. Drop all extensions. Should only be required for a re-install.
   * 
   ***************************************************************************************************************  


    CODE TO ALLOW FOR PASSWORDS STILL REQUIRED

*/   
-- ****************************************************************
-- *
-- *  Drop all existing verions of the required code.
-- *
-- ****************************************************************
DROP USER MAPPING IF EXISTS FOR dblidl SERVER utils_bridge;
DROP SERVER IF EXISTS utils_bridge CASCADE;
DROP EXTENSION IF EXISTS postgres_fdw CASCADE;
DROP FOREIGN TABLE IF EXISTS TRANSFORM_LOG CASCADE;
DROP EXTENSION IF EXISTS dblink CASCADE;
    
