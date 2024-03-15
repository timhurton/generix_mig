CREATE OR REPLACE PROCEDURE "WMS".transform_master()
  LANGUAGE plpgsql AS
$$
DECLARE
  --
  -- BEGIN standard declarations
  --
  vModule "WMS".transform_log.module_name%TYPE := 'TRANSFORM_MASTER';
  -- Standard error handling variables
  vState   TEXT;
  vMsg     TEXT;
  vDetail  TEXT;
  vHint    TEXT;
  vContext TEXT;
  vStep    integer DEFAULT -1;
  --
  -- END standard declarations
  --
  vReturn varchar(20); 
    
BEGIN
  -- Ensure we start with emtpy tables
  vStep := 10;
  DELETE FROM "WMS".transform_log;  
  DELETE FROM "WMS".migration_reports;
  DELETE FROM "WMS".pivot_constraints;

  vStep := 20;
  DELETE FROM "NeoWMS".stock;
  DELETE FROM "NeoWMS".item_masters;
  DELETE FROM "NeoWMS".item_master_statuses;
  DELETE FROM "NeoWMS".locations;
  DELETE FROM "NeoWMS".location_statuses;
  DELETE FROM "NeoWMS".levels;
  DELETE FROM "NeoWMS".racks;
  DELETE FROM "NeoWMS".aisles;
  DELETE FROM "NeoWMS".zones;
  DELETE FROM "NeoWMS".facilities;
  DELETE FROM "NeoWMS".product_classes;
  DELETE FROM "NeoWMS".facility_types;
  DELETE FROM "NeoWMS".countries;
  DELETE FROM "NeoWMS".languages;
  DELETE FROM "NeoWMS".measuring_units;
  DELETE FROM "NeoWMS".measuring_unit_types;
  DELETE FROM "NeoWMS".measuring_unit_systems;


  vStep := 30;
  -- remember to add new tables to the delete section (above) as well
  vReturn := "WMS".load_reference_data();
  vReturn := "WMS".transform_languages();
  vReturn := "WMS".transform_countries();
  vReturn := "WMS".transform_facility_types();
  vReturn := "WMS".transform_facilities();
  vReturn := "WMS".transform_product_classes();
  vReturn := "WMS".transform_zones();
  vReturn := "WMS".transform_aisles();
  vReturn := "WMS".transform_racks();
  vReturn := "WMS".transform_levels();
  vReturn := "WMS".transform_location_statuses();
  vReturn := "WMS".transform_locations();
  vReturn := "WMS".transform_measuring_units();
  vReturn := "WMS".transform_item_master_statuses();
  vReturn := "WMS".transform_item_masters();
  COMMIT;
  vReturn := "WMS".transform_stock();
    
--EXCEPTION
---- Begin standard error handling
--  WHEN OTHERS THEN
--    GET stacked DIAGNOSTICS
--      vState := returned_sqlstate
--     ,vMsg := message_text
--     ,vDetail := pg_exception_detail
--     ,vHint := pg_exception_hint
--     ,vContext := pg_exception_context;
--    RAISE NOTICE E' Module % encountered exception at % state: %
--                        message: %
--                        detail: %
--                        hint: %
--                        context: %
--                        step: %'
--               ,vModule
--               ,now()
--               ,vState
--               ,vMsg
--               ,vDetail
--               ,vHint
--               ,vContext
--               ,vStep;
---- End standard error handling
END;
$$;
