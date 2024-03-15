CREATE OR REPLACE PROCEDURE proc_transform_zones()
  LANGUAGE plpgsql AS $$
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_TRANSFORM_ZONES';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
  v_result  VARCHAR(20);
BEGIN 
  v_step := 10;
  proc_log(pModule => vModule
          ,pEvent => 'START');
             
  v_step := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezzon;

  v_step := 30;
  proc_log(pModule => v_module
          ,pEvent => 'RECORDCOUNT'
          ,pDesc => 'GEZZON INPUT'
          ,pRecCount => v_count);
  
  -- We need to also add the zones that are only found in the aisles table.
  v_step := 32;
  SELECT COUNT(1)
    INTO v_count 
    FROM (SELECT zonsts FROM gezall
          EXCEPT  
          SELECT zonsts FROM gezzon) x;

  v_step := 34;
  proc_log(pModule => v_module
          ,pEvent => 'RECORDCOUNT'::varchar
          ,pDesc => 'GEZALL INPUT'::varchar
          ,pRecCount => v_count);
  
  v_step := 40;
  INSERT INTO zones(zone_code
                   ,facility_id)
  SELECT z.zonsts
        ,f.id
    FROM gezzon z
    JOIN facilities f ON (f.facility_name = z.codsit)
  UNION 
  SELECT zonsts
        ,facility_id
    FROM (SELECT a.zonsts
                ,f.id AS facility_id
            FROM gezall a
            JOIN "NeoWMS".facilities f ON (f.facility_name = a.codsit)
          EXCEPT  
          SELECT z.zonsts
                ,f.id
            FROM "WMS".gezzon z
            JOIN "NeoWMS".facilities f ON (f.facility_name = z.codsit)) x;

  v_step := 50;
  SELECT COUNT(1)
  INTO vCount 
  FROM "NeoWMS".zones;

  v_step := 60;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'ZONES OUTPUT'::varchar
                                ,pRecCount => vCount);

       
  v_step := 70;
  vResult := "Transform".transform_log(pModule => vModule
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