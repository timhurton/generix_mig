/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create error_log table.  Note that this table exists on the
   *                         remote utils database.
   * 
   ***************************************************************************************************************  
*/  
DROP TABLE IF EXISTS public.error_log;
CREATE TABLE public.error_log(id             SERIAL NOT NULL
                      ,username       VARCHAR(80) NOT NULL
                      ,module_name    VARCHAR(80) NOT NULL
                      ,error_state    VARCHAR(80) NOT NULL 
                      ,error_message  VARCHAR(1000) NULL 
                      ,error_detail   VARCHAR(1000) NULL 
                      ,error_datetime TIMESTAMP DEFAULT clock_timestamp() NOT NULL 
                      ,error_step     INTEGER NULL
                      );
ALTER TABLE public.error_log ADD CONSTRAINT pk_error_log PRIMARY KEY (id);