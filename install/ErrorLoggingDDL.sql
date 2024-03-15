-- ****************************************************************
-- *
-- *  drop previous installations of the DB object
-- *
-- ****************************************************************

DROP TABLE IF EXISTS public.error_log;
DROP PROCEDURE IF EXISTS public.proc_utils_error_log; 
    
-- ****************************************************************
-- *
-- *  Needs to be created on the remote DB.
-- *
-- ****************************************************************

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




select * from public.error_log;
-- simple test
CALL public.proc_utils_error_log(pModule=>'ERROR1'::VARCHAR
								 ,pUser=>'TimH'::VARCHAR
								 ,pErrorState=>'22P02'::VARCHAR
								 ,pErrorMsg=>'invalid input syntax for type integer: "A"'::VARCHAR
								 ,pErrorDtl=>'Should have used a number'::VARCHAR
								 ,pStep=>20::INTEGER);