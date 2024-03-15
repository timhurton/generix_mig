CREATE OR REPLACE PROCEDURE proc_transform_facilities()
  LANGUAGE plpgsql AS $$
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_TRANSFORM_FACILITIES';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
  v_result  VARCHAR(20);
BEGIN 
  vStep := 10;
  proc_log(pModule => v_module
          ,pEvent => 'START');
             
  vStep := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezsit;

  vStep := 30;
  proc_log(pModule => v_module
          ,pEvent => 'RECORDCOUNT'
          ,pDesc => 'GEZSIT INPUT'
          ,pRecCount => v_count);
  
  vStep := 40;
  -- As thiis is LIDL Spain we can default in the country and language
  INSERT INTO "NeoWMS".facilities(facility_name 
                                 ,facility_description
                                 ,facility_type_id
                                 ,language_id
                                 ,address1 
                                 ,address2 
                                 ,city 
                                 ,country_id
                                 ,postal_code
                                 )
  SELECT f.codsit
        ,f.libsit
        ,ft.id AS facility_type_id
        ,l.id AS language_id 
        ,ad1sit
        ,ad2sit
        ,vilsit
        ,c.id AS country_id
        ,cposit
    FROM "WMS".gezsit f
    JOIN "NeoWMS".facility_types ft ON (ft.facility_type_name = f.typsit)
    JOIN "NeoWMS".countries c ON (c.alpha2_code = COALESCE(f.paysit,'ES'))
    JOIN "NeoWMS".languages l ON (l.language_code = 'ES');

  vStep := 5;
  SELECT COUNT(1)
  INTO v_count 
  FROM "NeoWMS".facilities;

  vStep := 6;
  vResult := "Transform".transform_log(pModule => v_module
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'FACILITIES OUTPUT'::varchar
                                ,pRecCount => v_count);

       
  vStep := 7;
  vResult := "Transform".transform_log(pModule => v_module
                                ,pEvent => 'END'::varchar);
  RETURN 'SUCCESS';
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