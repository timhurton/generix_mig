/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 06/03/2024  T. Hurton   Initial Revision. Create the extensions required for installtion, namely to connect
   *                         remote databases, allow foreign data wrappers (to access objects on remote DB) and
   *                         allow pivot operations.   
   * 
   ***************************************************************************************************************  


    CODE TO ALLOW FOR PASSWORDS STILL REQUIRED

*/   
-- ****************************************************************
-- *
-- *  Drop all existing verions of the required code.
-- *
-- ****************************************************************
DROP FOREIGN TABLE IF EXISTS TRANSFORM_LOG;
DROP USER MAPPING IF EXISTS FOR dblidl SERVER utils_bridge;
DROP SERVER IF EXISTS utils_bridge;
DROP EXTENSION IF EXISTS postgres_fdw;
DROP EXTENSION IF EXISTS dblink;
    
-- ****************************************************************
-- *
-- *  We need DB links to allow us to call a function/procedure on the remote db
-- *
-- ****************************************************************
    
CREATE EXTENSION dblink;
SELECT dblink_connect('UtilsConnection', 'host=10.5.2.4 user=dblidl password=fqpB3iUxYf9Q!6ZEhQPVSYp dbname=utils');


-- ****************************************************************
-- *
-- *  Creates the postgres_fdw (foreign data wrapper)
-- *
-- ****************************************************************
CREATE EXTENSION postgres_fdw;

CREATE SERVER utils_bridge
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host '10.5.2.4', port '5432', dbname 'utils');

CREATE USER MAPPING FOR dblidl
SERVER utils_bridge
OPTIONS (USER 'dblidl', PASSWORD 'fqpB3iUxYf9Q!6ZEhQPVSYp');

IMPORT FOREIGN SCHEMA public LIMIT TO (transform_log,error_log)
FROM SERVER utils_bridge INTO dblidl;