/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 22/02/2024  Tim Hurton  Initial Revision. Create transform_log table. Note that this table exists on the
   *                         remote utils database.
   * 
   ***************************************************************************************************************  
*/   
DROP TABLE IF EXISTS public.transform_log CASCADE;

CREATE TABLE public.transform_log(id             SERIAL NOT NULL
                          ,module_name    VARCHAR(80) NOT NULL
                          ,username     VARCHAR(80) NOT NULL 
                          ,event_name     VARCHAR(80) NOT NULL 
                          ,description    VARCHAR(1000) NULL 
                          ,record_count   INTEGER NULL 
                          ,audit_datetime TIMESTAMP DEFAULT CLOCK_TIMESTAMP() NOT NULL 
                          ,run_id         INTEGER
                          );
                        
ALTER TABLE public.transform_log ADD CONSTRAINT pk_transform_log PRIMARY KEY (id);

CREATE INDEX ix_transform_log_run_id ON public.transform_log(run_id);                              
