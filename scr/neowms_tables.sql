-- We have to be careful about the order in which we drop tables as this can be prevented by dependent child tables.
DROP TABLE IF EXISTS "NeoWMS".item_masters CASCADE;
DROP TABLE IF EXISTS "NeoWMS".item_master_statuses CASCADE;                                        
DROP TABLE IF EXISTS "NeoWMS".stock CASCADE;
DROP TABLE IF EXISTS "NeoWMS".locations CASCADE;
DROP TABLE IF EXISTS "NeoWMS".location_statuses CASCADE;
DROP TABLE IF EXISTS "NeoWMS".measuring_units CASCADE;
DROP TABLE IF EXISTS "NeoWMS".measuring_unit_systems CASCADE;
DROP TABLE IF EXISTS "NeoWMS".measuring_unit_types CASCADE;
DROP TABLE IF EXISTS "NeoWMS".levels CASCADE;
DROP TABLE IF EXISTS "NeoWMS".racks CASCADE;
DROP TABLE IF EXISTS "NeoWMS".aisles CASCADE;
DROP TABLE IF EXISTS "NeoWMS".zones CASCADE;
DROP TABLE IF EXISTS "NeoWMS".facilities CASCADE;
DROP TABLE IF EXISTS "NeoWMS".facility_types CASCADE;
DROP TABLE IF EXISTS "NeoWMS".product_classes CASCADE;
DROP TABLE IF EXISTS "NeoWMS".countries CASCADE;
DROP TABLE IF EXISTS "NeoWMS".languages CASCADE;

CREATE TABLE "NeoWMS".languages (id serial NOT NULL
                                ,language_code varchar(3) NOT NULL 
                                ,language_name varchar(30) NOT NULL 
                                );
ALTER TABLE "NeoWMS".languages ADD CONSTRAINT pk_languages PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".languages ADD CONSTRAINT un_language_code UNIQUE (language_code);
ALTER TABLE "NeoWMS".languages ADD CONSTRAINT un_language_name UNIQUE (language_name);
                                      
CREATE TABLE "NeoWMS".countries (id serial NOT NULL
                                ,country_name varchar(30) NOT NULL
                                ,alpha2_code  varchar(3) NULL
                                ,alpha3_code  varchar(3) NULL
                                );
ALTER TABLE "NeoWMS".countries ADD CONSTRAINT pk_countries PRIMARY KEY (id);                                   
--ALTER TABLE "NeoWMS".countries ADD CONSTRAINT un_country_name UNIQUE (country_name);
ALTER TABLE "NeoWMS".countries ADD CONSTRAINT un_alpha2_code UNIQUE (alpha2_code);
                                      
CREATE TABLE "NeoWMS".product_classes (id serial NOT NULL
                                      ,product_class_name varchar(30) NOT NULL 
                                      );
ALTER TABLE "NeoWMS".product_classes ADD CONSTRAINT pk_product_classes PRIMARY KEY (id); 
ALTER TABLE "NeoWMS".product_classes ADD CONSTRAINT un_product_class_name UNIQUE (product_class_name);     
CREATE INDEX ix_product_class_name ON "NeoWMS".product_classes(product_class_name);  -- Useful for performance reasons
                                      
CREATE TABLE "NeoWMS".facility_types (id serial NOT NULL
                                     ,facility_type_name   varchar(80) NOT NULL
                                     );
ALTER TABLE "NeoWMS".facility_types ADD CONSTRAINT pk_facility_types PRIMARY KEY (id);                
ALTER TABLE "NeoWMS".facility_types ADD CONSTRAINT un_facility_type_name UNIQUE (facility_type_name);
                                      
CREATE TABLE "NeoWMS".facilities (id serial NOT NULL
                                 ,facility_name            varchar(3) NOT NULL 
                                 ,facility_description     varchar(30) NOT NULL
                                 ,facility_type_id         integer NOT NULL 
                                 ,language_id              integer NULL
                                 ,address1                 varchar(80) NULL 
                                 ,address2                 varchar(80) NULL 
                                 ,address3                 varchar(80) NULL
                                 ,city                     varchar(80) NULL 
                                 ,province                 varchar(80) NULL 
                                 ,country_id               integer NULL
                                 ,postal_code              varchar(20) NULL 
                                 ,gin                      varchar(1) NULL -- Need TO CHECK what this IS
                                 ,is_active                varchar(1) NULL 
                                 ,meausring_unit_system_id integer NULL 
                                 );
ALTER TABLE "NeoWMS".facilities ADD CONSTRAINT pk_facilities PRIMARY KEY (id); 
ALTER TABLE "NeoWMS".facilities ADD CONSTRAINT fk_facilities_facility_types FOREIGN KEY (facility_type_id) REFERENCES "NeoWMS".facility_types(id);
ALTER TABLE "NeoWMS".facilities ADD CONSTRAINT fk_facilities_languages FOREIGN KEY (language_id) REFERENCES "NeoWMS".languages(id);
ALTER TABLE "NeoWMS".facilities ADD CONSTRAINT fk_facilities_countries FOREIGN KEY (country_id) REFERENCES "NeoWMS".countries(id);

                                                                
CREATE TABLE "NeoWMS".zones (id serial NOT NULL
                            ,zone_code varchar(1) NOT NULL 
                            ,facility_id integer NOT NULL 
                            ,zone_status_id integer NULL 
                            ,location_rule_id integer NULL
                            );      
ALTER TABLE "NeoWMS".zones ADD CONSTRAINT pk_zones PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".zones ADD CONSTRAINT fk_zones_facilities FOREIGN KEY (facility_id) REFERENCES "NeoWMS".facilities(id);
ALTER TABLE "NeoWMS".zones ADD CONSTRAINT un_zone_code UNIQUE (zone_code);
CREATE INDEX ix_zone_code ON "NeoWMS".zones(zone_code);  -- Not sure if this would be there in reality.

CREATE TABLE "NeoWMS".aisles (id serial NOT NULL
                             ,facility_id integer NULL 
                             ,zone_id integer NOT NULL 
                             ,aisle_code integer NOT NULL 
                             ,aisle_direction_id integer NULL 
                             ,aisle_status_id integer NULL 
                             ,location_rule_id integer NULL
                            );      
ALTER TABLE "NeoWMS".aisles ADD CONSTRAINT pk_aisles PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".aisles ADD CONSTRAINT fk_aisles_facilities FOREIGN KEY (facility_id) REFERENCES "NeoWMS".facilities(id);
ALTER TABLE "NeoWMS".aisles ADD CONSTRAINT fk_aisles_zones FOREIGN KEY (zone_id) REFERENCES "NeoWMS".zones(id);
-- Next constraint requires clarification
ALTER TABLE "NeoWMS".aisles ADD CONSTRAINT un_zone_aisle_code UNIQUE (zone_id,aisle_code);
ALTER TABLE "NeoWMS".aisles ADD CONSTRAINT un_facility_zone_aisle_code UNIQUE (facility_id,zone_id,aisle_code);
CREATE INDEX ix_aisle_code ON "NeoWMS".aisles(aisle_code);  -- Not sure if this would be there in reality.

CREATE TABLE "NeoWMS".racks (id serial NOT NULL
                            ,aisle_id integer NOT NULL 
                            ,rack_code integer NOT NULL 
                            ,rack_status_id integer NULL 
                            ,location_weight_volume_id integer NULL 
                            ,location_rule_id integer NULL
                            );      
ALTER TABLE "NeoWMS".racks ADD CONSTRAINT pk_racks PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".racks ADD CONSTRAINT fk_racks_aisles FOREIGN KEY (aisle_id) REFERENCES "NeoWMS".aisles(id);
CREATE INDEX ix_rack_code ON "NeoWMS".racks(rack_code);  -- Not sure if this would be there in reality.

CREATE TABLE "NeoWMS".levels (id serial NOT NULL
                             ,rack_id integer NOT NULL 
                             ,level_code integer NOT NULL 
                             ,level_status_id integer NULL 
                             ,location_weight_volume_id integer NULL 
                             ,location_rule_id integer NULL
                             );      
ALTER TABLE "NeoWMS".levels ADD CONSTRAINT pk_levels PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".levels ADD CONSTRAINT fk_levels_racks FOREIGN KEY (rack_id) REFERENCES "NeoWMS".racks(id);
CREATE INDEX ix_level_code ON "NeoWMS".levels(level_code);  -- Not sure if this would be there in reality.

CREATE TABLE "NeoWMS".measuring_unit_types(id serial NOT NULL
                                          ,measuring_unit_type_name varchar(20) NOT NULL -- Arbiatary length
                                          );
ALTER TABLE "NeoWMS".measuring_unit_types ADD CONSTRAINT pk_measuring_unit_types PRIMARY KEY (id);    
ALTER TABLE "NeoWMS".measuring_unit_types ADD CONSTRAINT un_measuring_unit_type_name UNIQUE (measuring_unit_type_name);

CREATE TABLE "NeoWMS".measuring_unit_systems(id serial NOT NULL
                                            ,measuring_unit_system_name varchar(20) NOT NULL -- Arbitary length
                                            );
ALTER TABLE "NeoWMS".measuring_unit_systems ADD CONSTRAINT pk_measuring_unit_systems PRIMARY KEY (id);  
ALTER TABLE "NeoWMS".measuring_unit_systems ADD CONSTRAINT un_measuring_unit_system_name UNIQUE (measuring_unit_system_name);

CREATE TABLE "NeoWMS".measuring_units(id serial NOT NULL
                                     ,measuring_unit_name varchar(40) NOT NULL -- Arbitary length
                                     ,measuring_unit_abbreviation varchar(10) NOT NULL -- Arbitary length
                                     ,measuring_unit_system_id integer NOT NULL
                                     ,measuring_unit_type_id integer NOT NULL 
                                     );
ALTER TABLE "NeoWMS".measuring_units ADD CONSTRAINT pk_measuring_units PRIMARY KEY (id);
ALTER TABLE "NeoWMS".measuring_units ADD CONSTRAINT fk_measuring_units_measuring_unit_systems FOREIGN KEY (measuring_unit_system_id) REFERENCES "NeoWMS".measuring_unit_systems(id);
ALTER TABLE "NeoWMS".measuring_units ADD CONSTRAINT fk_measuring_units_measuring_unit_types FOREIGN KEY (measuring_unit_type_id) REFERENCES "NeoWMS".measuring_unit_types(id);
ALTER TABLE "NeoWMS".measuring_units ADD CONSTRAINT un_measuring_unit_name UNIQUE (measuring_unit_name);
ALTER TABLE "NeoWMS".measuring_units ADD CONSTRAINT un_measuring_unit_abbreviation UNIQUE (measuring_unit_abbreviation);

CREATE TABLE "NeoWMS".location_statuses (id serial NOT NULL
                                        ,location_status_name varchar(40) NOT NULL -- arbitary
                                        );
ALTER TABLE "NeoWMS".location_statuses ADD CONSTRAINT pk_location_statuses PRIMARY KEY (id);                                      


CREATE TABLE "NeoWMS".locations (id serial NOT NULL
                                ,facility_id integer NOT NULL
                                ,zone_id integer NOT NULL -- ZONSTS
                                ,aisle_id integer NOT NULL -- ALLSTS
                                ,rack_id integer NOT NULL -- DPLSTS
                                ,level_id integer NOT NULL  -- NIVSTS
                                ,location_code varchar(15) NOT NULL -- Guess made up of zone-aisle-rack-level-position probable has to change
                                ,location_name varchar(15) NOT NULL -- Just a copy of location code for now.
                                ,location_barcode varchar(20) NULL -- huge amount OF barcode formats available, USING a semi-arbitary 20 character version.
                                ,location_position integer NOT NULL -- best guess once more.
                                ,location_type_id integer NULL -- CODMBL Will leave this FOR now AS looks like it could be a can OF worms,
                                ,location_weight_volume_id integer NULL
                                ,location_rule_id integer NULL
                                ,location_status_id integer NOT NULL  --ETASTS
                                ,maximum_number_of_item_master integer NULL
                                ,has_inbound_address boolean 
                                ,inbound_name varchar(80) NULL -- arbtiary TBC
                                ,inbound_barcode varchar(20) NULL -- Arbitary, see above
                                ,has_outbound_address boolean 
                                ,outbound_name varchar(80) NULL -- arbtiary TBC
                                ,outbound_barcode varchar(20) NULL -- Arbitary, see above
                                ,available_weight NUMERIC(4) NULL  -- POIDIS
                                ,weight_measuring_unit_id integer  NULL
                                ,available_width NUMERIC(3)   -- LRGDIS 
                                ,available_height NUMERIC(4) NULL  -- HAUDIS
                                ,available_depth NUMERIC(3) NULL -- no apparent source  
                                ,tolerance_width NUMERIC(2) NULL   -- TOLLRG
                                ,tolerance_height NUMERIC(2) -- TOLHAU
                                ,tolerance_depth NUMERIC(2) NULL -- NO apparent source
                                ,length_measuring_unit_id integer NULL
                                ,available_volume  NUMERIC(8) NULL -- arbitary, based ON 4 x 3 x 2
                                ,volume_measuring_unit_id integer NULL
                                );
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT pk_locations PRIMARY KEY (id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_facilities FOREIGN KEY (facility_id) REFERENCES "NeoWMS".facilities(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_zones FOREIGN KEY (zone_id) REFERENCES "NeoWMS".zones(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_aisles FOREIGN KEY (aisle_id) REFERENCES "NeoWMS".aisles(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_racks FOREIGN KEY (rack_id) REFERENCES "NeoWMS".racks(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_levels FOREIGN KEY (level_id) REFERENCES "NeoWMS".levels(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_location_statuses FOREIGN KEY (location_status_id) REFERENCES "NeoWMS".location_statuses(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_measuring_unit_length FOREIGN KEY (length_measuring_unit_id) REFERENCES "NeoWMS".measuring_units(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_measuring_unit_volume FOREIGN KEY (volume_measuring_unit_id) REFERENCES "NeoWMS".measuring_units(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT fk_locations_measuring_unit_weight FOREIGN KEY (weight_measuring_unit_id) REFERENCES "NeoWMS".measuring_units(id);
ALTER TABLE "NeoWMS".locations ADD CONSTRAINT un_location_code UNIQUE (location_code);
CREATE INDEX ix_location_code ON "NeoWMS".locations(location_code);

CREATE TABLE "NeoWMS".item_master_statuses(id serial NOT NULL
                                          ,item_master_status_name varchar(40) NOT NULL  -- arbitary SIZE FOR now
                                          );
ALTER TABLE "NeoWMS".item_master_statuses ADD CONSTRAINT pk_item_master_statuses PRIMARY KEY (id);                                        

                                 
CREATE TABLE "NeoWMS".item_masters(id serial NOT NULL
                                 ,item_code varchar(17) NOT NULL -- codpro
                                 ,item_master_name varchar(30) NOT NULL  -- desfou FOR now
                                 ,item_master_description varchar(105) NOT NULL -- ds1pro + ds2pro + ds3pro
                                 ,stock_owner_id integer NULL -- FK to partner I think? will leave blank for now
                                 ,product_class_id integer NOT NULL -- fampro
                                 ,inventory_priority_id_id integer NULL  -- Will come back to
                                 ,item_master_status_id integer NOT NULL   -- etapro
                                 ,measuring_unit_reference_id integer NOT NULL  -- unipro
                                 );
ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT pk_item_masters PRIMARY KEY (id);
--ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT fk_item_masters_partners FOREIGN KEY (stock_owner_id) REFERENCES "NeoWMS".partners(id);
ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT fk_item_masters_product_classes FOREIGN KEY (product_class_id) REFERENCES "NeoWMS".product_classes(id);
ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT fk_item_masters_item_master_statuses FOREIGN KEY (item_master_status_id) REFERENCES "NeoWMS".item_master_statuses(id);
ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT fk_item_masters_measuring_units FOREIGN KEY (measuring_unit_reference_id) REFERENCES "NeoWMS".measuring_units(id);
ALTER TABLE "NeoWMS".item_masters ADD CONSTRAINT un_item_master_code UNIQUE (item_code);
CREATE INDEX ix_item_code ON "NeoWMS".item_masters(item_code);                                   

CREATE TABLE "NeoWMS".stock (id serial NOT NULL
                            ,item_master_id integer NULL
                            ,item_sku_attribute_id integer NULL
                            ,item_stock_attribute_id integer NULL
                            ,location_id integer NULL
                            ,stock_state_id integer NULL
                            ,quantity integer NOT NULL
                            ,item_master_footprint_detail_id integer NULL
                            ,container_id integer NULL 
                            );
ALTER TABLE "NeoWMS".stock ADD CONSTRAINT pk_stock PRIMARY KEY (id);

 

