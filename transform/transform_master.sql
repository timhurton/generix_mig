DO $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 06/03/2024  T. Hurton   Initial Revision. Call the individual proecures that transform all the data to the 
   *                         new format.
   * 
   ***************************************************************************************************************  
*/   
DECLARE
  --
  -- BEGIN standard declarations
  --
  v_module transform_log.module_name%TYPE := 'TRANSFORM_MASTER.SQL';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  --
  -- END standard declarations
  --
BEGIN
  -- Assumption that we do not need to include this connection in the child
  -- objects called from here.
  CALL proc_connect_dblink('UtilsConnection');

  -- Ensure we start with emtpy tables
  v_step := 10;

  -- Clear down target tables via views.
--   DELETE FROM stock;
--   DELETE FROM item_masters;
--   DELETE FROM item_master_statuses;
--   DELETE FROM locations;
--   DELETE FROM location_statuses;
--   DELETE FROM levels;
--   DELETE FROM racks;
--   DELETE FROM aisles;
--   DELETE FROM zones;
  DELETE FROM facility;
--   DELETE FROM product_classes;
--   DELETE FROM facility_types;
--   DELETE FROM countries;
--   DELETE FROM languages;
--   DELETE FROM measuring_units;
--   DELETE FROM measuring_unit_types;
--   DELETE FROM measuring_unit_systems;
--   Might need to re-assess how we handle the commits from within this script. Cannot have commits and exceptions !!!!!
  COMMIT;  -- Need TO RELEASE LARGE ROLLBACK segment


  v_step := 30;
  -- remember to add new tables to the delete section (above) as well
  CALL proc_transform_facility();
  COMMIT;
--   CALL proc_load_reference_data();
--   COMMIT;
/*
  CALL proc_transform_languages();
  COMMIT;
  CALL proc_transform_countries();
  COMMIT;
  CALL transform_facility_types();
  COMMIT;
  CALL transform_facilities();
  COMMIT;
  CALL transform_product_classes();
  COMMIT;
  CALL transform_zones();
  COMMIT;
  CALL transform_aisles();
  COMMIT;
  CALL transform_racks();
  COMMIT;
  CALL transform_levels();
  COMMIT;
  CALL transform_location_statuses();
  COMMIT;
  CALL transform_locations();
  COMMIT;
  CALL transform_measuring_units();
  COMMIT;
  CALL transform_item_master_statuses();
  COMMIT;
  CALL transform_item_masters();
  COMMIT;
  CALL transform_stock();
  COMMIT;
*/  
--
-- we cannot log the error as the presence of commits means we cannot have an exception handler.
--
END;
$$;
