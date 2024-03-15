CREATE OR REPLACE PROCEDURE proc_transform_aisles()
  LANGUAGE plpgsql AS $$
DECLARE 
  -- BEGIN standard declarations
  vModule transform_log.module_name%TYPE := 'TRANSFORM_AISLES';
  -- Standard error handling variables
  vState   TEXT;
  vMsg     TEXT;
  vDetail  TEXT;
  vHint    TEXT;
  vContext TEXT;
  vStep    integer DEFAULT -1;
  -- END standard declarations
  vCount  integer;
  vResult varchar(20);
BEGIN 
  vStep := 10;
  vResult := transform_log(pModule => vModule
                                ,pEvent => 'START'::varchar);
             
  vStep := 20;
  SELECT COUNT(1)
    INTO vCount 
    FROM "WMS".gezall;

  vStep := 30;
  vResult := transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'GEZALL INPUT'::varchar
                                ,pRecCount => vCount);
  
  -- We need to also add the zones that are only found in the aisles table.
  vStep := 32;
  SELECT COUNT(1)
    INTO vCount 
    FROM (SELECT zonsts,allsts FROM "WMS".gests
          EXCEPT  
          SELECT zonsts,allsts FROM "WMS".gezall) x;

  vStep := 34;
  vResult := transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'GESTS INPUT'::varchar
                                ,pRecCount => vCount);
  
  vStep := 40;
  -- Will almost certainly need to be re-assessed where we know more about facilitty id 
  INSERT INTO "NeoWMS".aisles(aisle_code
                             ,facility_id
                             ,zone_id)
  SELECT a.allsts
        ,f.id
        ,z.id
    FROM "WMS".gezall a
    LEFT OUTER JOIN "NeoWMS".facilities f ON (a.codsit = f.facility_name)
    JOIN "NeoWMS".zones z ON (z.zone_code = a.zonsts)
  UNION 
  SELECT allsts
        ,NULL AS facility_id
        ,zone_id
    FROM (SELECT s.allsts
                ,z.id AS zone_id
            FROM "WMS".gests s
            JOIN "NeoWMS".zones z ON (z.zone_code = s.zonsts)
          EXCEPT
          SELECT a.allsts
                ,z.id AS zone_id
            FROM "WMS".gezall a
            LEFT OUTER JOIN "NeoWMS".facilities f ON (a.codsit = f.facility_name)
            JOIN "NeoWMS".zones z ON (z.zone_code = a.zonsts)
          ) x;

  vStep := 50;
  SELECT COUNT(1)
  INTO vCount 
  FROM "NeoWMS".aisles;

  vStep := 60;
  vResult := proc_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'AISLES OUTPUT'::varchar
                                ,pRecCount => vCount);

       
  vStep := 70;
  vResult := rebuild_index(pIndexName => 'ix_aisle_code'
                                ,pAllowUnique => FALSE);

  vStep := 80;
  vResult := proc_log(pModule => vModule
                                ,pEvent => 'END'::varchar);
EXCEPTION
-- Begin standard error handling
  WHEN OTHERS THEN
    GET stacked DIAGNOSTICS
      vState := returned_sqlstate
     ,vMsg := message_text
     ,vDetail := pg_exception_detail
     ,vHint := pg_exception_hint
     ,vContext := pg_exception_context;
    RAISE NOTICE E' Module % encountered exception at % state: %
                        message: %
                        detail: %
                        hint: %
                        context: %
                        step: %'
               ,vModule
               ,now()
               ,vState
               ,vMsg
               ,vDetail
               ,vHint
               ,vContext
               ,vStep;
-- End standard error handling
END;
$$;