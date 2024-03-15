CREATE OR REPLACE FUNCTION "Transform".load_reference_data() RETURNS varchar
  LANGUAGE plpgsql AS $$
DECLARE 
  -- BEGIN standard declarations
  vModule "Transform".transform_log.module_name%TYPE := 'LOAD_REFERENCE_DATA';
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
  --
  -- ***************************************************************************
  -- *
  -- * For hard-coded values only
  -- *
  -- ***************************************************************************
  vStep := 10;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'START'::varchar);
             
  vStep := 20;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNIT_SYSTEMS INPUT'::varchar
                                ,pRecCount => 3);
  
-- Measuring unit values all hard-coded for the time being.
  INSERT INTO "NeoWMS".measuring_unit_systems (measuring_unit_system_name)
    VALUES ('Imperial')
          ,('Decimal')
          ,('Other'); 
  
  vStep := 30;
  SELECT COUNT(1)
  INTO vCount 
  FROM "NeoWMS".measuring_unit_systems;

  vStep := 40;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNIT_SYSTEMS OUTPUT'::varchar
                                ,pRecCount => vCount);

  vStep := 50;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNIT_TYPES INPUT'::varchar
                                ,pRecCount => 5);

  INSERT INTO "NeoWMS".measuring_unit_types (measuring_unit_type_name)
    VALUES ('Volume')
          ,('Length')
          ,('Weight')
          ,('Time')
          ,('Item'); 
  
  vStep := 60;
  SELECT COUNT(1)
  INTO vCount 
  FROM "NeoWMS".measuring_unit_types;

  vStep := 70;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNIT_TYPES OUTPUT'::varchar
                                ,pRecCount => vCount);

  vStep := 80;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNITS INPUT'::varchar
                                ,pRecCount => 3);
  --
  -- NB transformed data added to this table as well
  --                              
  INSERT INTO "NeoWMS".measuring_units(measuring_unit_name, measuring_unit_abbreviation, measuring_unit_system_id, measuring_unit_type_id)
  SELECT 'Kilogram','KG',mus.id,mut.id 
    FROM "NeoWMS".measuring_unit_systems mus
        ,"NeoWMS".measuring_unit_types mut
   WHERE mus.measuring_unit_system_name = 'Decimal'
     AND mut.measuring_unit_type_name = 'Weight';
  
  INSERT INTO "NeoWMS".measuring_units(measuring_unit_name, measuring_unit_abbreviation, measuring_unit_system_id, measuring_unit_type_id)
  SELECT 'Centimetre','CM',mus.id,mut.id 
    FROM "NeoWMS".measuring_unit_systems mus
        ,"NeoWMS".measuring_unit_types mut
   WHERE mus.measuring_unit_system_name = 'Decimal'
     AND mut.measuring_unit_type_name = 'Length';
  
   INSERT INTO "NeoWMS".measuring_units(measuring_unit_name, measuring_unit_abbreviation, measuring_unit_system_id, measuring_unit_type_id)
  SELECT 'Decimetre','DM3',mus.id,mut.id 
    FROM "NeoWMS".measuring_unit_systems mus
        ,"NeoWMS".measuring_unit_types mut
   WHERE mus.measuring_unit_system_name = 'Decimal'
     AND mut.measuring_unit_type_name = 'Volume';
  
  vStep := 90;
  SELECT COUNT(1)
  INTO vCount 
  FROM "NeoWMS".measuring_units;

  vStep := 100;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'RECORDCOUNT'::varchar
                                ,pDesc => 'MEASURING_UNITS OUTPUT'::varchar
                                ,pRecCount => vCount);
       
  vStep := 110;
  vResult := "Transform".transform_log(pModule => vModule
                                ,pEvent => 'END'::varchar);
  RETURN 'SUCCESS';
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
