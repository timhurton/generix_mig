BEGIN TRANSACTION;

drop schema wms cascade;
create schema wms;


-- Structure script
CREATE TABLE "wms"."advanced_shipping_notice" (
	"advanced_shipping_notice_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"partner_id"							integer					 NULL,
	"advanced_shipping_notice_number"		character varying(256)	 NOT NULL,
	"advanced_shipping_notice_date"			date					 NOT NULL,
	"advanced_shipping_notice_status_id"	integer					 NOT NULL,
	"additional_information"				character varying(1024)	 NULL,
	"free_text"								character varying(1024)	 NULL,
	"planned_delivery_on"					timestamp with time zone NULL,
	"facility_id"							integer					 NOT NULL,
	"gate_location_id"						integer					 NULL,
	"inbound_load_id"						integer					 NULL,
	"partner_name"							character varying(256)	 NULL,
	"partner_address"						character varying(1024)	 NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."advanced_shipping_notice" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."advanced_shipping_notice_status" (
	"advanced_shipping_notice_status_id"		integer					 NOT NULL,
	"advanced_shipping_notice_status_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."advanced_shipping_notice_status" ADD CONSTRAINT "advanced_shipping_notice_status_pkey" PRIMARY KEY ("advanced_shipping_notice_status_id");
ALTER TABLE "wms"."advanced_shipping_notice"
ADD CONSTRAINT "fk_advanced_shipping_notice_advanced_shipping_notice_status" FOREIGN KEY ("advanced_shipping_notice_status_id") REFERENCES "wms"."advanced_shipping_notice_status" ("advanced_shipping_notice_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."facility" (
	"facility_id"					integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_name"					character varying(256)	 NOT NULL,
	"facility_description"			character varying(256)	 NULL,
	"facility_type_id"				integer					 NOT NULL,
	"language_id"					integer					 NULL,
	"address1"						character varying(256)	 NOT NULL,
	"address2"						character varying(256)	 NULL,
	"address3"						character varying(256)	 NULL,
	"city"							character varying(256)	 NOT NULL,
	"province"						character varying(256)	 NOT NULL,
	"country_id"					integer					 NOT NULL,
	"postal_code"					character varying(256)	 NOT NULL,
	"gln"							character varying(50)	 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"measuring_unit_system_id"		integer					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."facility" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."country" (
	"country_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"country_name"		character varying(256)	 NOT NULL,
	"alpha2_code"		character varying(10)	 NOT NULL,
	"alpha3_code"		character varying(10)	 NOT NULL,
	"created_by"		integer					 NULL,
	"created_on"		timestamp with time zone NULL,
	"modified_by"		integer					 NULL,
	"modified_on"		timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."country" ADD CONSTRAINT "country_pkey" PRIMARY KEY ("country_id");
CREATE UNIQUE INDEX "ix_country_alpha2_code" ON "wms"."country"
USING btree
("alpha2_code" COLLATE "pg_catalog"."default");
CREATE UNIQUE INDEX "ix_country_alpha3_code" ON "wms"."country"
USING btree
("alpha3_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."facility"
ADD CONSTRAINT "fk_facility_country" FOREIGN KEY ("country_id") REFERENCES "wms"."country" ("country_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."facility_type" (
	"facility_type_id"		integer					 NOT NULL,
	"facility_type_name"	character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."facility_type" ADD CONSTRAINT "facility_type_pkey" PRIMARY KEY ("facility_type_id");
ALTER TABLE "wms"."facility"
ADD CONSTRAINT "fk_facility_facility_type" FOREIGN KEY ("facility_type_id") REFERENCES "wms"."facility_type" ("facility_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."language" (
	"language_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"language_name"		character varying(256)	 NOT NULL,
	"language_code"		character varying(10)	 NOT NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_language_language_code" ON "wms"."language"
USING btree
("language_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."language" ADD CONSTRAINT "language_pkey" PRIMARY KEY ("language_id");
ALTER TABLE "wms"."facility"
ADD CONSTRAINT "fk_facility_language" FOREIGN KEY ("language_id") REFERENCES "wms"."language" ("language_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."measuring_unit_system" (
	"measuring_unit_system_id"		integer					 NOT NULL,
	"measuring_unit_system_name"	character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."measuring_unit_system" ADD CONSTRAINT "measuring_unit_system_pkey" PRIMARY KEY ("measuring_unit_system_id");
ALTER TABLE "wms"."facility"
ADD CONSTRAINT "fk_facility_measuring_unit_system" FOREIGN KEY ("measuring_unit_system_id") REFERENCES "wms"."measuring_unit_system" ("measuring_unit_system_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."facility" ADD CONSTRAINT "facility_pkey" PRIMARY KEY ("facility_id");
CREATE INDEX "ix_facility_country_id" ON "wms"."facility"
USING btree
("country_id");
CREATE UNIQUE INDEX "ix_facility_name" ON "wms"."facility"
USING btree
("facility_name" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."user_facility" (
	"user_facility_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"user_id"				integer					 NOT NULL,
	"facility_id"			integer					 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."user_facility"
ADD CONSTRAINT "fk_user_facility_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."user" (
	"user_id"						integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"user_account"					character varying(256)	 NOT NULL,
	"full_name"						character varying(256)	 NOT NULL,
	"email"							character varying(100)	 NULL,
	"phone"							character varying(100)	 NULL,
	"language_id"					integer					 NULL,
	"time_zone_id"					integer					 NULL,
	"is_active"						boolean					 NOT NULL,
	"last_used_facility_id"			integer					 NULL,
	"last_used_stock_owner_id"		integer					 NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."user"
ADD CONSTRAINT "fk_user_facility" FOREIGN KEY ("last_used_facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."user"
ADD CONSTRAINT "fk_user_language" FOREIGN KEY ("language_id") REFERENCES "wms"."language" ("language_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."stock_owner" (
	"stock_owner_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_owner_name"				character varying(256)	 NOT NULL,
	"stock_owner_description"		character varying(256)	 NOT NULL,
	"address1"						character varying(256)	 NOT NULL,
	"address2"						character varying(256)	 NULL,
	"address3"						character varying(256)	 NULL,
	"city"							character varying(256)	 NOT NULL,
	"province"						character varying(256)	 NOT NULL,
	"country_id"					integer					 NOT NULL,
	"postal_code"					character varying(50)	 NOT NULL,
	"gln"							character varying(100)	 NULL,
	"phone"							character varying(100)	 NOT NULL,
	"email"							character varying(100)	 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_owner" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."stock_owner"
ADD CONSTRAINT "fk_stock_owner_country" FOREIGN KEY ("country_id") REFERENCES "wms"."country" ("country_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_stock_owner_name" ON "wms"."stock_owner"
USING btree
("stock_owner_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."stock_owner" ADD CONSTRAINT "stock_owner_pkey" PRIMARY KEY ("stock_owner_id");
CREATE TABLE "wms"."user_stock_owner" (
	"user_stock_owner_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"user_id"					integer					 NOT NULL,
	"stock_owner_id"			integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."user_stock_owner"
ADD CONSTRAINT "fk_user_stock_owner_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."user" ADD CONSTRAINT "user_pkey" PRIMARY KEY ("user_id");
ALTER TABLE "wms"."user_stock_owner"
ADD CONSTRAINT "fk_user_stock_owner_user" FOREIGN KEY ("user_id") REFERENCES "wms"."user" ("user_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_user_stock_owner" ON "wms"."user_stock_owner"
USING btree
("user_id", "stock_owner_id");
CREATE INDEX "ix_user_stock_owner_stock_owner_id" ON "wms"."user_stock_owner"
USING btree
("stock_owner_id");
ALTER TABLE "wms"."user_stock_owner" ADD CONSTRAINT "user_stock_owner_pkey" PRIMARY KEY ("user_stock_owner_id");
CREATE POLICY "rls_stock_owner_delete" ON "wms"."stock_owner"
FOR DELETE
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE POLICY "rls_stock_owner_insert" ON "wms"."stock_owner"
FOR INSERT
TO "public"
WITH CHECK (true);
CREATE POLICY "rls_stock_owner_select" ON "wms"."stock_owner"
FOR SELECT
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE POLICY "rls_stock_owner_update" ON "wms"."stock_owner"
FOR UPDATE
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."user"
ADD CONSTRAINT "fk_user_stock_owner" FOREIGN KEY ("last_used_stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."timezone" (
	"time_zone_id"			integer					 NOT NULL,
	"time_zone_code"		character varying(100)	 NOT NULL,
	"time_zone_name"		character varying(256)	 NOT NULL,
	"time_zone_offset"		numeric(3, 1)			 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."timezone" ALTER COLUMN "time_zone_offset" SET STORAGE MAIN;

;
CREATE UNIQUE INDEX "ix_timezone_time_zone_code" ON "wms"."timezone"
USING btree
("time_zone_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."timezone" ADD CONSTRAINT "timezone_pkey" PRIMARY KEY ("time_zone_id");
ALTER TABLE "wms"."user"
ADD CONSTRAINT "fk_user_timezone" FOREIGN KEY ("time_zone_id") REFERENCES "wms"."timezone" ("time_zone_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_user_user_account" ON "wms"."user"
USING btree
("user_account" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."user_facility"
ADD CONSTRAINT "fk_user_facility_user" FOREIGN KEY ("user_id") REFERENCES "wms"."user" ("user_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_user_facility" ON "wms"."user_facility"
USING btree
("user_id", "facility_id");
ALTER TABLE "wms"."user_facility" ADD CONSTRAINT "user_facility_pkey" PRIMARY KEY ("user_facility_id");
CREATE POLICY "rls_facility_delete" ON "wms"."facility"
FOR DELETE
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE POLICY "rls_facility_insert" ON "wms"."facility"
FOR INSERT
TO "public"
WITH CHECK (true);
CREATE POLICY "rls_facility_select" ON "wms"."facility"
FOR SELECT
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE POLICY "rls_facility_update" ON "wms"."facility"
FOR UPDATE
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."advanced_shipping_notice"
ADD CONSTRAINT "fk_advanced_shipping_notice_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."inbound_load" (
	"inbound_load_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"transport_license_plate"		character varying(100)	 NOT NULL,
	"inbound_load_number"			character varying(100)	 NOT NULL,
	"inbound_load_date"				date					 NOT NULL,
	"inbound_load_status_id"		integer					 NOT NULL,
	"additional_information"		character varying(1024)	 NOT NULL,
	"free_text"						character varying(1024)	 NULL,
	"partner_id"					integer					 NULL,
	"partner_name"					character varying(256)	 NULL,
	"partner_address"				character varying(1024)	 NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE TABLE "wms"."inbound_load_status" (
	"inbound_load_status_id"		integer					 NOT NULL,
	"inbound_load_status_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."inbound_load_status" ADD CONSTRAINT "inbound_load_status_pkey" PRIMARY KEY ("inbound_load_status_id");
ALTER TABLE "wms"."inbound_load"
ADD CONSTRAINT "fk_inbound_load_inbound_load_status" FOREIGN KEY ("inbound_load_status_id") REFERENCES "wms"."inbound_load_status" ("inbound_load_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."partner" (
	"partner_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_owner_id"			integer					 NOT NULL,
	"account_number"			character varying(100)	 NOT NULL,
	"partner_name"				character varying(256)	 NOT NULL,
	"partner_description"		character varying(256)	 NULL,
	"address1"					character varying(256)	 NOT NULL,
	"address2"					character varying(256)	 NULL,
	"address3"					character varying(256)	 NULL,
	"city"						character varying(256)	 NOT NULL,
	"province"					character varying(256)	 NOT NULL,
	"country_id"				integer					 NOT NULL,
	"postal_code"				character varying(256)	 NULL,
	"gln"						character varying(50)	 NULL,
	"phone"						character varying(100)	 NULL,
	"email"						character varying(100)	 NULL,
	"time_zone_id"				integer					 NULL,
	"is_vendor"					boolean					 NOT NULL,
	"is_customer"				boolean					 NOT NULL,
	"is_active"					boolean					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."partner" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."partner"
ADD CONSTRAINT "fk_partner_country" FOREIGN KEY ("country_id") REFERENCES "wms"."country" ("country_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."partner"
ADD CONSTRAINT "fk_partner_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."partner"
ADD CONSTRAINT "fk_partner_timezone" FOREIGN KEY ("time_zone_id") REFERENCES "wms"."timezone" ("time_zone_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_partner_partner_name" ON "wms"."partner"
USING btree
("partner_name" COLLATE "pg_catalog"."default");
CREATE INDEX "ix_partner_stock_owner" ON "wms"."partner"
USING btree
("stock_owner_id");
CREATE UNIQUE INDEX "ix_partner_stock_owner_account_number" ON "wms"."partner"
USING btree
("stock_owner_id", "account_number" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."partner" ADD CONSTRAINT "partner_pkey" PRIMARY KEY ("partner_id");
ALTER TABLE "wms"."partner"
ADD CONSTRAINT "ck_partner_is_vendor_customer_carrier" CHECK (is_vendor = true OR is_customer = true);
CREATE POLICY "rls_stock_owner" ON "wms"."partner"
FOR ALL
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."inbound_load"
ADD CONSTRAINT "fk_inbound_load_partner" FOREIGN KEY ("partner_id") REFERENCES "wms"."partner" ("partner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."inbound_load" ADD CONSTRAINT "inbound_load_pkey" PRIMARY KEY ("inbound_load_id");
CREATE INDEX "ix_inbound_load_date" ON "wms"."inbound_load"
USING btree
("inbound_load_date");
ALTER TABLE "wms"."advanced_shipping_notice"
ADD CONSTRAINT "fk_advanced_shipping_notice_inbound_load" FOREIGN KEY ("inbound_load_id") REFERENCES "wms"."inbound_load" ("inbound_load_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location" (
	"location_id"						integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"						integer					 NOT NULL,
	"zone_id"							integer					 NOT NULL,
	"aisle_id"							integer					 NULL,
	"rack_id"							integer					 NULL,
	"level_id"							integer					 NULL,
	"location_code"						character varying(100)	 NOT NULL,
	"location_name"						character varying(256)	 NOT NULL,
	"location_barcode"					character varying(100)	 NOT NULL,
	"location_position"					integer					 NOT NULL,
	"location_type_id"					integer					 NOT NULL,
	"location_weight_volume_id"			integer					 NULL,
	"location_rule_id"					integer					 NULL,
	"location_status_id"				integer					 NOT NULL,
	"maximum_number_of_item_masters"	integer					 NULL,
	"has_inbound_address"				boolean					 NOT NULL,
	"inbound_name"						character varying(256)	 NULL,
	"inbound_barcode"					character varying(100)	 NULL,
	"has_outbound_address"				boolean					 NOT NULL,
	"outbound_name"						character varying(256)	 NULL,
	"outbound_barcode"					character varying(100)	 NULL,
	"available_weight"					numeric(10, 3)			 NULL,
	"weight_measuring_unit_id"			integer					 NOT NULL,
	"available_width"					numeric(10, 3)			 NULL,
	"available_height"					numeric(10, 3)			 NULL,
	"available_depth"					numeric(10, 3)			 NULL,
	"tolerance_width"					numeric(10, 3)			 NULL,
	"tolerance_height"					numeric(10, 3)			 NULL,
	"tolerance_depth"					numeric(10, 3)			 NULL,
	"length_measuring_unit_id"			integer					 NOT NULL,
	"available_volume"					numeric(10, 3)			 NULL,
	"volume_measuring_unit_id"			integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."location" ALTER COLUMN "available_weight" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "available_width" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "available_height" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "available_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "tolerance_width" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "tolerance_height" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "tolerance_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."location" ALTER COLUMN "available_volume" SET STORAGE MAIN;

;
CREATE TABLE "wms"."aisle" (
	"aisle_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"			integer					 NOT NULL,
	"zone_id"				integer					 NULL,
	"aisle_code"			character varying(100)	 NOT NULL,
	"aisle_direction_id"	integer					 NOT NULL,
	"aisle_status_id"		integer					 NOT NULL,
	"location_rule_id"		integer					 NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."aisle" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."aisle_direction" (
	"aisle_direction_id"		integer					 NOT NULL,
	"aisle_direction_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."aisle_direction" ADD CONSTRAINT "aisle_direction_pkey" PRIMARY KEY ("aisle_direction_id");
ALTER TABLE "wms"."aisle"
ADD CONSTRAINT "fk_aisle_aisle_direction" FOREIGN KEY ("aisle_direction_id") REFERENCES "wms"."aisle_direction" ("aisle_direction_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."aisle_status" (
	"aisle_status_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"aisle_status_name"		character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."aisle_status" ADD CONSTRAINT "aisle_status_pkey" PRIMARY KEY ("aisle_status_id");
CREATE UNIQUE INDEX "ix_aisle_status_name" ON "wms"."aisle_status"
USING btree
("aisle_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."aisle"
ADD CONSTRAINT "fk_aisle_aisle_status" FOREIGN KEY ("aisle_status_id") REFERENCES "wms"."aisle_status" ("aisle_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."aisle"
ADD CONSTRAINT "fk_aisle_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location_rule" (
	"location_rule_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"					integer					 NOT NULL,
	"allow_any_item_master"			boolean					 NOT NULL,
	"allow_any_product_class"		boolean					 NOT NULL,
	"allow_any_stock_owner"			boolean					 NOT NULL,
	"allow_any_stock_operation"		boolean					 NOT NULL,
	"allow_any_putaway_type"		boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule"
ADD CONSTRAINT "fk_location_rule_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_location_rule_facility_id" ON "wms"."location_rule"
USING btree
("facility_id");
ALTER TABLE "wms"."location_rule" ADD CONSTRAINT "location_rule_pkey" PRIMARY KEY ("location_rule_id");
CREATE POLICY "rls_facility" ON "wms"."location_rule"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."aisle"
ADD CONSTRAINT "fk_aisle_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."zone" (
	"zone_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"			integer					 NOT NULL,
	"zone_code"				character varying(100)	 NOT NULL,
	"zone_status_id"		integer					 NOT NULL,
	"location_rule_id"		integer					 NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."zone" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."zone"
ADD CONSTRAINT "fk_zone_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."zone"
ADD CONSTRAINT "fk_zone_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."zone_status" (
	"zone_status_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"zone_status_name"		character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_zone_status_name" ON "wms"."zone_status"
USING btree
("zone_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."zone_status" ADD CONSTRAINT "zone_status_pkey" PRIMARY KEY ("zone_status_id");
ALTER TABLE "wms"."zone"
ADD CONSTRAINT "fk_zone_zone_status" FOREIGN KEY ("zone_status_id") REFERENCES "wms"."zone_status" ("zone_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_zone" ON "wms"."zone"
USING btree
("facility_id", "zone_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."zone" ADD CONSTRAINT "zone_pkey" PRIMARY KEY ("zone_id");
CREATE POLICY "rls_facility" ON "wms"."zone"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."aisle"
ADD CONSTRAINT "fk_aisle_zone" FOREIGN KEY ("zone_id") REFERENCES "wms"."zone" ("zone_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."aisle" ADD CONSTRAINT "aisle_pkey" PRIMARY KEY ("aisle_id");
CREATE UNIQUE INDEX "ix_aisle" ON "wms"."aisle"
USING btree
("facility_id", "zone_id", "aisle_code" COLLATE "pg_catalog"."default");
CREATE POLICY "rls_facility" ON "wms"."aisle"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_aisle" FOREIGN KEY ("aisle_id") REFERENCES "wms"."aisle" ("aisle_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."level" (
	"level_id"						integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"rack_id"						integer					 NOT NULL,
	"level_code"					character varying(100)	 NOT NULL,
	"level_status_id"				integer					 NOT NULL,
	"location_weight_volume_id"		integer					 NULL,
	"location_rule_id"				integer					 NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."level" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."level_status" (
	"level_status_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"level_status_name"		character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_level_status_name" ON "wms"."level_status"
USING btree
("level_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."level_status" ADD CONSTRAINT "level_status_pkey" PRIMARY KEY ("level_status_id");
ALTER TABLE "wms"."level"
ADD CONSTRAINT "fk_level_level_status" FOREIGN KEY ("level_status_id") REFERENCES "wms"."level_status" ("level_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."level"
ADD CONSTRAINT "fk_level_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location_weight_volume" (
	"location_weight_volume_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"						integer					 NOT NULL,
	"location_weight_volume_name"		character varying(256)	 NOT NULL,
	"max_weight"						numeric(10, 3)			 NOT NULL,
	"weight_measuring_unit_id"			integer					 NOT NULL,
	"inner_width"						numeric(10, 3)			 NOT NULL,
	"inner_height"						numeric(10, 3)			 NOT NULL,
	"inner_depth"						numeric(10, 3)			 NOT NULL,
	"outer_width"						numeric(10, 3)			 NOT NULL,
	"outer_height"						numeric(10, 3)			 NOT NULL,
	"outer_depth"						numeric(10, 3)			 NOT NULL,
	"length_measuring_unit_id"			integer					 NOT NULL,
	"inner_volume"						numeric(10, 3)			 NOT NULL,
	"outer_volume"						numeric(10, 3)			 NOT NULL,
	"volume_measuring_unit_id"			integer					 NOT NULL,
	"maximum_number_of_pallets"			integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_weight_volume" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "max_weight" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "inner_width" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "inner_height" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "inner_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "outer_width" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "outer_height" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "outer_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "inner_volume" SET STORAGE MAIN;

ALTER TABLE "wms"."location_weight_volume" ALTER COLUMN "outer_volume" SET STORAGE MAIN;

;
ALTER TABLE "wms"."location_weight_volume"
ADD CONSTRAINT "fk_location_weight_volume_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."measuring_unit" (
	"measuring_unit_id"					integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"measuring_unit_name"				character varying(256)	 NOT NULL,
	"measuring_unit_abbreviation"		character varying(50)	 NOT NULL,
	"measuring_unit_system_id"			integer					 NOT NULL,
	"measuring_unit_type_id"			integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."measuring_unit"
ADD CONSTRAINT "fk_measuring_unit_measuring_unit_system" FOREIGN KEY ("measuring_unit_system_id") REFERENCES "wms"."measuring_unit_system" ("measuring_unit_system_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."measuring_unit_type" (
	"measuring_unit_type_id"		integer					 NOT NULL,
	"measuring_unit_type_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."measuring_unit_type" ADD CONSTRAINT "measuring_unit_type_pkey" PRIMARY KEY ("measuring_unit_type_id");
ALTER TABLE "wms"."measuring_unit"
ADD CONSTRAINT "fk_measuring_unit_measuring_unit_type" FOREIGN KEY ("measuring_unit_type_id") REFERENCES "wms"."measuring_unit_type" ("measuring_unit_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_measuring_unit_measuring_unit_type_id" ON "wms"."measuring_unit"
USING btree
("measuring_unit_type_id");
CREATE UNIQUE INDEX "ix_measuring_unit_name" ON "wms"."measuring_unit"
USING btree
("measuring_unit_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."measuring_unit" ADD CONSTRAINT "measuring_unit_pkey" PRIMARY KEY ("measuring_unit_id");
ALTER TABLE "wms"."location_weight_volume"
ADD CONSTRAINT "fk_location_weight_volume_measuring_unit" FOREIGN KEY ("weight_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_weight_volume"
ADD CONSTRAINT "fk_location_weight_volume_measuring_unit_2" FOREIGN KEY ("length_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_weight_volume"
ADD CONSTRAINT "fk_location_weight_volume_measuring_unit_3" FOREIGN KEY ("volume_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_weight_volume_facility_name" ON "wms"."location_weight_volume"
USING btree
("facility_id", "location_weight_volume_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."location_weight_volume" ADD CONSTRAINT "location_weight_volume_pkey" PRIMARY KEY ("location_weight_volume_id");
CREATE POLICY "rls_facility" ON "wms"."location_weight_volume"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."level"
ADD CONSTRAINT "fk_level_location_weight_volume" FOREIGN KEY ("location_weight_volume_id") REFERENCES "wms"."location_weight_volume" ("location_weight_volume_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."rack" (
	"rack_id"						integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"aisle_id"						integer					 NOT NULL,
	"rack_code"						character varying(100)	 NULL,
	"rack_status_id"				integer					 NULL,
	"location_weight_volume_id"		integer					 NULL,
	"location_rule_id"				integer					 NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."rack" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."rack"
ADD CONSTRAINT "fk_rack_aisle" FOREIGN KEY ("aisle_id") REFERENCES "wms"."aisle" ("aisle_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."rack"
ADD CONSTRAINT "fk_rack_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."rack"
ADD CONSTRAINT "fk_rack_location_weight_volume" FOREIGN KEY ("location_weight_volume_id") REFERENCES "wms"."location_weight_volume" ("location_weight_volume_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."rack_status" (
	"rack_status_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"rack_status_name"		character varying(256)	 NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_rack_status_name" ON "wms"."rack_status"
USING btree
("rack_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."rack_status" ADD CONSTRAINT "rack_status_pkey" PRIMARY KEY ("rack_status_id");
ALTER TABLE "wms"."rack"
ADD CONSTRAINT "fk_rack_rack_status" FOREIGN KEY ("rack_status_id") REFERENCES "wms"."rack_status" ("rack_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_rack" ON "wms"."rack"
USING btree
("aisle_id", "rack_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."rack" ADD CONSTRAINT "rack_pkey" PRIMARY KEY ("rack_id");
CREATE POLICY "rls_aisle" ON "wms"."rack"
FOR ALL
TO "public"
USING ((aisle_id IN ( SELECT a.aisle_id
   FROM (wms.user_facility uf
     JOIN wms.aisle a ON ((uf.facility_id = a.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."level"
ADD CONSTRAINT "fk_level_rack" FOREIGN KEY ("rack_id") REFERENCES "wms"."rack" ("rack_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_level" ON "wms"."level"
USING btree
("rack_id", "level_code" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."level" ADD CONSTRAINT "level_pkey" PRIMARY KEY ("level_id");
CREATE POLICY "rls_rack" ON "wms"."level"
FOR ALL
TO "public"
USING ((rack_id IN ( SELECT r.rack_id
   FROM ((wms.user_facility uf
     JOIN wms.aisle a ON ((uf.facility_id = a.facility_id)))
     JOIN wms.rack r ON ((r.aisle_id = a.aisle_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_level" FOREIGN KEY ("level_id") REFERENCES "wms"."level" ("level_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location_status" (
	"location_status_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_status_name"		character varying(256)	 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_location_status_name" ON "wms"."location_status"
USING btree
("location_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."location_status" ADD CONSTRAINT "location_status_pkey" PRIMARY KEY ("location_status_id");
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_location_status" FOREIGN KEY ("location_status_id") REFERENCES "wms"."location_status" ("location_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location_type" (
	"location_type_id"						integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_type_name"					character varying(256)	 NOT NULL,
	"location_type_description"				character varying(1024)	 NULL,
	"location_class_id"						integer					 NOT NULL,
	"aisles_required"						boolean					 NOT NULL,
	"location_weight_volume_id"				integer					 NOT NULL,
	"has_inbound_address"					boolean					 NOT NULL,
	"has_outbound_address"					boolean					 NOT NULL,
	"min_location_hierarchy_level_id"		integer					 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE TABLE "wms"."location_class" (
	"location_class_id"			integer					 NOT NULL,
	"location_class_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_class" ADD CONSTRAINT "location_class_pkey" PRIMARY KEY ("location_class_id");
ALTER TABLE "wms"."location_type"
ADD CONSTRAINT "fk_location_type_location_class" FOREIGN KEY ("location_class_id") REFERENCES "wms"."location_class" ("location_class_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."location_hierarchy_level" (
	"location_hierarchy_level_id"		integer					 NOT NULL,
	"location_hierarchy_level_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_hierarchy_level" ADD CONSTRAINT "location_hierarchy_level_pkey" PRIMARY KEY ("location_hierarchy_level_id");
ALTER TABLE "wms"."location_type"
ADD CONSTRAINT "fk_location_type_location_hierarchy_level" FOREIGN KEY ("min_location_hierarchy_level_id") REFERENCES "wms"."location_hierarchy_level" ("location_hierarchy_level_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_type"
ADD CONSTRAINT "fk_location_type_location_weight_volume" FOREIGN KEY ("location_weight_volume_id") REFERENCES "wms"."location_weight_volume" ("location_weight_volume_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_type_name" ON "wms"."location_type"
USING btree
("location_type_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."location_type" ADD CONSTRAINT "location_type_pkey" PRIMARY KEY ("location_type_id");
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_location_type" FOREIGN KEY ("location_type_id") REFERENCES "wms"."location_type" ("location_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_location_weight_volume" FOREIGN KEY ("location_weight_volume_id") REFERENCES "wms"."location_weight_volume" ("location_weight_volume_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_measuring_unit" FOREIGN KEY ("weight_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_measuring_unit_2" FOREIGN KEY ("length_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_measuring_unit_3" FOREIGN KEY ("volume_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_rack" FOREIGN KEY ("rack_id") REFERENCES "wms"."rack" ("rack_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location"
ADD CONSTRAINT "fk_location_zone" FOREIGN KEY ("zone_id") REFERENCES "wms"."zone" ("zone_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location" ON "wms"."location"
USING btree
("facility_id", "zone_id", "aisle_id", "rack_id", "level_id", "location_code" COLLATE "pg_catalog"."default");
CREATE INDEX "ix_location_aisle" ON "wms"."location"
USING btree
("aisle_id");
CREATE INDEX "ix_location_facility" ON "wms"."location"
USING btree
("facility_id");
CREATE INDEX "ix_location_level" ON "wms"."location"
USING btree
("level_id");
CREATE INDEX "ix_location_rack" ON "wms"."location"
USING btree
("rack_id");
CREATE INDEX "ix_location_zone" ON "wms"."location"
USING btree
("zone_id");
ALTER TABLE "wms"."location" ADD CONSTRAINT "location_pkey" PRIMARY KEY ("location_id");
CREATE POLICY "rls_facility" ON "wms"."location"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."advanced_shipping_notice"
ADD CONSTRAINT "fk_advanced_shipping_notice_location" FOREIGN KEY ("gate_location_id") REFERENCES "wms"."location" ("location_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice"
ADD CONSTRAINT "fk_advanced_shipping_notice_partner" FOREIGN KEY ("partner_id") REFERENCES "wms"."partner" ("partner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice" ADD CONSTRAINT "advanced_shipping_notice_pkey" PRIMARY KEY ("advanced_shipping_notice_id");
CREATE INDEX "ix_advanced_shipping_notice_date" ON "wms"."advanced_shipping_notice"
USING btree
("advanced_shipping_notice_date");
CREATE INDEX "ix_advanced_shipping_notice_facility_id" ON "wms"."advanced_shipping_notice"
USING btree
("facility_id");
CREATE INDEX "ix_advanced_shipping_notice_inbound_load_id" ON "wms"."advanced_shipping_notice"
USING btree
("inbound_load_id");
CREATE POLICY "rls_facility" ON "wms"."advanced_shipping_notice"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."advanced_shipping_notice_detail" (
	"advanced_shipping_notice_detail_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"advanced_shipping_notice_id"					integer					 NOT NULL,
	"stock_owner_id"								integer					 NOT NULL,
	"item_master_id"								integer					 NOT NULL,
	"item_sku_attribute_id"							integer					 NULL,
	"item_stock_attribute_id"						integer					 NULL,
	"planned_delivery_on"							timestamp with time zone NOT NULL,
	"gate_location_id"								integer					 NULL,
	"planned_quantity"								numeric(10, 3)			 NOT NULL,
	"received_quantity"								numeric(10, 3)			 NOT NULL,
	"purchase_order_detail_id"						integer					 NULL,
	"purchase_order_quantity"						numeric(10, 3)			 NULL,
	"advanced_shipping_notice_detail_status_id"		integer					 NOT NULL,
	"partner_id"									integer					 NULL,
	"partner_name"									character varying(256)	 NULL,
	"partner_address"								character varying(1024)	 NULL,
	"created_by"									integer					 NULL,
	"created_on"									timestamp with time zone NULL,
	"modified_by"									integer					 NULL,
	"modified_on"									timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."advanced_shipping_notice_detail" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."advanced_shipping_notice_detail" ALTER COLUMN "planned_quantity" SET STORAGE MAIN;

ALTER TABLE "wms"."advanced_shipping_notice_detail" ALTER COLUMN "received_quantity" SET STORAGE MAIN;

ALTER TABLE "wms"."advanced_shipping_notice_detail" ALTER COLUMN "purchase_order_quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_advanced_shipping_notice" FOREIGN KEY ("advanced_shipping_notice_id") REFERENCES "wms"."advanced_shipping_notice" ("advanced_shipping_notice_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."advanced_shipping_notice_detail_status" (
	"advanced_shipping_notice_detail_status_id"			integer					 NOT NULL,
	"advanced_shipping_notice_detail_status_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."advanced_shipping_notice_detail_status" ADD CONSTRAINT "advanced_shipping_notice_detail_status_pkey" PRIMARY KEY ("advanced_shipping_notice_detail_status_id");
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_asnds" FOREIGN KEY ("advanced_shipping_notice_detail_status_id") REFERENCES "wms"."advanced_shipping_notice_detail_status" ("advanced_shipping_notice_detail_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."item_master" (
	"item_master_id"					integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_code"							character varying(100)	 NOT NULL,
	"item_master_name"					character varying(256)	 NOT NULL,
	"item_master_description"			character varying(256)	 NOT NULL,
	"stock_owner_id"					integer					 NOT NULL,
	"product_class_id"					integer					 NOT NULL,
	"inventory_priority_id"				integer					 NOT NULL,
	"item_master_status_id"				integer					 NOT NULL,
	"measuring_unit_reference_id"		integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."inventory_priority" (
	"inventory_priority_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"inventory_priority_name"		character varying(256)	 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."inventory_priority" ADD CONSTRAINT "inventory_priority_pkey" PRIMARY KEY ("inventory_priority_id");
CREATE UNIQUE INDEX "ix_inventory_priority_name" ON "wms"."inventory_priority"
USING btree
("inventory_priority_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."item_master"
ADD CONSTRAINT "fk_item_master_inventory_priority" FOREIGN KEY ("inventory_priority_id") REFERENCES "wms"."inventory_priority" ("inventory_priority_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."item_master_status" (
	"item_master_status_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_status_name"		character varying(256)	 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_status" ADD CONSTRAINT "item_master_status_pkey" PRIMARY KEY ("item_master_status_id");
CREATE UNIQUE INDEX "ix_item_master_status_name" ON "wms"."item_master_status"
USING btree
("item_master_status_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."item_master"
ADD CONSTRAINT "fk_item_master_item_master_status" FOREIGN KEY ("item_master_status_id") REFERENCES "wms"."item_master_status" ("item_master_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master"
ADD CONSTRAINT "fk_item_master_measuring_unit" FOREIGN KEY ("measuring_unit_reference_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."product_class" (
	"product_class_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"product_class_name"	character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_product_class_name" ON "wms"."product_class"
USING btree
("product_class_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."product_class" ADD CONSTRAINT "product_class_pkey" PRIMARY KEY ("product_class_id");
ALTER TABLE "wms"."item_master"
ADD CONSTRAINT "fk_item_master_product_class" FOREIGN KEY ("product_class_id") REFERENCES "wms"."product_class" ("product_class_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master"
ADD CONSTRAINT "fk_item_master_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master" ADD CONSTRAINT "item_master_pkey" PRIMARY KEY ("item_master_id");
CREATE UNIQUE INDEX "ix_item_master_stock_owner_code" ON "wms"."item_master"
USING btree
("item_code" COLLATE "pg_catalog"."default", "stock_owner_id");
CREATE INDEX "ix_item_master_stock_owner_id" ON "wms"."item_master"
USING btree
("stock_owner_id");
CREATE POLICY "rls_stock_owner" ON "wms"."item_master"
FOR ALL
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."item_sku_attribute" (
	"item_sku_attribute_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"			integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_sku_attribute" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_sku_attribute"
ADD CONSTRAINT "fk_item_sku_attribute_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_sku_attribute" ADD CONSTRAINT "item_sku_attribute_pkey" PRIMARY KEY ("item_sku_attribute_id");
CREATE POLICY "rls_item_master" ON "wms"."item_sku_attribute"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_item_sku_attribute" FOREIGN KEY ("item_sku_attribute_id") REFERENCES "wms"."item_sku_attribute" ("item_sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."item_stock_attribute" (
	"item_stock_attribute_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"				integer					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_stock_attribute" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_stock_attribute"
ADD CONSTRAINT "fk_item_stock_attribute_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_stock_attribute" ADD CONSTRAINT "item_stock_attribute_pkey" PRIMARY KEY ("item_stock_attribute_id");
CREATE POLICY "rls_item_master" ON "wms"."item_stock_attribute"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_item_stock_attribute" FOREIGN KEY ("item_stock_attribute_id") REFERENCES "wms"."item_stock_attribute" ("item_stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_location" FOREIGN KEY ("gate_location_id") REFERENCES "wms"."location" ("location_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_partner" FOREIGN KEY ("partner_id") REFERENCES "wms"."partner" ("partner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."purchase_order_detail" (
	"purchase_order_detail_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"purchase_order_id"						integer					 NOT NULL,
	"item_master_id"						integer					 NOT NULL,
	"item_sku_attribute_id"					integer					 NULL,
	"item_stock_attribute_id"				integer					 NULL,
	"facility_id"							integer					 NOT NULL,
	"ordered_quantity"						numeric(10, 3)			 NOT NULL,
	"received_quantity"						numeric(10, 3)			 NOT NULL,
	"purchase_order_detail_status_id"		integer					 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."purchase_order_detail" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."purchase_order_detail" ALTER COLUMN "ordered_quantity" SET STORAGE MAIN;

ALTER TABLE "wms"."purchase_order_detail" ALTER COLUMN "received_quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_item_sku_attribute" FOREIGN KEY ("item_sku_attribute_id") REFERENCES "wms"."item_sku_attribute" ("item_sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_item_stock_attribute" FOREIGN KEY ("item_stock_attribute_id") REFERENCES "wms"."item_stock_attribute" ("item_stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."purchase_order" (
	"purchase_order_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_owner_id"				integer					 NOT NULL,
	"partner_id"					integer					 NOT NULL,
	"purchase_order_number"			character varying(256)	 NOT NULL,
	"purchase_order_date"			date					 NOT NULL,
	"purchase_order_status_id"		integer					 NOT NULL,
	"purchase_order_type_id"		integer					 NOT NULL,
	"additional_information"		character varying(1024)	 NULL,
	"free_text"						character varying(1024)	 NULL,
	"contract_number"				character varying(100)	 NULL,
	"partner_name"					character varying(256)	 NULL,
	"partner_address"				character varying(1024)	 NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."purchase_order" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."purchase_order"
ADD CONSTRAINT "fk_purchase_order_partner" FOREIGN KEY ("partner_id") REFERENCES "wms"."partner" ("partner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."purchase_order_status" (
	"purchase_order_status_id"		integer					 NOT NULL,
	"purchase_order_status_name"	character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."purchase_order_status" ADD CONSTRAINT "purchase_order_status_pkey" PRIMARY KEY ("purchase_order_status_id");
ALTER TABLE "wms"."purchase_order"
ADD CONSTRAINT "fk_purchase_order_purchase_order_status" FOREIGN KEY ("purchase_order_status_id") REFERENCES "wms"."purchase_order_status" ("purchase_order_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."purchase_order_type" (
	"purchase_order_type_id"		integer					 NOT NULL,
	"purchase_order_type_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."purchase_order_type" ADD CONSTRAINT "purchase_order_type_pkey" PRIMARY KEY ("purchase_order_type_id");
ALTER TABLE "wms"."purchase_order"
ADD CONSTRAINT "fk_purchase_order_purchase_order_type" FOREIGN KEY ("purchase_order_type_id") REFERENCES "wms"."purchase_order_type" ("purchase_order_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."purchase_order"
ADD CONSTRAINT "fk_purchase_order_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_purchase_order_date" ON "wms"."purchase_order"
USING btree
("purchase_order_date");
CREATE INDEX "ix_purchase_order_stock_owner_id" ON "wms"."purchase_order"
USING btree
("stock_owner_id");
ALTER TABLE "wms"."purchase_order" ADD CONSTRAINT "purchase_order_pkey" PRIMARY KEY ("purchase_order_id");
CREATE POLICY "rls_stock_owner" ON "wms"."purchase_order"
FOR ALL
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_purchase_order" FOREIGN KEY ("purchase_order_id") REFERENCES "wms"."purchase_order" ("purchase_order_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."purchase_order_detail_status" (
	"purchase_order_detail_status_id"		integer					 NOT NULL,
	"purchase_order_detail_status_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."purchase_order_detail_status" ADD CONSTRAINT "purchase_order_detail_status_pkey" PRIMARY KEY ("purchase_order_detail_status_id");
ALTER TABLE "wms"."purchase_order_detail"
ADD CONSTRAINT "fk_purchase_order_detail_purchase_order_detail_status" FOREIGN KEY ("purchase_order_detail_status_id") REFERENCES "wms"."purchase_order_detail_status" ("purchase_order_detail_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_purchase_order_detail_item_master_attributes" ON "wms"."purchase_order_detail"
USING btree
("item_master_id", "item_sku_attribute_id", "item_stock_attribute_id");
CREATE INDEX "ix_purchase_order_detail_purchase_order_id" ON "wms"."purchase_order_detail"
USING btree
("purchase_order_id");
ALTER TABLE "wms"."purchase_order_detail" ADD CONSTRAINT "purchase_order_detail_pkey" PRIMARY KEY ("purchase_order_detail_id");
CREATE POLICY "rls_facility_purchase_order" ON "wms"."purchase_order_detail"
FOR ALL
TO "public"
USING (((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))) AND (purchase_order_id IN ( SELECT po.purchase_order_id
   FROM (wms.user_stock_owner uso
     JOIN wms.purchase_order po ON ((uso.stock_owner_id = po.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer)))));
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_purchase_order_detail" FOREIGN KEY ("purchase_order_detail_id") REFERENCES "wms"."purchase_order_detail" ("purchase_order_detail_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice_detail"
ADD CONSTRAINT "fk_advanced_shipping_notice_detail_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."advanced_shipping_notice_detail" ADD CONSTRAINT "advanced_shipping_notice_detail_pkey" PRIMARY KEY ("advanced_shipping_notice_detail_id");
CREATE INDEX "ix_advanced_shipping_notice_detail_advanced_shipping_notice_id" ON "wms"."advanced_shipping_notice_detail"
USING btree
("advanced_shipping_notice_id");
CREATE INDEX "ix_advanced_shipping_notice_detail_item_master_attributes" ON "wms"."advanced_shipping_notice_detail"
USING btree
("item_master_id", "item_sku_attribute_id", "item_stock_attribute_id");
CREATE POLICY "rls_stock_owner_advanced_shipping_notice" ON "wms"."advanced_shipping_notice_detail"
FOR ALL
TO "public"
USING (((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))) AND (advanced_shipping_notice_id IN ( SELECT asn.advanced_shipping_notice_id
   FROM (wms.user_facility uf
     JOIN wms.advanced_shipping_notice asn ON ((uf.facility_id = asn.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer)))));
CREATE TABLE "wms"."application_translation" (
	"application_translation_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"application_translation_name_id"		integer					 NOT NULL,
	"message_key"							character varying(256)	 NOT NULL,
	"message_value"							character varying(256)	 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE TABLE "wms"."application_translation_name" (
	"application_translation_name_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"application_name"						character varying(256)	 NOT NULL,
	"language_id"							integer					 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."application_translation_name"
ADD CONSTRAINT "fk_application_translation_name_language" FOREIGN KEY ("language_id") REFERENCES "wms"."language" ("language_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."application_translation_name" ADD CONSTRAINT "application_translation_name_pkey" PRIMARY KEY ("application_translation_name_id");
CREATE UNIQUE INDEX "ix_application_translation_name" ON "wms"."application_translation_name"
USING btree
("application_name" COLLATE "pg_catalog"."default", "language_id");
ALTER TABLE "wms"."application_translation"
ADD CONSTRAINT "fk_application_translation_application_translation_name" FOREIGN KEY ("application_translation_name_id") REFERENCES "wms"."application_translation_name" ("application_translation_name_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."application_translation" ADD CONSTRAINT "application_translation_pkey" PRIMARY KEY ("application_translation_id");
CREATE UNIQUE INDEX "ix_application_translation" ON "wms"."application_translation"
USING btree
("application_translation_name_id", "message_key" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."attribute_data_option" (
	"attribute_data_option_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"attribute_data_type_id"		integer					 NOT NULL,
	"option_key"					character varying(256)	 NOT NULL,
	"option_text"					character varying(256)	 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE TABLE "wms"."attribute_data_type" (
	"attribute_data_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"attribute_data_type_name"		character varying(256)	 NOT NULL,
	"system_type_name"				character varying(256)	 NOT NULL,
	"has_options"					boolean					 NOT NULL,
	"is_system"						boolean					 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."attribute_data_type" ADD CONSTRAINT "attribute_data_type_pkey" PRIMARY KEY ("attribute_data_type_id");
CREATE UNIQUE INDEX "ix_attribute_data_type" ON "wms"."attribute_data_type"
USING btree
("attribute_data_type_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."attribute_data_option"
ADD CONSTRAINT "fk_attribute_data_option_attribute_data_type" FOREIGN KEY ("attribute_data_type_id") REFERENCES "wms"."attribute_data_type" ("attribute_data_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."attribute_data_option" ADD CONSTRAINT "attribute_data_option_pkey" PRIMARY KEY ("attribute_data_option_id");
CREATE UNIQUE INDEX "ix_attribute_data_option" ON "wms"."attribute_data_option"
USING btree
("attribute_data_type_id", "option_key" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."carrier" (
	"carrier_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_owner_id"			integer					 NOT NULL,
	"carrier_code"				character varying(256)	 NOT NULL,
	"carrier_type_id"			integer					 NOT NULL,
	"carrier_name"				character varying(256)	 NOT NULL,
	"address1"					character varying(256)	 NOT NULL,
	"address2"					character varying(256)	 NULL,
	"address3"					character varying(256)	 NULL,
	"city"						character varying(256)	 NOT NULL,
	"province"					character varying(256)	 NOT NULL,
	"country_id"				integer					 NOT NULL,
	"postal_code"				character varying(256)	 NULL,
	"phone"						character varying(100)	 NULL,
	"fax"						character varying(100)	 NULL,
	"telex"						character varying(100)	 NULL,
	"contact_person_name"		character varying(100)	 NULL,
	"edi_code"					character varying(100)	 NULL,
	"comments"					character varying(1024)	 NULL,
	"is_active"					boolean					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."carrier" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."carrier_type" (
	"carrier_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"carrier_type_name"		character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."carrier_type" ADD CONSTRAINT "carrier_type_pkey" PRIMARY KEY ("carrier_type_id");
CREATE UNIQUE INDEX "ix_carrier_type_name" ON "wms"."carrier_type"
USING btree
("carrier_type_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."carrier"
ADD CONSTRAINT "fk_carrier_carrier_type" FOREIGN KEY ("carrier_type_id") REFERENCES "wms"."carrier_type" ("carrier_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."carrier"
ADD CONSTRAINT "fk_carrier_country" FOREIGN KEY ("country_id") REFERENCES "wms"."country" ("country_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."carrier"
ADD CONSTRAINT "fk_carrier_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."carrier" ADD CONSTRAINT "carrier_pkey" PRIMARY KEY ("carrier_id");
CREATE INDEX "ix_carrier_carrier_name" ON "wms"."carrier"
USING btree
("carrier_name" COLLATE "pg_catalog"."default");
CREATE UNIQUE INDEX "ix_carrier_stock_owner_code" ON "wms"."carrier"
USING btree
("stock_owner_id", "carrier_code" COLLATE "pg_catalog"."default");
CREATE POLICY "rls_stock_owner" ON "wms"."carrier"
FOR ALL
TO "public"
USING ((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."condition" (
	"condition_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"condition_name"	character varying(256)	 NOT NULL,
	"is_available"		boolean					 NOT NULL,
	"created_by"		integer					 NULL,
	"created_on"		timestamp with time zone NULL,
	"modified_by"		integer					 NULL,
	"modified_on"		timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."condition" ADD CONSTRAINT "condition_pkey" PRIMARY KEY ("condition_id");
CREATE UNIQUE INDEX "ix_condition_name" ON "wms"."condition"
USING btree
("condition_name" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."container" (
	"container_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"container_state_id"		integer					 NOT NULL,
	"barcode"					character varying(100)	 NOT NULL,
	"stock_owner_id"			integer					 NOT NULL,
	"parent_container_id"		integer					 NULL,
	"location_id"				integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."container" ADD CONSTRAINT "container_pkey" PRIMARY KEY ("container_id");
ALTER TABLE "wms"."container"
ADD CONSTRAINT "fk_container_container" FOREIGN KEY ("parent_container_id") REFERENCES "wms"."container" ("container_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."container_state" (
	"container_state_id"		integer					 NOT NULL,
	"container_state_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."container_state" ADD CONSTRAINT "container_state_pkey" PRIMARY KEY ("container_state_id");
ALTER TABLE "wms"."container"
ADD CONSTRAINT "fk_container_container_state" FOREIGN KEY ("container_state_id") REFERENCES "wms"."container_state" ("container_state_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."container"
ADD CONSTRAINT "fk_container_location" FOREIGN KEY ("location_id") REFERENCES "wms"."location" ("location_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."container"
ADD CONSTRAINT "fk_container_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_container_barcode" ON "wms"."container"
USING btree
("barcode" COLLATE "pg_catalog"."default");
CREATE INDEX "ix_container_location_id" ON "wms"."container"
USING btree
("location_id");
CREATE INDEX "ix_container_stock_owner_id" ON "wms"."container"
USING btree
("stock_owner_id");
CREATE TABLE "wms"."container_document" (
	"container_document_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"container_id"				integer					 NOT NULL,
	"document_type_id"			integer					 NOT NULL,
	"related_document_id"		integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."container_document"
ADD CONSTRAINT "fk_container_document_container" FOREIGN KEY ("container_id") REFERENCES "wms"."container" ("container_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."document_type" (
	"document_type_id"		integer					 NOT NULL,
	"document_type_name"	character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."document_type" ADD CONSTRAINT "document_type_pkey" PRIMARY KEY ("document_type_id");
ALTER TABLE "wms"."container_document"
ADD CONSTRAINT "fk_container_document_document_type" FOREIGN KEY ("document_type_id") REFERENCES "wms"."document_type" ("document_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."container_document" ADD CONSTRAINT "container_document_pkey" PRIMARY KEY ("container_document_id");
CREATE UNIQUE INDEX "ix_container_document" ON "wms"."container_document"
USING btree
("container_id", "document_type_id", "related_document_id");
CREATE INDEX "ix_container_document_document" ON "wms"."container_document"
USING btree
("document_type_id", "related_document_id");
CREATE TABLE "wms"."container_file" (
	"container_file_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"container_id"			integer					 NOT NULL,
	"file_name"				character varying(256)	 NOT NULL,
	"file_size"				bigint					 NOT NULL,
	"relative_uri"			character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."container_file"
ADD CONSTRAINT "fk_container_file_container" FOREIGN KEY ("container_id") REFERENCES "wms"."container" ("container_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."container_file" ADD CONSTRAINT "container_file_pkey" PRIMARY KEY ("container_file_id");
CREATE UNIQUE INDEX "ix_container_file_container_id" ON "wms"."container_file"
USING btree
("container_id");
CREATE TABLE "wms"."data_translation" (
	"data_translation_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"data_translation_name_id"		integer					 NOT NULL,
	"language_id"					integer					 NOT NULL,
	"row_id"						integer					 NOT NULL,
	"translated_value"				character varying(256)	 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE TABLE "wms"."data_translation_name" (
	"data_translation_name_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"schema_name"					character varying(256)	 NOT NULL,
	"table_name"					character varying(256)	 NOT NULL,
	"column_name"					character varying(256)	 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."data_translation_name" ADD CONSTRAINT "data_translation_name_pkey" PRIMARY KEY ("data_translation_name_id");
CREATE UNIQUE INDEX "ix_data_translation_name" ON "wms"."data_translation_name"
USING btree
("schema_name" COLLATE "pg_catalog"."default", "table_name" COLLATE "pg_catalog"."default", "column_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."data_translation"
ADD CONSTRAINT "fk_data_translation_data_translation_name" FOREIGN KEY ("data_translation_name_id") REFERENCES "wms"."data_translation_name" ("data_translation_name_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."data_translation"
ADD CONSTRAINT "fk_data_translation_language" FOREIGN KEY ("language_id") REFERENCES "wms"."language" ("language_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."data_translation" ADD CONSTRAINT "data_translation_pkey" PRIMARY KEY ("data_translation_id");
CREATE UNIQUE INDEX "ix_data_translation" ON "wms"."data_translation"
USING btree
("data_translation_name_id", "language_id", "row_id");
CREATE TABLE "wms"."document_attribute" (
	"document_attribute_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"document_type_id"				integer					 NOT NULL,
	"document_attribute_name"		character varying(256)	 NOT NULL,
	"attribute_data_type_id"		integer					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."document_attribute"
ADD CONSTRAINT "fk_document_attribute_attribute_data_type" FOREIGN KEY ("attribute_data_type_id") REFERENCES "wms"."attribute_data_type" ("attribute_data_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."document_attribute"
ADD CONSTRAINT "fk_document_attribute_document_type" FOREIGN KEY ("document_type_id") REFERENCES "wms"."document_type" ("document_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."document_attribute" ADD CONSTRAINT "document_attribute_pkey" PRIMARY KEY ("document_attribute_id");
CREATE UNIQUE INDEX "ix_document_attribute" ON "wms"."document_attribute"
USING btree
("document_type_id", "document_attribute_name" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."document_attribute_value" (
	"document_attribute_value_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"document_type_id"					integer					 NOT NULL,
	"related_document_id"				integer					 NOT NULL,
	"document_attribute_id"				integer					 NOT NULL,
	"attribute_value"					character varying(256)	 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."document_attribute_value"
ADD CONSTRAINT "fk_document_attribute_value_document_attribute" FOREIGN KEY ("document_attribute_id") REFERENCES "wms"."document_attribute" ("document_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."document_attribute_value"
ADD CONSTRAINT "fk_document_attribute_value_document_type" FOREIGN KEY ("document_type_id") REFERENCES "wms"."document_type" ("document_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."document_attribute_value" ADD CONSTRAINT "document_attribute_value_pkey" PRIMARY KEY ("document_attribute_value_id");
CREATE UNIQUE INDEX "ix_document_attribute_value" ON "wms"."document_attribute_value"
USING btree
("document_type_id", "related_document_id", "document_attribute_id");
CREATE TABLE "wms"."facility_stock_owner" (
	"facility_stock_owner_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"facility_id"					integer					 NOT NULL,
	"stock_owner_id"				integer					 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."facility_stock_owner"
ADD CONSTRAINT "fk_facility_stock_owner_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."facility_stock_owner"
ADD CONSTRAINT "fk_facility_stock_owner_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."facility_stock_owner" ADD CONSTRAINT "facility_stock_owner_pkey" PRIMARY KEY ("facility_stock_owner_id");
CREATE UNIQUE INDEX "ix_facility_stock_owner" ON "wms"."facility_stock_owner"
USING btree
("facility_id", "stock_owner_id");
CREATE INDEX "ix_facility_stock_owner_stock_owner_id" ON "wms"."facility_stock_owner"
USING btree
("stock_owner_id");
CREATE TABLE "wms"."inbound_load_detail" (
	"inbound_load_detail_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"inbound_load_id"					integer					 NOT NULL,
	"facility_id"						integer					 NOT NULL,
	"planned_delivery_on"				timestamp with time zone NOT NULL,
	"actual_delivery_on"				timestamp with time zone NULL,
	"inbound_load_detail_status_id"		integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."inbound_load_detail" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."inbound_load_detail"
ADD CONSTRAINT "fk_inbound_load_detail_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."inbound_load_detail"
ADD CONSTRAINT "fk_inbound_load_detail_inbound_load" FOREIGN KEY ("inbound_load_id") REFERENCES "wms"."inbound_load" ("inbound_load_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."inbound_load_detail_status" (
	"inbound_load_detail_status_id"			integer					 NOT NULL,
	"inbound_load_detail_status_name"		character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."inbound_load_detail_status" ADD CONSTRAINT "inbound_load_detail_status_pkey" PRIMARY KEY ("inbound_load_detail_status_id");
ALTER TABLE "wms"."inbound_load_detail"
ADD CONSTRAINT "fk_inbound_load_detail_inbound_load_detail_status" FOREIGN KEY ("inbound_load_detail_status_id") REFERENCES "wms"."inbound_load_detail_status" ("inbound_load_detail_status_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."inbound_load_detail" ADD CONSTRAINT "inbound_load_detail_pkey" PRIMARY KEY ("inbound_load_detail_id");
CREATE UNIQUE INDEX "ix_inbound_load_detail" ON "wms"."inbound_load_detail"
USING btree
("inbound_load_id", "facility_id");
CREATE POLICY "rls_facility" ON "wms"."inbound_load_detail"
FOR ALL
TO "public"
USING ((facility_id IN ( SELECT uf.facility_id
   FROM wms.user_facility uf
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_barcode" (
	"item_master_barcode_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_footprint_detail_id"		integer					 NOT NULL,
	"barcode"								character varying(100)	 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_barcode" ENABLE ROW LEVEL SECURITY;

;
CREATE TABLE "wms"."item_master_footprint_detail" (
	"item_master_footprint_detail_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_footprint_id"				integer					 NOT NULL,
	"position"								integer					 NOT NULL,
	"parent_measuring_unit_id"				integer					 NOT NULL,
	"child_measuring_unit_id"				integer					 NOT NULL,
	"child_quantity"						numeric(10, 3)			 NOT NULL,
	"total_quantity"						numeric(10, 3)			 NOT NULL,
	"net_weight"							numeric(10, 3)			 NULL,
	"gross_weight"							numeric(10, 3)			 NULL,
	"tare_weight"							numeric(10, 3)			 NULL,
	"weight_measuring_unit_id"				integer					 NOT NULL,
	"net_width"								numeric(10, 3)			 NULL,
	"net_height"							numeric(10, 3)			 NULL,
	"net_depth"								numeric(10, 3)			 NULL,
	"gross_width"							numeric(10, 3)			 NULL,
	"gross_height"							numeric(10, 3)			 NULL,
	"gross_depth"							numeric(10, 3)			 NULL,
	"length_measuring_unit_id"				integer					 NOT NULL,
	"net_volume"							numeric(10, 3)			 NULL,
	"gross_volume"							numeric(10, 3)			 NULL,
	"volume_measuring_unit_id"				integer					 NOT NULL,
	"stack_ti"								integer					 NULL,
	"stack_hi"								integer					 NULL,
	"is_shippable"							boolean					 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_footprint_detail" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "child_quantity" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "total_quantity" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "net_weight" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "gross_weight" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "tare_weight" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "net_width" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "net_height" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "net_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "gross_width" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "gross_height" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "gross_depth" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "net_volume" SET STORAGE MAIN;

ALTER TABLE "wms"."item_master_footprint_detail" ALTER COLUMN "gross_volume" SET STORAGE MAIN;

;
CREATE TABLE "wms"."item_master_footprint" (
	"item_master_footprint_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"				integer					 NOT NULL,
	"footprint_name"				character varying(256)	 NOT NULL,
	"is_default"					boolean					 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_footprint" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_footprint"
ADD CONSTRAINT "fk_item_master_footprint_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint" ADD CONSTRAINT "item_master_footprint_pkey" PRIMARY KEY ("item_master_footprint_id");
CREATE UNIQUE INDEX "ix_item_master_footprint" ON "wms"."item_master_footprint"
USING btree
("item_master_id", "footprint_name" COLLATE "pg_catalog"."default");
CREATE INDEX "ix_item_master_footprint_item_master_id" ON "wms"."item_master_footprint"
USING btree
("item_master_id");
CREATE POLICY "rls_item_master" ON "wms"."item_master_footprint"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_item_master_footprint" FOREIGN KEY ("item_master_footprint_id") REFERENCES "wms"."item_master_footprint" ("item_master_footprint_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_measuring_unit" FOREIGN KEY ("parent_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_measuring_unit_2" FOREIGN KEY ("child_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_measuring_unit_3" FOREIGN KEY ("weight_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_measuring_unit_4" FOREIGN KEY ("length_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail"
ADD CONSTRAINT "fk_item_master_footprint_detail_measuring_unit_5" FOREIGN KEY ("volume_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_detail" ADD CONSTRAINT "item_master_footprint_detail_pkey" PRIMARY KEY ("item_master_footprint_detail_id");
CREATE UNIQUE INDEX "ix_item_master_footprint_detail" ON "wms"."item_master_footprint_detail"
USING btree
("item_master_footprint_id", "position");
CREATE UNIQUE INDEX "ix_item_master_footprint_detail_parent_child" ON "wms"."item_master_footprint_detail"
USING btree
("item_master_footprint_id", "parent_measuring_unit_id", "child_measuring_unit_id");
CREATE POLICY "rls_item_master_footprint" ON "wms"."item_master_footprint_detail"
FOR ALL
TO "public"
USING ((item_master_footprint_id IN ( SELECT imf.item_master_footprint_id
   FROM ((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_master_footprint imf ON ((im.item_master_id = imf.item_master_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
ALTER TABLE "wms"."item_master_barcode"
ADD CONSTRAINT "fk_item_master_barcode_item_master_footprint_detail" FOREIGN KEY ("item_master_footprint_detail_id") REFERENCES "wms"."item_master_footprint_detail" ("item_master_footprint_detail_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_barcode" ADD CONSTRAINT "item_master_barcode_pkey" PRIMARY KEY ("item_master_barcode_id");
CREATE UNIQUE INDEX "ix_item_master_barcode" ON "wms"."item_master_barcode"
USING btree
("item_master_footprint_detail_id", "barcode" COLLATE "pg_catalog"."default");
CREATE INDEX "ix_item_master_barcode_barcode" ON "wms"."item_master_barcode"
USING btree
("barcode" COLLATE "pg_catalog"."default");
CREATE POLICY "rls_item_master_footprint_detail" ON "wms"."item_master_barcode"
FOR ALL
TO "public"
USING ((item_master_footprint_detail_id IN ( SELECT imfd.item_master_footprint_detail_id
   FROM (((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_master_footprint imf ON ((im.item_master_id = imf.item_master_id)))
     JOIN wms.item_master_footprint_detail imfd ON ((imf.item_master_footprint_id = imfd.item_master_footprint_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_facility" (
	"item_master_facility_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"				integer					 NOT NULL,
	"facility_id"					integer					 NOT NULL,
	"is_active"						boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_facility"
ADD CONSTRAINT "fk_item_master_facility_facility" FOREIGN KEY ("facility_id") REFERENCES "wms"."facility" ("facility_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_facility"
ADD CONSTRAINT "fk_item_master_facility_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_facility" ADD CONSTRAINT "item_master_facility_pkey" PRIMARY KEY ("item_master_facility_id");
CREATE UNIQUE INDEX "ix_item_master_facility" ON "wms"."item_master_facility"
USING btree
("item_master_id", "facility_id");
CREATE INDEX "ix_item_master_facility_facility_id" ON "wms"."item_master_facility"
USING btree
("facility_id");
CREATE TABLE "wms"."item_master_file" (
	"item_master_file_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"			integer					 NOT NULL,
	"file_name"					character varying(256)	 NOT NULL,
	"file_size"					bigint					 NOT NULL,
	"relative_uri"				character varying(256)	 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_file" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_file"
ADD CONSTRAINT "fk_item_master_file_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_file" ADD CONSTRAINT "item_master_file_pkey" PRIMARY KEY ("item_master_file_id");
CREATE INDEX "ix_item_master_file_item_master_id" ON "wms"."item_master_file"
USING btree
("item_master_id");
CREATE POLICY "rls_item_master" ON "wms"."item_master_file"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_footprint_file" (
	"item_master_footprint_file_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_footprint_detail_id"		integer					 NOT NULL,
	"file_name"								character varying(256)	 NOT NULL,
	"file_size"								bigint					 NOT NULL,
	"relative_uri"							character varying(256)	 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_footprint_file" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_footprint_file"
ADD CONSTRAINT "fk_item_master_footprint_file_item_master_footprint_detail" FOREIGN KEY ("item_master_footprint_detail_id") REFERENCES "wms"."item_master_footprint_detail" ("item_master_footprint_detail_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_file" ADD CONSTRAINT "item_master_footprint_file_pkey" PRIMARY KEY ("item_master_footprint_file_id");
CREATE INDEX "ix_item_master_footprint_file_item_master_footprint_detail_id" ON "wms"."item_master_footprint_file"
USING btree
("item_master_footprint_detail_id");
CREATE POLICY "rls_item_master_footprint_detail" ON "wms"."item_master_footprint_file"
FOR ALL
TO "public"
USING ((item_master_footprint_detail_id IN ( SELECT imfd.item_master_footprint_detail_id
   FROM (((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_master_footprint imf ON ((im.item_master_id = imf.item_master_id)))
     JOIN wms.item_master_footprint_detail imfd ON ((imf.item_master_footprint_id = imfd.item_master_footprint_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_footprint_packaging" (
	"item_master_footprint_packaging_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_footprint_detail_id"		integer					 NOT NULL,
	"packaging_type_id"						integer					 NOT NULL,
	"quantity"								numeric(10, 3)			 NOT NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_footprint_packaging" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "wms"."item_master_footprint_packaging" ALTER COLUMN "quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."item_master_footprint_packaging"
ADD CONSTRAINT "fk_item_master_footprint_packaging_item_master_footprint_detail" FOREIGN KEY ("item_master_footprint_detail_id") REFERENCES "wms"."item_master_footprint_detail" ("item_master_footprint_detail_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."packaging_type" (
	"packaging_type_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"packaging_type_name"			character varying(256)	 NOT NULL,
	"weight"						numeric(10, 3)			 NOT NULL,
	"weight_measuring_unit_id"		integer					 NOT NULL,
	"width"							numeric(10, 3)			 NOT NULL,
	"height"						numeric(10, 3)			 NOT NULL,
	"depth"							numeric(10, 3)			 NOT NULL,
	"length_measuring_unit_id"		integer					 NOT NULL,
	"volume"						numeric(10, 3)			 NOT NULL,
	"volume_measuring_unit_id"		integer					 NOT NULL,
	"is_closed_packaging"			boolean					 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."packaging_type" ALTER COLUMN "weight" SET STORAGE MAIN;

ALTER TABLE "wms"."packaging_type" ALTER COLUMN "width" SET STORAGE MAIN;

ALTER TABLE "wms"."packaging_type" ALTER COLUMN "height" SET STORAGE MAIN;

ALTER TABLE "wms"."packaging_type" ALTER COLUMN "depth" SET STORAGE MAIN;

ALTER TABLE "wms"."packaging_type" ALTER COLUMN "volume" SET STORAGE MAIN;

;
ALTER TABLE "wms"."packaging_type"
ADD CONSTRAINT "fk_packaging_type_measuring_unit" FOREIGN KEY ("weight_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."packaging_type"
ADD CONSTRAINT "fk_packaging_type_measuring_unit_2" FOREIGN KEY ("length_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."packaging_type"
ADD CONSTRAINT "fk_packaging_type_measuring_unit_3" FOREIGN KEY ("volume_measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."packaging_type" ADD CONSTRAINT "packaging_type_pkey" PRIMARY KEY ("packaging_type_id");
ALTER TABLE "wms"."item_master_footprint_packaging"
ADD CONSTRAINT "fk_item_master_footprint_packaging_packaging_type" FOREIGN KEY ("packaging_type_id") REFERENCES "wms"."packaging_type" ("packaging_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_footprint_packaging" ADD CONSTRAINT "item_master_footprint_packaging_pkey" PRIMARY KEY ("item_master_footprint_packaging_id");
CREATE UNIQUE INDEX "ix_item_master_footprint_packaging" ON "wms"."item_master_footprint_packaging"
USING btree
("item_master_footprint_detail_id", "packaging_type_id");
CREATE POLICY "rls_item_master_footprint_detail" ON "wms"."item_master_footprint_packaging"
FOR ALL
TO "public"
USING ((item_master_footprint_detail_id IN ( SELECT imfd.item_master_footprint_detail_id
   FROM (((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_master_footprint imf ON ((im.item_master_id = imf.item_master_id)))
     JOIN wms.item_master_footprint_detail imfd ON ((imf.item_master_footprint_id = imfd.item_master_footprint_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_putaway_type" (
	"item_master_putaway_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"					integer					 NOT NULL,
	"putaway_type_id"					integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_putaway_type" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_putaway_type"
ADD CONSTRAINT "fk_item_master_putaway_type_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."putaway_type" (
	"putaway_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"putaway_type_name"		character varying(256)	 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_putaway_type_name" ON "wms"."putaway_type"
USING btree
("putaway_type_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."putaway_type" ADD CONSTRAINT "putaway_type_pkey" PRIMARY KEY ("putaway_type_id");
ALTER TABLE "wms"."item_master_putaway_type"
ADD CONSTRAINT "fk_item_master_putaway_type_putaway_type" FOREIGN KEY ("putaway_type_id") REFERENCES "wms"."putaway_type" ("putaway_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_putaway_type" ADD CONSTRAINT "item_master_putaway_type_pkey" PRIMARY KEY ("item_master_putaway_type_id");
CREATE UNIQUE INDEX "ix_item_master_putaway_type" ON "wms"."item_master_putaway_type"
USING btree
("item_master_id", "putaway_type_id");
CREATE POLICY "rls_item_master" ON "wms"."item_master_putaway_type"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_sku_attribute" (
	"item_master_sku_attribute_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"					integer					 NOT NULL,
	"sku_attribute_id"					integer					 NOT NULL,
	"default_value"						character varying(256)	 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_sku_attribute" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_sku_attribute"
ADD CONSTRAINT "fk_item_master_sku_attribute_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."sku_attribute" (
	"sku_attribute_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"sku_attribute_name"		character varying(256)	 NOT NULL,
	"attribute_data_type_id"	integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."sku_attribute"
ADD CONSTRAINT "fk_sku_attribute_attribute_data_type" FOREIGN KEY ("attribute_data_type_id") REFERENCES "wms"."attribute_data_type" ("attribute_data_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."sku_attribute" ADD CONSTRAINT "sku_attribute_pkey" PRIMARY KEY ("sku_attribute_id");
ALTER TABLE "wms"."sku_attribute"
ADD CONSTRAINT "fk_sku_attribute_sku_attribute" FOREIGN KEY ("sku_attribute_id") REFERENCES "wms"."sku_attribute" ("sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_sku_attribute_name" ON "wms"."sku_attribute"
USING btree
("sku_attribute_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."item_master_sku_attribute"
ADD CONSTRAINT "fk_item_master_sku_attribute_sku_attribute" FOREIGN KEY ("sku_attribute_id") REFERENCES "wms"."sku_attribute" ("sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_sku_attribute" ADD CONSTRAINT "item_master_sku_attribute_pkey" PRIMARY KEY ("item_master_sku_attribute_id");
CREATE UNIQUE INDEX "ix_item_master_sku_attribute" ON "wms"."item_master_sku_attribute"
USING btree
("item_master_id", "sku_attribute_id");
CREATE POLICY "rls_item_master" ON "wms"."item_master_sku_attribute"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_master_stock_attribute" (
	"item_master_stock_attribute_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"					integer					 NOT NULL,
	"stock_attribute_id"				integer					 NOT NULL,
	"default_value"						character varying(256)	 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_master_stock_attribute" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_master_stock_attribute"
ADD CONSTRAINT "fk_item_master_stock_attribute_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."stock_attribute" (
	"stock_attribute_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_attribute_name"		character varying(256)	 NOT NULL,
	"attribute_data_type_id"	integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_attribute"
ADD CONSTRAINT "fk_stock_attribute_attribute_data_type" FOREIGN KEY ("attribute_data_type_id") REFERENCES "wms"."attribute_data_type" ("attribute_data_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_stock_attribute_name" ON "wms"."stock_attribute"
USING btree
("stock_attribute_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."stock_attribute" ADD CONSTRAINT "stock_attribute_pkey" PRIMARY KEY ("stock_attribute_id");
ALTER TABLE "wms"."item_master_stock_attribute"
ADD CONSTRAINT "fk_item_master_stock_attribute_stock_attribute" FOREIGN KEY ("stock_attribute_id") REFERENCES "wms"."stock_attribute" ("stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_master_stock_attribute" ADD CONSTRAINT "item_master_stock_attribute_pkey" PRIMARY KEY ("item_master_stock_attribute_id");
CREATE UNIQUE INDEX "ix_item_master_stock_attribute" ON "wms"."item_master_stock_attribute"
USING btree
("item_master_id", "stock_attribute_id");
CREATE POLICY "rls_item_master" ON "wms"."item_master_stock_attribute"
FOR ALL
TO "public"
USING ((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_sku_attribute_value" (
	"item_sku_attribute_value_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_sku_attribute_id"				integer					 NOT NULL,
	"sku_attribute_id"					integer					 NOT NULL,
	"attribute_value"					character varying(256)	 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_sku_attribute_value" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_sku_attribute_value"
ADD CONSTRAINT "fk_item_sku_attribute_value_item_sku_attribute" FOREIGN KEY ("item_sku_attribute_id") REFERENCES "wms"."item_sku_attribute" ("item_sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_sku_attribute_value"
ADD CONSTRAINT "fk_item_sku_attribute_value_sku_attribute" FOREIGN KEY ("sku_attribute_id") REFERENCES "wms"."sku_attribute" ("sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_sku_attribute_value" ADD CONSTRAINT "item_sku_attribute_value_pkey" PRIMARY KEY ("item_sku_attribute_value_id");
CREATE UNIQUE INDEX "ix_item_sku_attribute_value" ON "wms"."item_sku_attribute_value"
USING btree
("item_sku_attribute_id", "sku_attribute_id");
CREATE POLICY "rls_item_sku_attribute" ON "wms"."item_sku_attribute_value"
FOR ALL
TO "public"
USING ((item_sku_attribute_id IN ( SELECT isa.item_sku_attribute_id
   FROM ((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_sku_attribute isa ON ((im.item_master_id = isa.item_master_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."item_stock_attribute_value" (
	"item_stock_attribute_value_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_stock_attribute_id"			integer					 NOT NULL,
	"stock_attribute_id"				integer					 NOT NULL,
	"attribute_value"					character varying(256)	 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."item_stock_attribute_value" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."item_stock_attribute_value"
ADD CONSTRAINT "fk_item_stock_attribute_value_item_stock_attribute" FOREIGN KEY ("item_stock_attribute_id") REFERENCES "wms"."item_stock_attribute" ("item_stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_stock_attribute_value"
ADD CONSTRAINT "fk_item_stock_attribute_value_stock_attribute" FOREIGN KEY ("stock_attribute_id") REFERENCES "wms"."stock_attribute" ("stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."item_stock_attribute_value" ADD CONSTRAINT "item_stock_attribute_value_pkey" PRIMARY KEY ("item_stock_attribute_value_id");
CREATE UNIQUE INDEX "ix_item_stock_attribute_value" ON "wms"."item_stock_attribute_value"
USING btree
("item_stock_attribute_id", "stock_attribute_id");
CREATE POLICY "rls_item_stock_attribute" ON "wms"."item_stock_attribute_value"
FOR ALL
TO "public"
USING ((item_stock_attribute_id IN ( SELECT isa.item_stock_attribute_id
   FROM ((wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
     JOIN wms.item_stock_attribute isa ON ((im.item_master_id = isa.item_master_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."location_rule_item_master" (
	"location_rule_item_master_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_rule_id"					integer					 NOT NULL,
	"item_master_id"					integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule_item_master" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule_item_master"
ADD CONSTRAINT "fk_location_rule_item_master_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_rule_item_master"
ADD CONSTRAINT "fk_location_rule_item_master_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_rule_item_master" ON "wms"."location_rule_item_master"
USING btree
("location_rule_id", "item_master_id");
ALTER TABLE "wms"."location_rule_item_master" ADD CONSTRAINT "location_rule_item_master_pkey" PRIMARY KEY ("location_rule_item_master_id");
CREATE POLICY "rls_location_rule_item_master" ON "wms"."location_rule_item_master"
FOR ALL
TO "public"
USING (((item_master_id IN ( SELECT im.item_master_id
   FROM (wms.user_stock_owner uso
     JOIN wms.item_master im ON ((uso.stock_owner_id = im.stock_owner_id)))
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))) AND (location_rule_id IN ( SELECT lr.location_rule_id
   FROM (wms.user_facility uf
     JOIN wms.location_rule lr ON ((uf.facility_id = lr.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer)))));
CREATE TABLE "wms"."location_rule_product_class" (
	"location_rule_product_class_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_rule_id"					integer					 NOT NULL,
	"product_class_id"					integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule_product_class" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule_product_class"
ADD CONSTRAINT "fk_location_rule_product_class_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_rule_product_class"
ADD CONSTRAINT "fk_location_rule_product_class_product_class" FOREIGN KEY ("product_class_id") REFERENCES "wms"."product_class" ("product_class_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_rule_product_class" ON "wms"."location_rule_product_class"
USING btree
("location_rule_id", "product_class_id");
ALTER TABLE "wms"."location_rule_product_class" ADD CONSTRAINT "location_rule_product_class_pkey" PRIMARY KEY ("location_rule_product_class_id");
CREATE POLICY "rls_location_rule" ON "wms"."location_rule_product_class"
FOR ALL
TO "public"
USING ((location_rule_id IN ( SELECT lr.location_rule_id
   FROM (wms.user_facility uf
     JOIN wms.location_rule lr ON ((uf.facility_id = lr.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."location_rule_putaway_type" (
	"location_rule_putaway_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_rule_id"					integer					 NOT NULL,
	"putaway_type_id"					integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule_putaway_type" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule_putaway_type"
ADD CONSTRAINT "fk_location_rule_putaway_type_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_rule_putaway_type"
ADD CONSTRAINT "fk_location_rule_putaway_type_putaway_type" FOREIGN KEY ("putaway_type_id") REFERENCES "wms"."putaway_type" ("putaway_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_rule_putaway_type" ON "wms"."location_rule_putaway_type"
USING btree
("location_rule_id", "putaway_type_id");
ALTER TABLE "wms"."location_rule_putaway_type" ADD CONSTRAINT "location_rule_putaway_type_pkey" PRIMARY KEY ("location_rule_putaway_type_id");
CREATE POLICY "rls_location_rule" ON "wms"."location_rule_putaway_type"
FOR ALL
TO "public"
USING ((location_rule_id IN ( SELECT lr.location_rule_id
   FROM (wms.user_facility uf
     JOIN wms.location_rule lr ON ((uf.facility_id = lr.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."location_rule_stock_operation_type" (
	"location_rule_stock_operation_type_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_rule_id"							integer					 NOT NULL,
	"stock_operation_type_id"					integer					 NOT NULL,
	"created_by"								integer					 NULL,
	"created_on"								timestamp with time zone NULL,
	"modified_by"								integer					 NULL,
	"modified_on"								timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule_stock_operation_type" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule_stock_operation_type"
ADD CONSTRAINT "fk_location_rule_stock_operation_type_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."stock_operation_type" (
	"stock_operation_type_id"		integer					 NOT NULL,
	"stock_operation_name"			character varying(256)	 NOT NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_operation_type" ADD CONSTRAINT "stock_operation_type_pkey" PRIMARY KEY ("stock_operation_type_id");
ALTER TABLE "wms"."location_rule_stock_operation_type"
ADD CONSTRAINT "fk_location_rule_stock_operation_type_stock_operation_type" FOREIGN KEY ("stock_operation_type_id") REFERENCES "wms"."stock_operation_type" ("stock_operation_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_rule_stock_operation_type" ON "wms"."location_rule_stock_operation_type"
USING btree
("location_rule_id", "stock_operation_type_id");
ALTER TABLE "wms"."location_rule_stock_operation_type" ADD CONSTRAINT "location_rule_stock_operation_type_pkey" PRIMARY KEY ("location_rule_stock_operation_type_id");
CREATE POLICY "rls_location_rule" ON "wms"."location_rule_stock_operation_type"
FOR ALL
TO "public"
USING ((location_rule_id IN ( SELECT lr.location_rule_id
   FROM (wms.user_facility uf
     JOIN wms.location_rule lr ON ((uf.facility_id = lr.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer))));
CREATE TABLE "wms"."location_rule_stock_owner" (
	"location_rule_stock_owner_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"location_rule_id"					integer					 NOT NULL,
	"stock_owner_id"					integer					 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."location_rule_stock_owner" ENABLE ROW LEVEL SECURITY;

;
ALTER TABLE "wms"."location_rule_stock_owner"
ADD CONSTRAINT "fk_location_rule_stock_owner_location_rule" FOREIGN KEY ("location_rule_id") REFERENCES "wms"."location_rule" ("location_rule_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."location_rule_stock_owner"
ADD CONSTRAINT "fk_location_rule_stock_owner_stock_owner" FOREIGN KEY ("stock_owner_id") REFERENCES "wms"."stock_owner" ("stock_owner_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_location_rule_stock_owner" ON "wms"."location_rule_stock_owner"
USING btree
("location_rule_id", "stock_owner_id");
CREATE INDEX "ix_location_rule_stock_owner_stock_owner_id" ON "wms"."location_rule_stock_owner"
USING btree
("stock_owner_id");
ALTER TABLE "wms"."location_rule_stock_owner" ADD CONSTRAINT "location_rule_stock_owner_pkey" PRIMARY KEY ("location_rule_stock_owner_id");
CREATE POLICY "rls_location_rule_stock_owner" ON "wms"."location_rule_stock_owner"
FOR ALL
TO "public"
USING (((stock_owner_id IN ( SELECT uso.stock_owner_id
   FROM wms.user_stock_owner uso
  WHERE (uso.user_id = (current_setting('wms.user_id'::text, true))::integer))) AND (location_rule_id IN ( SELECT lr.location_rule_id
   FROM (wms.user_facility uf
     JOIN wms.location_rule lr ON ((uf.facility_id = lr.facility_id)))
  WHERE (uf.user_id = (current_setting('wms.user_id'::text, true))::integer)))));
CREATE TABLE "wms"."measuring_unit_conversion" (
	"measuring_unit_conversion_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"measuring_unit_source_id"			integer					 NOT NULL,
	"measuring_unit_destination_id"		integer					 NOT NULL,
	"factor"							double precision		 NOT NULL,
	"created_by"						integer					 NULL,
	"created_on"						timestamp with time zone NULL,
	"modified_by"						integer					 NULL,
	"modified_on"						timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."measuring_unit_conversion"
ADD CONSTRAINT "fk_measuring_unit_conversion_measuring_unit" FOREIGN KEY ("measuring_unit_source_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."measuring_unit_conversion"
ADD CONSTRAINT "fk_measuring_unit_conversion_measuring_unit_2" FOREIGN KEY ("measuring_unit_destination_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_measuring_unit_conversion" ON "wms"."measuring_unit_conversion"
USING btree
("measuring_unit_source_id", "measuring_unit_destination_id");
ALTER TABLE "wms"."measuring_unit_conversion" ADD CONSTRAINT "measuring_unit_conversion_pkey" PRIMARY KEY ("measuring_unit_conversion_id");
CREATE TABLE "wms"."migration" (
	"migration_id"		integer					 NOT NULL,
	"migration_name"	character varying(50)	 NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."migration" ADD CONSTRAINT "migration_pkey" PRIMARY KEY ("migration_id");
CREATE TABLE "wms"."permission" (
	"permission_id"				integer					 NOT NULL,
	"permission_name"			character varying(256)	 NOT NULL,
	"permission_key"			character varying(256)	 NOT NULL,
	"permission_parent_id"		integer					 NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."permission" ADD CONSTRAINT "permission_pkey" PRIMARY KEY ("permission_id");
ALTER TABLE "wms"."permission"
ADD CONSTRAINT "fk_permission_permission" FOREIGN KEY ("permission_parent_id") REFERENCES "wms"."permission" ("permission_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_permission_permission_key" ON "wms"."permission"
USING btree
("permission_key" COLLATE "pg_catalog"."default");
CREATE TABLE "wms"."role" (
	"role_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"role_name"			character varying(256)	 NOT NULL,
	"created_by"		integer					 NULL,
	"created_on"		timestamp with time zone NULL,
	"modified_by"		integer					 NULL,
	"modified_on"		timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_role_name" ON "wms"."role"
USING btree
("role_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."role" ADD CONSTRAINT "role_pkey" PRIMARY KEY ("role_id");
CREATE TABLE "wms"."role_permission" (
	"role_permission_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"role_id"				integer					 NOT NULL,
	"permission_id"			integer					 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."role_permission"
ADD CONSTRAINT "fk_role_permission_permission" FOREIGN KEY ("permission_id") REFERENCES "wms"."permission" ("permission_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."role_permission"
ADD CONSTRAINT "fk_role_permission_role" FOREIGN KEY ("role_id") REFERENCES "wms"."role" ("role_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_role_permission" ON "wms"."role_permission"
USING btree
("role_id", "permission_id");
ALTER TABLE "wms"."role_permission" ADD CONSTRAINT "role_permission_pkey" PRIMARY KEY ("role_permission_id");
CREATE TABLE "wms"."security_group" (
	"security_group_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"security_group_name"		character varying(256)	 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
CREATE UNIQUE INDEX "ix_security_group" ON "wms"."security_group"
USING btree
("security_group_name" COLLATE "pg_catalog"."default");
ALTER TABLE "wms"."security_group" ADD CONSTRAINT "security_group_pkey" PRIMARY KEY ("security_group_id");
CREATE TABLE "wms"."security_group_role" (
	"security_group_role_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"security_group_id"			integer					 NOT NULL,
	"role_id"					integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."security_group_role"
ADD CONSTRAINT "fk_security_group_role_role" FOREIGN KEY ("role_id") REFERENCES "wms"."role" ("role_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."security_group_role"
ADD CONSTRAINT "fk_security_group_role_security_group" FOREIGN KEY ("security_group_id") REFERENCES "wms"."security_group" ("security_group_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_security_group_role" ON "wms"."security_group_role"
USING btree
("security_group_id", "role_id");
ALTER TABLE "wms"."security_group_role" ADD CONSTRAINT "security_group_role_pkey" PRIMARY KEY ("security_group_role_id");
CREATE TABLE "wms"."stock" (
	"stock_id"								integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"item_master_id"						integer					 NOT NULL,
	"item_sku_attribute_id"					integer					 NULL,
	"item_stock_attribute_id"				integer					 NULL,
	"location_id"							integer					 NOT NULL,
	"stock_state_id"						integer					 NOT NULL,
	"quantity"								numeric(10, 3)			 NOT NULL,
	"item_master_footprint_detail_id"		integer					 NOT NULL,
	"container_id"							integer					 NULL,
	"created_by"							integer					 NULL,
	"created_on"							timestamp with time zone NULL,
	"modified_by"							integer					 NULL,
	"modified_on"							timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock" ALTER COLUMN "quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_container" FOREIGN KEY ("container_id") REFERENCES "wms"."container" ("container_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_item_master" FOREIGN KEY ("item_master_id") REFERENCES "wms"."item_master" ("item_master_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_item_master_footprint_detail" FOREIGN KEY ("item_master_footprint_detail_id") REFERENCES "wms"."item_master_footprint_detail" ("item_master_footprint_detail_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_item_sku_attribute" FOREIGN KEY ("item_sku_attribute_id") REFERENCES "wms"."item_sku_attribute" ("item_sku_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_item_stock_attribute" FOREIGN KEY ("item_stock_attribute_id") REFERENCES "wms"."item_stock_attribute" ("item_stock_attribute_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_location" FOREIGN KEY ("location_id") REFERENCES "wms"."location" ("location_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE TABLE "wms"."stock_state" (
	"stock_state_id"		integer					 NOT NULL,
	"stock_state_name"		character varying(256)	 NOT NULL,
	"is_available"			boolean					 NOT NULL DEFAULT false
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_state" ADD CONSTRAINT "stock_state_pkey" PRIMARY KEY ("stock_state_id");
ALTER TABLE "wms"."stock"
ADD CONSTRAINT "fk_stock_stock_state" FOREIGN KEY ("stock_state_id") REFERENCES "wms"."stock_state" ("stock_state_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_stock_container_id" ON "wms"."stock"
USING btree
("container_id");
CREATE INDEX "ix_stock_item_master_attributes" ON "wms"."stock"
USING btree
("item_master_id", "item_sku_attribute_id", "item_stock_attribute_id");
CREATE INDEX "ix_stock_location_id" ON "wms"."stock"
USING btree
("location_id");
ALTER TABLE "wms"."stock" ADD CONSTRAINT "stock_pkey" PRIMARY KEY ("stock_id");
CREATE TABLE "wms"."stock_condition" (
	"stock_condition_id"	integer					 NOT NULL,
	"stock_id"				integer					 NOT NULL,
	"condition_id"			integer					 NOT NULL,
	"created_by"			integer					 NULL,
	"created_on"			timestamp with time zone NULL,
	"modified_by"			integer					 NULL,
	"modified_on"			timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_condition"
ADD CONSTRAINT "fk_stock_condition_condition" FOREIGN KEY ("condition_id") REFERENCES "wms"."condition" ("condition_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock_condition"
ADD CONSTRAINT "fk_stock_condition_stock" FOREIGN KEY ("stock_id") REFERENCES "wms"."stock" ("stock_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_stock_condition" ON "wms"."stock_condition"
USING btree
("stock_id", "condition_id");
ALTER TABLE "wms"."stock_condition" ADD CONSTRAINT "stock_condition_pkey" PRIMARY KEY ("stock_condition_id");
CREATE TABLE "wms"."stock_operation" (
	"stock_operation_id"			integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"stock_id"						integer					 NOT NULL,
	"stock_operation_type_id"		integer					 NOT NULL,
	"related_operation_id"			integer					 NOT NULL,
	"stock_state_before_id"			integer					 NULL,
	"stock_state_after_id"			integer					 NOT NULL,
	"quantity"						numeric(10, 3)			 NOT NULL,
	"created_by"					integer					 NULL,
	"created_on"					timestamp with time zone NULL,
	"modified_by"					integer					 NULL,
	"modified_on"					timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."stock_operation" ALTER COLUMN "quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."stock_operation"
ADD CONSTRAINT "fk_stock_operation_stock" FOREIGN KEY ("stock_id") REFERENCES "wms"."stock" ("stock_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock_operation"
ADD CONSTRAINT "fk_stock_operation_stock_operation_type" FOREIGN KEY ("stock_operation_type_id") REFERENCES "wms"."stock_operation_type" ("stock_operation_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock_operation"
ADD CONSTRAINT "fk_stock_operation_stock_state" FOREIGN KEY ("stock_state_before_id") REFERENCES "wms"."stock_state" ("stock_state_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."stock_operation"
ADD CONSTRAINT "fk_stock_operation_stock_state_2" FOREIGN KEY ("stock_state_after_id") REFERENCES "wms"."stock_state" ("stock_state_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX "ix_stock_operation_stock_id" ON "wms"."stock_operation"
USING btree
("stock_id");
ALTER TABLE "wms"."stock_operation" ADD CONSTRAINT "stock_operation_pkey" PRIMARY KEY ("stock_operation_id");
CREATE TABLE "wms"."tenant" (
	"tenant_id"			integer					 NOT NULL,
	"tenant_name"		character varying(256)	 NOT NULL,
	"language_id"		integer					 NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."tenant"
ADD CONSTRAINT "fk_tenant_language" FOREIGN KEY ("language_id") REFERENCES "wms"."language" ("language_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."tenant" ADD CONSTRAINT "tenant_pkey" PRIMARY KEY ("tenant_id");
CREATE TABLE "wms"."unloading" (
	"unloading_id"				integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"document_type_id"			integer					 NOT NULL,
	"related_document_id"		integer					 NOT NULL,
	"start_date"				timestamp with time zone NOT NULL,
	"stop_date"					timestamp with time zone NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."unloading"
ADD CONSTRAINT "fk_unloading_document_type" FOREIGN KEY ("document_type_id") REFERENCES "wms"."document_type" ("document_type_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_unloading" ON "wms"."unloading"
USING btree
("document_type_id", "related_document_id", "start_date");
ALTER TABLE "wms"."unloading" ADD CONSTRAINT "unloading_pkey" PRIMARY KEY ("unloading_id");
CREATE TABLE "wms"."unloading_detail" (
	"unloading_detail_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"unloading_id"				integer					 NOT NULL,
	"measuring_unit_id"			integer					 NOT NULL,
	"quantity"					numeric(10, 3)			 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."unloading_detail" ALTER COLUMN "quantity" SET STORAGE MAIN;

;
ALTER TABLE "wms"."unloading_detail"
ADD CONSTRAINT "fk_unloading_detail_measuring_unit" FOREIGN KEY ("measuring_unit_id") REFERENCES "wms"."measuring_unit" ("measuring_unit_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."unloading_detail"
ADD CONSTRAINT "fk_unloading_detail_unloading" FOREIGN KEY ("unloading_id") REFERENCES "wms"."unloading" ("unloading_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_unloading_detail" ON "wms"."unloading_detail"
USING btree
("unloading_id", "measuring_unit_id");
ALTER TABLE "wms"."unloading_detail" ADD CONSTRAINT "unloading_detail_pkey" PRIMARY KEY ("unloading_detail_id");
CREATE TABLE "wms"."user_role" (
	"user_role_id"		integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"user_id"			integer					 NOT NULL,
	"role_id"			integer					 NOT NULL,
	"created_by"		integer					 NULL,
	"created_on"		timestamp with time zone NULL,
	"modified_by"		integer					 NULL,
	"modified_on"		timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."user_role"
ADD CONSTRAINT "fk_user_role_role" FOREIGN KEY ("role_id") REFERENCES "wms"."role" ("role_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."user_role"
ADD CONSTRAINT "fk_user_role_user" FOREIGN KEY ("user_id") REFERENCES "wms"."user" ("user_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_user_role" ON "wms"."user_role"
USING btree
("user_id", "role_id");
ALTER TABLE "wms"."user_role" ADD CONSTRAINT "user_role_pkey" PRIMARY KEY ("user_role_id");
CREATE TABLE "wms"."user_security_group" (
	"user_security_group_id"	integer					 GENERATED ALWAYS AS IDENTITY NOT NULL,
	"user_id"					integer					 NOT NULL,
	"security_group_id"			integer					 NOT NULL,
	"created_by"				integer					 NULL,
	"created_on"				timestamp with time zone NULL,
	"modified_by"				integer					 NULL,
	"modified_on"				timestamp with time zone NULL
)
WITH (OIDS = FALSE);
ALTER TABLE "wms"."user_security_group"
ADD CONSTRAINT "fk_user_security_group_security_group" FOREIGN KEY ("security_group_id") REFERENCES "wms"."security_group" ("security_group_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "wms"."user_security_group"
ADD CONSTRAINT "fk_user_security_group_user" FOREIGN KEY ("user_id") REFERENCES "wms"."user" ("user_id")
 ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE UNIQUE INDEX "ix_user_security_group" ON "wms"."user_security_group"
USING btree
("user_id", "security_group_id");
ALTER TABLE "wms"."user_security_group" ADD CONSTRAINT "user_security_group_pkey" PRIMARY KEY ("user_security_group_id");

COMMIT TRANSACTION;

