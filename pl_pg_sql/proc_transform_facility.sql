CREATE OR REPLACE PROCEDURE proc_transform_facility()
  LANGUAGE plpgsql AS $$
/* ***************************************************************************************************************  
   *
   * Date        Developer   Description
   * ==========  ==========  ===========
   * 18/03/2024  Tim Hurton  Initial Revision. Transform data to the facility table.
   * 
   ***************************************************************************************************************  
*/   
DECLARE 
  -- BEGIN standard declarations
  v_module transform_log.module_name%TYPE := 'PROC_TRANSFORM_FACILITY';
  -- Standard error handling variables
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_step    INTEGER DEFAULT -1;
  -- END standard declarations
  v_count   INTEGER;
BEGIN 

  v_Step := 10;
  CALL proc_log(p_module => v_module
               ,p_event => 'START');
             
  v_step := 20;
  SELECT COUNT(1)
    INTO v_count 
    FROM gezsit;

  v_step := 30;
  CALL proc_log(p_module => v_module
              ,p_event => 'RECORDCOUNT'
              ,p_desc => 'GEZSIT INPUT'
              ,p_rec_count => v_count);
  
  v_step := 40;
  -- audit columns left out as I anticipate that core will auto-populate them. Optional any way!
  INSERT INTO facility(facility_name 
                      ,facility_description
                      ,facility_type_id
                      ,language_id
                      ,address1 
                      ,address2 
                      ,address3
                      ,city 
                      ,province
                      ,country_id
                      ,postal_code
                      ,gln
                      ,is_active
                      ,measuring_unit_system_id
                      )
  SELECT f.codsit AS facility_name
        ,f.libsit AS facility_description
        ,ft.facility_type_id AS facility_type_id
        ,l.language_id AS language_id 
        ,f.ad1sit AS address1
        ,f.ad2sit AS address2
        ,NULL AS address3
        ,f.vilsit AS city
        ,f.codrgt AS province
        ,c.country_id AS country_id
        ,f.cposit AS postal_code
        ,f.edisit AS gln
        ,TRUE AS is_active
        ,1 AS measuring_unit_system_id
    FROM gezsit f
    JOIN gezlge lge ON (lge.codlge = f.codrgt)
    JOIN facility_type ft ON (ft.facility_type_id = f.typsit::int)
    JOIN country c ON (c.alpha2_code = COALESCE(NULLIF(f.paysit,''),'ES'))
    LEFT OUTER join language l ON (lge.codlge = l.language_code);

  v_step := 50;
  SELECT COUNT(1)
    INTO v_count 
    FROM facility;

  v_step := 60;
  CALL proc_log(p_module => v_module
              ,p_event => 'RECORDCOUNT'
              ,p_desc => 'FACILITY OUTPUT'
              ,p_rec_count => v_count);

       
  v_step := 70;
  CALL proc_log(p_module => v_module
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