/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 12/03/2024  Tim Hurton  Initial Revision. Create the remote database to allow autonomous transactions.
   * 
   ***************************************************************************************************************  
*/   
CREATE DATABASE "utils"
    WITH
    OWNER = dblidl
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;