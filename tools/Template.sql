--
-- *************************************************************************
-- *
-- * Template for creating procedures and functions. Wherever possible 
-- * guidelines have been included as comments
-- *
-- * Replace module name with the object name.  Functions should be prefixed func_ 
-- * and procedures proc_ with the general format being func_transform_aisles
-- * for example, i.e., we use underscores to separate words. The script name
-- * should be the same format as the object, e.g. func_transform_aisles.sql
-- *
-- * Variables should use the following prefixes:
-- *   v_local_variable_name
-- *   p_parameter_name
-- *   c_cursor_name
-- *   r_record_name with the same name (apart from the prefix) as the cursor
-- *     it is assoicated with, if applicable.
-- *
-- * All variable names should be in lower case and all reserved words should 
-- * be in uppercase.
-- *
-- * Any calls to other objects should use named parameters, not positional
-- * i.e.,   proc_log(p_module => v_module
--                   ,p_event => 'START'::varchar);
-- * Not proc_log(v_module,'START');
-- * Note that a call is easier to read if you put on parameter on each line.
-- * This approach makes the code easier to read and the named parameters
-- * reduces the chance of causaing errors in a call.
-- *
-- * Reference to objects in your code should not include the schema name, as
-- * this will change depending on client and user runnin the job, so use
-- * proc_transform_aisles not "Transform".proc_transform_aisles.
-- *
-- * Current parameters required for call to proc_log
-- * p_module   - Mandatory. The name of the current module.
-- * p_event    - Mandatory. A description of the event taking place.
-- * p_desc     - Optional.  Free format text. Add anything that you think might 
-- *                        be useful. If this is a call for the START event
-- *                        any parameters the routines has been called with
-- *                        should be detailed here.
-- * p_rec_count - Optional.  Specifically for recording the expected and actual
-- *                        records on the target table. Do not use for any 
-- *                        others purposes as this will mess up the automatic
-- *                        reporting.
-- *
-- *************************************************************************
-- Remove this line if this is a function
CREATE OR REPLACE PROCEDURE module_name(p_any_parameter,...)
-- Remove these two lines if this is a procedure.
CREATE OR REPLACE FUNCTION module_name(p_any_parameter,...)
  RETURNS VARCHAR
-- The code is standard from hereon.
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 99/99/9999  yourname    Initial Revision. A brief description of what the module does.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'MODULE_NAME';  -- Keep this in uppercase
  -- Note the use if %TYPE. This means we don not need to hard-code a data type.
  -- If we need to change a data type, perhaps it has got longer, we do not need
  -- to change the code everywhere where it is used. Instead we just re-compile
  -- all procedures and functions and it will automatically pick up the change.
  --
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
  v_result  VARCHAR(20);
BEGIN 

  -- Make sure we have the connection to the remote DB needed for logging and error handling.
  CALL proc_connect_dblink('UtilsConnection');

  v_step := 10;
  proc_log(p_module => v_module
          ,p_event => 'START');
             
  v_step := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezall;

  v_step := 30;
  proc_log(p_module => v_module
          ,p_event => 'RECORDCOUNT'
          ,p_desc => 'GEZALL INPUT'
          ,p_rec_count => v_count);
  
  -- We need to also add the zones that are only found in the aisles table.
  v_step := 32;
  SELECT COUNT(1)
    INTO v_count 
    FROM (SELECT zonsts,allsts FROM gests
          EXCEPT  
          SELECT zonsts,allsts FROM gezall) x;

  v_step := 34;
  proc_log(p_module => v_module
                                ,p_event => 'RECORDCOUNT'
                                ,p_desc => 'GESTS INPUT'
                                ,p_rec_count => v_count);
  
  v_step := 40;
  -- Always state column names. If a column is added then your script wont fail. 
  INSERT INTO aisles(aisle_code
                    ,facility_id
                    ,zone_id)
  SELECT a.allsts
        ,f.id
        ,z.id
    FROM gezall a
    LEFT OUTER JOIN facilities f ON (a.codsit = f.facility_name)
    JOIN zones z ON (z.zone_code = a.zonsts)
  UNION 
  SELECT allsts
        ,NULL AS facility_id
        ,zone_id
    FROM (SELECT s.allsts
                ,z.id AS zone_id
            FROM gests s
            JOIN zones z ON (z.zone_code = s.zonsts)
          EXCEPT
          SELECT a.allsts
                ,z.id AS zone_id
            FROM gezall a
            LEFT OUTER JOIN facilities f ON (a.codsit = f.facility_name)
            JOIN zones z ON (z.zone_code = a.zonsts)
          ) x;

  v_step := 50;
  SELECT COUNT(1)
    INTO v_count 
    FROM aisles;

  v_step := 60;
  proc_log(p_module => v_module
          ,p_event => 'RECORDCOUNT'
          ,p_desc => 'AISLES OUTPUT'
          ,p_rec_count => v_count);

       
  v_step := 70;
  v_result := fnc_rebuild_index(p_index_name => 'ix_aisle_code'
                               ,p_allow_unique => FALSE);

  v_step := 80;
  proc_log(p_module => v_module
          ,p_event => 'END');
        
EXCEPTION
  -- START standard error logging
  WHEN OTHERS THEN
    GET stacked DIAGNOSTICS
      v_state := returned_sqlstate
     ,v_msg := message_text
     ,v_detail := pg_exception_detail;
    CALL proc_error(p_module      => v_module
                   ,p_error_state => v_state
                   ,p_error_msg   => v_msg
                   ,p_error_dtl   => v_detail
                   ,p_step        => v_step
                   );
    RAISE;
  -- END standard error logging
END;
$$