CREATE FUNCTION "wms"."getstockattributevalues"(IN "p_item_stock_attribute_id" integer)
RETURNS character varying
LANGUAGE plpgsql STABLE
COST 100
AS $BODY$
declareBEGIN TRANSACTION;

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
CREATE FUNCTION "wms"."convert_units"(IN "value" numeric, IN "p_measuring_unit_source_id" integer, IN "p_measuring_unit_destination_id" integer)
RETURNS integer
LANGUAGE plpgsql STABLE
COST 100
AS $BODY$
declare
	v_converted_value integer;
begin
	if (p_measuring_unit_source_id = p_measuring_unit_destination_id) then
		return value;
	else
		begin
			select factor*value 
			into v_converted_value
			from wms.measuring_unit_conversion muc
			where measuring_unit_source_id = p_measuring_unit_source_id
			and measuring_unit_destination_id = p_measuring_unit_destination_id;
		exception when no_data_found then
			v_converted_value := null;
		end;
	end if;

	-- If translation is not available, or the current language_id is not set, use the default value
	return v_converted_value;
end;
$BODY$;
CREATE FUNCTION "wms"."translate_row"(IN "table_name" character varying, IN "column_name" character varying, IN "row_id" integer, IN "default_value" character varying)
RETURNS character varying
LANGUAGE plpgsql STABLE
COST 100
AS $BODY$
declare
	v_language_id integer;
	v_translated_value character varying(256);
begin
	v_language_id := nullif(current_setting('wms.language_id', true), '');
	
	if ($1 is not null) and ($2 is not null) and ($3 is not null) and (v_language_id is not null) then

		-- Get the translated value for the given row, column and table
		select
			dt.translated_value
		into
			v_translated_value
		from
			wms.data_translation dt
		inner join
			wms.data_translation_name dtn
		on
			dt.data_translation_name_id = dtn.data_translation_name_id
		where
			dtn.schema_name = 'wms'
			and dtn.table_name = $1
			and dtn.column_name = $2
			and dt.language_id = v_language_id
			and dt.row_id = $3;

	end if;
		
	-- If translation is not available, or the current language_id is not set, use the default value
	return coalesce(v_translated_value, $4);
end;
$BODY$;
CREATE FUNCTION "wms"."getskuattributevalues"(IN "p_item_sku_attribute_id" integer)
RETURNS character varying
LANGUAGE plpgsql STABLE
COST 100
AS $BODY$
declare
	v_sku_attribute character varying(500);
begin
	if (p_item_sku_attribute_id is null) then
		return null;
	else
		begin
			
			select string_agg(attr,', ')
			into v_sku_attribute
			from
			(select wms.translate_row('sku_attribute','sku_attribute_name',sa.sku_attribute_id,sa.sku_attribute_name)||':'||isav.attribute_value as attr
			from 
			wms.item_Sku_attribute_value isav
			inner join
			wms.Sku_attribute sa
			on sa.Sku_attribute_id = isav.Sku_attribute_id
			and isav.item_Sku_attribute_id = p_item_Sku_attribute_id
			order by sa.Sku_attribute_name
			) a;
			
		end;
	end if;

	return v_sku_attribute;
end;
$BODY$;
CREATE FUNCTION "wms"."getstockattributevalues"(IN "p_item_stock_attribute_id" integer)
RETURNS character varying
LANGUAGE plpgsql STABLE
COST 100
AS $BODY$
declare
	v_stock_attribute character varying(500);
begin
	if (p_item_stock_attribute_id is null) then
		return null;
	else
		begin
			
			select string_agg(attr,', ')
			into v_stock_attribute
			from
			(select wms.translate_row('stock_attribute','stock_attribute_name',sa.stock_attribute_id,sa.stock_attribute_name)||':'||isav.attribute_value as attr
			from 
			wms.item_stock_attribute_value isav
			inner join
			wms.stock_attribute sa
			on sa.stock_attribute_id = isav.stock_attribute_id
			and isav.item_stock_attribute_id = p_item_stock_attribute_id
			order by sa.stock_attribute_name
			) a;
			
		end;
	end if;

	return v_stock_attribute;
end;
$BODY$;
CREATE FUNCTION "wms"."translate_table"(IN "table_name" character varying, IN "column_name" character varying)
RETURNS TABLE(row_id integer, translated_value character varying)
LANGUAGE plpgsql STABLE
COST 100
ROWS 1000
AS $BODY$
declare
	v_language_id integer;
	v_data_translation_name_id integer;
begin
	v_language_id := nullif(current_setting('wms.language_id', true), '');
	if v_language_id is not null then
		
		select
			dtn.data_translation_name_id
		into
			v_data_translation_name_id
		from
			wms.data_translation_name dtn
		where
			dtn.schema_name = 'wms'
			and dtn.table_name = $1
			and dtn.column_name = $2;

		return query
		select
			dt.row_id,
			dt.translated_value
		from
			wms.data_translation dt
		where
			dt.data_translation_name_id = v_data_translation_name_id
			and dt.language_id = v_language_id;	
	end if;
end;
$BODY$;


-- Post-deployment script Data\wms.measuring_unit_system.sql
insert into
	wms.measuring_unit_system
	(
		measuring_unit_system_id,
		measuring_unit_system_name		
	)
select
	t.measuring_unit_system_id, 
	t.measuring_unit_system_name
from
(
	values
	(1, 'Metric'),
	(2, 'Imperial')
) t (measuring_unit_system_id, measuring_unit_system_name)

on conflict(measuring_unit_system_id) do update
set
	measuring_unit_system_name = excluded.measuring_unit_system_name
;


-- Post-deployment script Data\wms.language.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.language) then
		
		insert into 
			wms.language
			(
				language_name,
				language_code
			)
		values
		('English', 'en');
		
	end if;
end $$;


-- Post-deployment script Data\wms.facility_type.sql
insert into
	wms.facility_type
	(
		facility_type_id,
		facility_type_name
	)
select
	t.facility_type_id, 
	t.facility_type_name
from
(
	values
	(1, 'Warehouse'),
	(2, 'Distribution center')
) t (facility_type_id, facility_type_name)

on conflict(facility_type_id) do update
set
	facility_type_name = excluded.facility_type_name
;


-- Post-deployment script Data\wms.country.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.country) then
		
	insert into 
		wms.country
		(
		country_name,
		alpha2_code,
		alpha3_code
		)
	values
('Afghanistan', 'AF', 'AFG'),
('Åland Islands', 'AX', 'ALA'),
('Albania', 'AL', 'ALB'),
('Algeria', 'DZ', 'DZA'),
('American Samoa', 'AS', 'ASM'),
('Andorra', 'AD', 'AND'),
('Angola', 'AO', 'AGO'),
('Anguilla', 'AI', 'AIA'),
('Antarctica', 'AQ', 'ATA'),
('Antigua and Barbuda', 'AG', 'ATG'),
('Argentina', 'AR', 'ARG'),
('Armenia', 'AM', 'ARM'),
('Aruba', 'AW', 'ABW'),
('Australia', 'AU', 'AUS'),
('Austria', 'AT', 'AUT'),
('Azerbaijan', 'AZ', 'AZE'),
('Bahamas', 'BS', 'BHS'),
('Bahrain', 'BH', 'BHR'),
('Bangladesh', 'BD', 'BGD'),
('Barbados', 'BB', 'BRB'),
('Belarus', 'BY', 'BLR'),
('Belgium', 'BE', 'BEL'),
('Belize', 'BZ', 'BLZ'),
('Benin', 'BJ', 'BEN'),
('Bermuda', 'BM', 'BMU'),
('Bhutan', 'BT', 'BTN'),
('Bolivia', 'BO', 'BOL'),
('Bonaire, Sint Eustatius and Saba', 'BQ', 'BES'),
('Bosnia and Herzegovina', 'BA', 'BIH'),
('Botswana', 'BW', 'BWA'),
('Brazil', 'BR', 'BRA'),
('British Indian Ocean Territory', 'IO', 'IOT'),
('Brunei Darussalam', 'BN', 'BRN'),
('Bulgaria', 'BG', 'BGR'),
('Burkina Faso', 'BF', 'BFA'),
('Burundi', 'BI', 'BDI'),
('Cambodia', 'KH', 'KHM'),
('Cameroon', 'CM', 'CMR'),
('Canada', 'CA', 'CAN'),
('Cape Verde', 'CV', 'CPV'),
('Cayman Islands', 'KY', 'CYM'),
('Central African Republic', 'CF', 'CAF'),
('Chad', 'TD', 'TCD'),
('Chile', 'CL', 'CHL'),
('China', 'CN', 'CHN'),
('Christmas Island', 'CX', 'CXR'),
('Cocos (Keeling) Islands', 'CC', 'CCK'),
('Colombia', 'CO', 'COL'),
('Comoros', 'KM', 'COM'),
('Congo', 'CG', 'COD'),
('Congo, The Democratic Republic of the', 'CD', 'COG'),
('Cook Islands', 'CK', 'COK'),
('Costa Rica', 'CR', 'CRI'),
('Côte d''Ivoire', 'CI', 'CIV'),
('Croatia', 'HR', 'HRV'),
('Cuba', 'CU', 'CUB'),
('Curaçao', 'CW', 'CUW'),
('Cyprus', 'CY', 'CYP'),
('Czech Republic', 'CZ', 'CZE'),
('Denmark', 'DK', 'DNK'),
('Djibouti', 'DJ', 'DJI'),
('Dominica', 'DM', 'DMA'),
('Dominican Republic', 'DO', 'DOM'),
('Ecuador', 'EC', 'ECU'),
('Egypt', 'EG', 'EGY'),
('El Salvador', 'SV', 'SLV'),
('Equatorial Guinea', 'GQ', 'GNQ'),
('Eritrea', 'ER', 'ERI'),
('Estonia', 'EE', 'EST'),
('Eswatini', 'SZ', 'SWZ'),
('Ethiopia', 'ET', 'ETH'),
('Falkland Islands (Malvinas)', 'FK', 'FLK'),
('Faroe Islands', 'FO', 'FRO'),
('Fiji', 'FJ', 'FJI'),
('Finland', 'FI', 'FIN'),
('France', 'FR', 'FRA'),
('French Guiana', 'GF', 'GUF'),
('French Polynesia', 'PF', 'PYF'),
('French Southern Territories', 'TF', 'ATF'),
('Gabon', 'GA', 'GAB'),
('Gambia', 'GM', 'GMB'),
('Georgia', 'GE', 'GEO'),
('Germany', 'DE', 'DEU'),
('Ghana', 'GH', 'GHA'),
('Gibraltar', 'GI', 'GIB'),
('Greece', 'GR', 'GRC'),
('Greenland', 'GL', 'GRL'),
('Grenada', 'GD', 'GRD'),
('Guadeloupe', 'GP', 'GLP'),
('Guam', 'GU', 'GUM'),
('Guatemala', 'GT', 'GTM'),
('Guernsey', 'GG', 'GGY'),
('Guinea', 'GN', 'GIN'),
('Guinea-Bissau', 'GW', 'GNB'),
('Guyana', 'GY', 'GUY'),
('Haiti', 'HT', 'HTI'),
('Heard Island and McDonald Islands', 'HM', 'HMD'),
('Holy See (Vatican City State)', 'VA', 'VAT'),
('Honduras', 'HN', 'HND'),
('Hong Kong', 'HK', 'HKG'),
('Hungary', 'HU', 'HUN'),
('Iceland', 'IS', 'ISL'),
('India', 'IN', 'IND'),
('Indonesia', 'ID', 'IDN'),
('Installations in International Waters', 'XZ', ''),
('Iran, Islamic Republic of', 'IR', 'IRN'),
('Iraq', 'IQ', 'IRQ'),
('Ireland', 'IE', 'IRL'),
('Isle of Man', 'IM', 'IMN'),
('Israel', 'IL', 'ISR'),
('Italy', 'IT', 'ITA'),
('Jamaica', 'JM', 'JAM'),
('Japan', 'JP', 'JPN'),
('Jersey', 'JE', 'JEY'),
('Jordan', 'JO', 'JOR'),
('Kazakhstan', 'KZ', 'KAZ'),
('Kenya', 'KE', 'KEN'),
('Kiribati', 'KI', 'KIR'),
('Korea, Democratic People''s Republic of', 'KP', 'PRK'),
('Korea, Republic of', 'KR', 'KOR'),
('Kuwait', 'KW', 'KWT'),
('Kyrgyzstan', 'KG', 'KGZ'),
('Lao People''s Democratic Republic', 'LA', 'LAO'),
('Latvia', 'LV', 'LVA'),
('Lebanon', 'LB', 'LBN'),
('Lesotho', 'LS', 'LSO'),
('Liberia', 'LR', 'LBR'),
('Libya', 'LY', 'LBY'),
('Liechtenstein', 'LI', 'LIE'),
('Lithuania', 'LT', 'LTU'),
('Luxembourg', 'LU', 'LUX'),
('Macao', 'MO', 'MAC'),
('Madagascar', 'MG', 'MDG'),
('Malawi', 'MW', 'MWI'),
('Malaysia', 'MY', 'MYS'),
('Maldives', 'MV', 'MDV'),
('Mali', 'ML', 'MLI'),
('Malta', 'MT', 'MLT'),
('Marshall Islands', 'MH', 'MHL'),
('Martinique', 'MQ', 'MTQ'),
('Mauritania', 'MR', 'MRT'),
('Mauritius', 'MU', 'MUS'),
('Mayotte', 'YT', 'MYT'),
('Mexico', 'MX', 'MEX'),
('Micronesia, Federated States of', 'FM', 'FSM'),
('Moldova, Republic of', 'MD', 'MDA'),
('Monaco', 'MC', 'MCO'),
('Mongolia', 'MN', 'MNG'),
('Montenegro', 'ME', 'MNE'),
('Montserrat', 'MS', 'MSR'),
('Morocco', 'MA', 'MAR'),
('Mozambique', 'MZ', 'MOZ'),
('Myanmar', 'MM', 'MMR'),
('Namibia', 'NA', 'NAM'),
('Nauru', 'NR', 'NRU'),
('Nepal', 'NP', 'NPL'),
('Netherlands', 'NL', 'NLD'),
('New Caledonia', 'NC', 'NCL'),
('New Zealand', 'NZ', 'NZL'),
('Nicaragua', 'NI', 'NIC'),
('Niger', 'NE', 'NER'),
('Nigeria', 'NG', 'NGA'),
('Niue', 'NU', 'NIU'),
('Norfolk Island', 'NF', 'NFK'),
('North Macedonia', 'MK', 'MKD'),
('Northern Mariana Islands', 'MP', 'MNP'),
('Norway', 'NO', 'NOR'),
('Oman', 'OM', 'OMN'),
('Pakistan', 'PK', 'PAK'),
('Palau', 'PW', 'PLW'),
('Palestine, State of', 'PS', 'PSE'),
('Panama', 'PA', 'PAN'),
('Papua New Guinea', 'PG', 'PNG'),
('Paraguay', 'PY', 'PRY'),
('Peru', 'PE', 'PER'),
('Philippines', 'PH', 'PHL'),
('Pitcairn', 'PN', 'PCN'),
('Poland', 'PL', 'POL'),
('Portugal', 'PT', 'PRT'),
('Puerto Rico', 'PR', 'PRI'),
('Qatar', 'QA', 'QAT'),
('Reunion', 'RE', 'REU'),
('Romania', 'RO', 'ROU'),
('Russian Federation', 'RU', 'RUS'),
('Rwanda', 'RW', 'RWA'),
('Saint Barthélemy', 'BL', 'BLM'),
('Saint Helena, Ascension and Tristan Da Cunha', 'SH', 'SHN'),
('Saint Kitts and Nevis', 'KN', 'KNA'),
('Saint Lucia', 'LC', 'LCA'),
('Saint Martin (French Part)', 'MF', 'MAF'),
('Saint Pierre and Miquelon', 'PM', 'SPM'),
('Saint Vincent and the Grenadines', 'VC', 'VCT'),
('Samoa', 'WS', 'WSM'),
('San Marino', 'SM', 'SMR'),
('Sao Tome and Principe', 'ST', 'STP'),
('Saudi Arabia', 'SA', 'SAU'),
('Senegal', 'SN', 'SEN'),
('Serbia', 'RS', 'SRB'),
('Seychelles', 'SC', 'SYC'),
('Sierra Leone', 'SL', 'SLE'),
('Singapore', 'SG', 'SGP'),
('Sint Maarten (Dutch Part)', 'SX', 'SXM'),
('Slovakia', 'SK', 'SVK'),
('Slovenia', 'SI', 'SVN'),
('Solomon Islands', 'SB', 'SLB'),
('Somalia', 'SO', 'SOM'),
('South Africa', 'ZA', 'ZAF'),
('South Georgia and the South Sandwich Islands', 'GS', 'SGS'),
('South Sudan', 'SS', 'SSD'),
('Spain', 'ES', 'ESP'),
('Sri Lanka', 'LK', 'LKA'),
('Sudan', 'SD', 'SDN'),
('Suriname', 'SR', 'SUR'),
('Svalbard and Jan Mayen', 'SJ', 'SJM'),
('Sweden', 'SE', 'SWE'),
('Switzerland', 'CH', 'CHE'),
('Syrian Arab Republic', 'SY', 'SYR'),
('Taiwan, Province of China', 'TW', 'TWN'),
('Tajikistan', 'TJ', 'TJK'),
('Tanzania, United Republic of', 'TZ', 'TZA'),
('Thailand', 'TH', 'THA'),
('Timor-Leste', 'TL', 'TLS'),
('Togo', 'TG', 'TGO'),
('Tokelau', 'TK', 'TKL'),
('Tonga', 'TO', 'TON'),
('Trinidad and Tobago', 'TT', 'TTO'),
('Tunisia', 'TN', 'TUN'),
('Türkiye', 'TR', 'TUR'),
('Turkmenistan', 'TM', 'TKM'),
('Turks and Caicos Islands', 'TC', 'TCA'),
('Tuvalu', 'TV', 'TUV'),
('Uganda', 'UG', 'UGA'),
('Ukraine', 'UA', 'UKR'),
('United Arab Emirates', 'AE', 'ARE'),
('United Kingdom', 'GB', 'GBR'),
('United States    [A to E]    [F to J]    [K to O]    [P to T]    [U to Z]', 'US', 'UMI'),
('United States Minor Outlying Islands', 'UM', 'USA'),
('Uruguay', 'UY', 'URY'),
('Uzbekistan', 'UZ', 'UZB'),
('Vanuatu', 'VU', 'VUT'),
('Venezuela', 'VE', 'VEN'),
('Viet Nam', 'VN', 'VNM'),
('Virgin Islands, British', 'VG', 'VGB'),
('Virgin Islands, U.S.', 'VI', 'VIR'),
('Wallis and Futuna', 'WF', 'WLF'),
('Western Sahara', 'EH', 'ESH'),
('Yemen', 'YE', 'YEM'),
('Zambia', 'ZM', 'ZMB'),
('Zimbabwe', 'ZW', 'ZWE');

		
	end if;
end $$;


-- Post-deployment script Data\wms.zone_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.zone_status
	(
		zone_status_id,
		zone_status_name
	)
overriding system value 
select
	t.zone_status_id, 
	t.zone_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (zone_status_id, zone_status_name)

on conflict(zone_status_id) do update
set
	zone_status_name = excluded.zone_status_name
;

do $$ 
begin
	if not exists (select * from wms.zone_status where zone_status_id >= 101) then
		alter table wms.zone_status alter column zone_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.measuring_unit_type.sql
insert into
	wms.measuring_unit_type
	(
		measuring_unit_type_id,
		measuring_unit_type_name
	)
select
	t.measuring_unit_type_id, 
	t.measuring_unit_type_name
from
(
	values
	(1, 'Weight'),
	(2, 'Length'),
	(3, 'Volume'),
	(4, 'Logistic')
) t (measuring_unit_type_id, measuring_unit_type_name)

on conflict(measuring_unit_type_id) do update
set
	measuring_unit_type_name = excluded.measuring_unit_type_name
;


-- Post-deployment script Data\wms.measuring_unit.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.measuring_unit) then
		
		insert into 
			wms.measuring_unit
			(
				measuring_unit_name,
				measuring_unit_abbreviation,
				measuring_unit_system_id,
				measuring_unit_type_id
			)
		values
		('Miligram', 'mg', 1, 1),
		('Gram', 'g', 1, 1),
		('Kilogram', 'kg', 1, 1),
		('Tonne', 't', 1, 1),
		
		('Millimeter', 'mm', 1, 2),
		('Centimeter', 'cm', 1, 2),
		('Decimeter', 'dm', 1, 2),
		('Meter', 'm', 1, 2),
		('Decameter', 'dam', 1, 2),
		('Hectometer', 'ham', 1, 2),
		('Kilometer', 'km', 1, 2),
		
		('Cubic millimeter', 'mm3', 1, 3),
		('Cubic centimeter', 'cm3', 1, 3),
		('Cubic decimeter', 'dm3', 1, 3),
		('Cubic meter', 'm3', 1, 3),
		('Cubic decameter', 'dam3', 1, 3),
		('Cubic hectometer', 'ham3', 1, 3),
		('Cubic kilometer', 'km3', 1, 3),
		
		('Millilitre', 'ml', 1, 3),
		('Centilitre', 'cl', 1, 3),
		('Decilitre', 'dl', 1, 3),
		('Litre', 'l', 1, 3),
		('Decalitre', 'dal', 1, 3),
		('Hectolitre', 'hal', 1, 3),
		('Kilolitre', 'kl', 1, 3);
		
	end if;
end $$;


-- Post-deployment script Data\wms.aisle_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.aisle_status
	(
		aisle_status_id,
		aisle_status_name
	)
overriding system value 
select
	t.aisle_status_id, 
	t.aisle_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (aisle_status_id, aisle_status_name)

on conflict(aisle_status_id) do update
set
	aisle_status_name = excluded.aisle_status_name
;

do $$ 
begin
	if not exists (select * from wms.aisle_status where aisle_status_id >= 101) then
		alter table wms.aisle_status alter column aisle_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.aisle_direction.sql
insert into
	wms.aisle_direction
	(
		aisle_direction_id,
		aisle_direction_name
	)
select
	t.aisle_direction_id, 
	t.aisle_direction_name
from
(
	values
	(1, 'One way'),
	(2, 'Two way')
) t (aisle_direction_id, aisle_direction_name)

on conflict(aisle_direction_id) do update
set
	aisle_direction_name = excluded.aisle_direction_name
;


-- Post-deployment script Data\wms.rack_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.rack_status
	(
		rack_status_id,
		rack_status_name
	)
overriding system value 
select
	t.rack_status_id, 
	t.rack_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (rack_status_id, rack_status_name)

on conflict(rack_status_id) do update
set
	rack_status_name = excluded.rack_status_name
;

do $$ 
begin
	if not exists (select * from wms.rack_status where rack_status_id >= 101) then
		alter table wms.rack_status alter column rack_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.product_class.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.product_class) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.location_hierarchy_level.sql
insert into
	wms.location_hierarchy_level
	(
		location_hierarchy_level_id,
		location_hierarchy_level_name
	)
select
	t.location_hierarchy_level_id, 
	t.location_hierarchy_level_name
from
(
	values
	(1, 'Zone'),
	(2, 'Aisle'),
	(3, 'Rack'),
	(4, 'Level'),
	(5, 'Location')
) t (location_hierarchy_level_id, location_hierarchy_level_name)

on conflict(location_hierarchy_level_id) do update
set
	location_hierarchy_level_name = excluded.location_hierarchy_level_name
;


-- Post-deployment script Data\wms.location_class.sql
insert into
	wms.location_class
	(
		location_class_id,
		location_class_name
	)
select
	t.location_class_id, 
	t.location_class_name
from
(
	values
	(1, 'Bin'),
	(2, 'Floor area'),
	(3, 'Door'),
	(4, 'Parking')
) t (location_class_id, location_class_name)

on conflict(location_class_id) do update
set
	location_class_name = excluded.location_class_name
;


-- Post-deployment script Data\wms.level_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.level_status
	(
		level_status_id,
		level_status_name
	)
overriding system value 
select
	t.level_status_id, 
	t.level_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (level_status_id, level_status_name)

on conflict(level_status_id) do update
set
	level_status_name = excluded.level_status_name
;

do $$ 
begin
	if not exists (select * from wms.level_status where level_status_id >= 101) then
		alter table wms.level_status alter column level_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.item_master_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.item_master_status
	(
		item_master_status_id,
		item_master_status_name
	)
overriding system value 
select
	t.item_master_status_id, 
	t.item_master_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (item_master_status_id, item_master_status_name)

on conflict(item_master_status_id) do update
set
	item_master_status_name = excluded.item_master_status_name
;

do $$ 
begin
	if not exists (select * from wms.item_master_status where item_master_status_id >= 101) then
		alter table wms.item_master_status alter column item_master_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.inventory_priority.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.inventory_priority) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.timezone.sql
insert into
	wms.timezone
	(
		time_zone_id,
		time_zone_code,
		time_zone_name,
		time_zone_offset
	)
select
	t.time_zone_id, 
	t.time_zone_code,
	t.time_zone_name,
	t.time_zone_offset
from
(
	values
	(1, 'Dateline Standard Time', 'International Date Line West (UTC-12:00)', -12),
	(2, 'UTC-11', 'Coordinated Universal Time-11 (UTC-11:00)', -11),
	(3, 'Aleutian Standard Time', 'Aleutian Islands (UTC-10:00)', -10),
	(4, 'Hawaiian Standard Time', 'Hawaii (UTC-10:00)', -10),
	(5, 'Marquesas Standard Time', 'Marquesas Islands (UTC-09:30)', -9.5),
	(6, 'Alaskan Standard Time', 'Alaska (UTC-09:00)', -9),
	(7, 'UTC-09', 'Coordinated Universal Time-09 (UTC-09:00)', -9),
	(8, 'Pacific Standard Time (Mexico)', 'Baja California (UTC-08:00)', -8),
	(9, 'UTC-08', 'Coordinated Universal Time-08 (UTC-08:00)', -8),
	(10, 'Pacific Standard Time', 'Pacific Time (US & Canada) (UTC-08:00)', -8),
	(11, 'US Mountain Standard Time', 'Arizona (UTC-07:00)', -7),
	(12, 'Mountain Standard Time (Mexico)', 'La Paz, Mazatlan (UTC-07:00)', -7),
	(13, 'Mountain Standard Time', 'Mountain Time (US & Canada) (UTC-07:00)', -7),
	(14, 'Yukon Standard Time', 'Yukon (UTC-07:00)', -7),
	(15, 'Central America Standard Time', 'Central America (UTC-06:00)', -6),
	(16, 'Central Standard Time', 'Central Time (US & Canada) (UTC-06:00)', -6),
	(17, 'Easter Island Standard Time', 'Easter Island (UTC-06:00)', -6),
	(18, 'Central Standard Time (Mexico)', 'Guadalajara, Mexico City, Monterrey (UTC-06:00)', -6),
	(19, 'Canada Central Standard Time', 'Saskatchewan (UTC-06:00)', -6),
	(20, 'SA Pacific Standard Time', 'Bogota, Lima, Quito, Rio Branco (UTC-05:00)', -5),
	(21, 'Eastern Standard Time (Mexico)', 'Chetumal (UTC-05:00)', -5),
	(22, 'Eastern Standard Time', 'Eastern Time (US & Canada) (UTC-05:00)', -5),
	(23, 'Haiti Standard Time', 'Haiti (UTC-05:00)', -5),
	(24, 'Cuba Standard Time', 'Havana (UTC-05:00)', -5),
	(25, 'US Eastern Standard Time', 'Indiana (East) (UTC-05:00)', -5),
	(26, 'Turks And Caicos Standard Time', 'Turks and Caicos (UTC-05:00)', -5),
	(27, 'Paraguay Standard Time', 'Asuncion (UTC-04:00)', -4),
	(28, 'Atlantic Standard Time', 'Atlantic Time (Canada) (UTC-04:00)', -4),
	(29, 'Venezuela Standard Time', 'Caracas (UTC-04:00)', -4),
	(30, 'Central Brazilian Standard Time', 'Cuiaba (UTC-04:00)', -4),
	(31, 'SA Western Standard Time', 'Georgetown, La Paz, Manaus, San Juan (UTC-04:00)', -4),
	(32, 'Pacific SA Standard Time', 'Santiago (UTC-04:00)', -4),
	(33, 'Newfoundland Standard Time', 'Newfoundland (UTC-03:30)', -3.5),
	(34, 'Tocantins Standard Time', 'Araguaina (UTC-03:00)', -3),
	(35, 'E. South America Standard Time', 'Brasilia (UTC-03:00)', -3),
	(36, 'SA Eastern Standard Time', 'Cayenne, Fortaleza (UTC-03:00)', -3),
	(37, 'Argentina Standard Time', 'City of Buenos Aires (UTC-03:00)', -3),
	(38, 'Montevideo Standard Time', 'Montevideo (UTC-03:00)', -3),
	(39, 'Magallanes Standard Time', 'Punta Arenas (UTC-03:00)', -3),
	(40, 'Saint Pierre Standard Time', 'Saint Pierre and Miquelon (UTC-03:00)', -3),
	(41, 'Bahia Standard Time', 'Salvador (UTC-03:00)', -3),
	(42, 'UTC-02', 'Coordinated Universal Time-02 (UTC-02:00)', -2),
	(43, 'Greenland Standard Time', 'Greenland (UTC-02:00)', -2),
	(44, 'Mid-Atlantic Standard Time', 'Mid-Atlantic - Old (UTC-02:00)', -2),
	(45, 'Azores Standard Time', 'Azores (UTC-01:00)', -1),
	(46, 'Cape Verde Standard Time', 'Cabo Verde Is. (UTC-01:00)', -1),
	(47, 'UTC', 'Coordinated Universal Time (UTC)', 0),
	(48, 'GMT Standard Time', 'Dublin, Edinburgh, Lisbon, London (UTC+00:00)', 0),
	(49, 'Greenwich Standard Time', 'Monrovia, Reykjavik (UTC+00:00)', 0),
	(50, 'Sao Tome Standard Time', 'Sao Tome (UTC+00:00)', 0),
	(51, 'Morocco Standard Time', 'Casablanca (UTC+01:00)', 0),
	(52, 'W. Europe Standard Time', 'Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna (UTC+01:00)', 1),
	(53, 'Central Europe Standard Time', 'Belgrade, Bratislava, Budapest, Ljubljana, Prague (UTC+01:00)', 1),
	(54, 'Romance Standard Time', 'Brussels, Copenhagen, Madrid, Paris (UTC+01:00)', 1),
	(55, 'Central European Standard Time', 'Sarajevo, Skopje, Warsaw, Zagreb (UTC+01:00)', 1),
	(56, 'W. Central Africa Standard Time', 'West Central Africa (UTC+01:00)', 1),
	(57, 'GTB Standard Time', 'Athens, Bucharest (UTC+02:00)', 2),
	(58, 'Middle East Standard Time', 'Beirut (UTC+02:00)', 2),
	(59, 'Egypt Standard Time', 'Cairo (UTC+02:00)', 2),
	(60, 'E. Europe Standard Time', 'Chisinau (UTC+02:00)', 2),
	(61, 'West Bank Standard Time', 'Gaza, Hebron (UTC+02:00)', 2),
	(62, 'South Africa Standard Time', 'Harare, Pretoria (UTC+02:00)', 2),
	(63, 'FLE Standard Time', 'Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius (UTC+02:00)', 2),
	(64, 'Israel Standard Time', 'Jerusalem (UTC+02:00)', 2),
	(65, 'South Sudan Standard Time', 'Juba (UTC+02:00)', 2),
	(66, 'Kaliningrad Standard Time', 'Kaliningrad (UTC+02:00)', 2),
	(67, 'Sudan Standard Time', 'Khartoum (UTC+02:00)', 2),
	(68, 'Libya Standard Time', 'Tripoli (UTC+02:00)', 2),
	(69, 'Namibia Standard Time', 'Windhoek (UTC+02:00)', 2),
	(70, 'Jordan Standard Time', 'Amman (UTC+03:00)', 3),
	(71, 'Arabic Standard Time', 'Baghdad (UTC+03:00)', 3),
	(72, 'Syria Standard Time', 'Damascus (UTC+03:00)', 3),
	(73, 'Turkey Standard Time', 'Istanbul (UTC+03:00)', 3),
	(74, 'Arab Standard Time', 'Kuwait, Riyadh (UTC+03:00)', 3),
	(75, 'Belarus Standard Time', 'Minsk (UTC+03:00)', 3),
	(76, 'Russian Standard Time', 'Moscow, St. Petersburg (UTC+03:00)', 3),
	(77, 'E. Africa Standard Time', 'Nairobi (UTC+03:00)', 3),
	(78, 'Volgograd Standard Time', 'Volgograd (UTC+03:00)', 3),
	(79, 'Iran Standard Time', 'Tehran (UTC+03:30)', 3.5),
	(80, 'Arabian Standard Time', 'Abu Dhabi, Muscat (UTC+04:00)', 4),
	(81, 'Astrakhan Standard Time', 'Astrakhan, Ulyanovsk (UTC+04:00)', 4),
	(82, 'Azerbaijan Standard Time', 'Baku (UTC+04:00)', 4),
	(83, 'Russia Time Zone 3', 'Izhevsk, Samara (UTC+04:00)', 4),
	(84, 'Mauritius Standard Time', 'Port Louis (UTC+04:00)', 4),
	(85, 'Saratov Standard Time', 'Saratov (UTC+04:00)', 4),
	(86, 'Georgian Standard Time', 'Tbilisi (UTC+04:00)', 4),
	(87, 'Caucasus Standard Time', 'Yerevan (UTC+04:00)', 4),
	(88, 'Afghanistan Standard Time', 'Kabul (UTC+04:30)', 4.5),
	(89, 'West Asia Standard Time', 'Ashgabat, Tashkent (UTC+05:00)', 5),
	(90, 'Ekaterinburg Standard Time', 'Ekaterinburg (UTC+05:00)', 5),
	(91, 'Pakistan Standard Time', 'Islamabad, Karachi (UTC+05:00)', 5),
	(92, 'Qyzylorda Standard Time', 'Qyzylorda (UTC+05:00)', 5),
	(93, 'India Standard Time', 'Chennai, Kolkata, Mumbai, New Delhi (UTC+05:30)', 5.5),
	(94, 'Sri Lanka Standard Time', 'Sri Jayawardenepura (UTC+05:30)', 5.5),
	(95, 'Nepal Standard Time', 'Kathmandu (UTC+05:45)', 5.75),
	(96, 'Central Asia Standard Time', 'Astana (UTC+06:00)', 6),
	(97, 'Bangladesh Standard Time', 'Dhaka (UTC+06:00)', 6),
	(98, 'Omsk Standard Time', 'Omsk (UTC+06:00)', 6),
	(99, 'Myanmar Standard Time', 'Yangon (Rangoon) (UTC+06:30)', 6.5),
	(100, 'SE Asia Standard Time', 'Bangkok, Hanoi, Jakarta (UTC+07:00)', 7),
	(101, 'Altai Standard Time', 'Barnaul, Gorno-Altaysk (UTC+07:00)', 7),
	(102, 'W. Mongolia Standard Time', 'Hovd (UTC+07:00)', 7),
	(103, 'North Asia Standard Time', 'Krasnoyarsk (UTC+07:00)', 7),
	(104, 'N. Central Asia Standard Time', 'Novosibirsk (UTC+07:00)', 7),
	(105, 'Tomsk Standard Time', 'Tomsk (UTC+07:00)', 7),
	(106, 'China Standard Time', 'Beijing, Chongqing, Hong Kong, Urumqi (UTC+08:00)', 8),
	(107, 'North Asia East Standard Time', 'Irkutsk (UTC+08:00)', 8),
	(108, 'Singapore Standard Time', 'Kuala Lumpur, Singapore (UTC+08:00)', 8),
	(109, 'W. Australia Standard Time', 'Perth (UTC+08:00)', 8),
	(110, 'Taipei Standard Time', 'Taipei (UTC+08:00)', 8),
	(111, 'Ulaanbaatar Standard Time', 'Ulaanbaatar (UTC+08:00)', 8),
	(112, 'Aus Central W. Standard Time', 'Eucla (UTC+08:45)', 8.75),
	(113, 'Transbaikal Standard Time', 'Chita (UTC+09:00)', 9),
	(114, 'Tokyo Standard Time', 'Osaka, Sapporo, Tokyo (UTC+09:00)', 9),
	(115, 'North Korea Standard Time', 'Pyongyang (UTC+09:00)', 9),
	(116, 'Korea Standard Time', 'Seoul (UTC+09:00)', 9),
	(117, 'Yakutsk Standard Time', 'Yakutsk (UTC+09:00)', 9),
	(118, 'Cen. Australia Standard Time', 'Adelaide (UTC+09:30)', 9.5),
	(119, 'AUS Central Standard Time', 'Darwin (UTC+09:30)', 9.5),
	(120, 'E. Australia Standard Time', 'Brisbane (UTC+10:00)', 10),
	(121, 'AUS Eastern Standard Time', 'Canberra, Melbourne, Sydney (UTC+10:00)', 10),
	(122, 'West Pacific Standard Time', 'Guam, Port Moresby (UTC+10:00)', 10),
	(123, 'Tasmania Standard Time', 'Hobart (UTC+10:00)', 10),
	(124, 'Vladivostok Standard Time', 'Vladivostok (UTC+10:00)', 10),
	(125, 'Lord Howe Standard Time', 'Lord Howe Island (UTC+10:30)', 10.5),
	(126, 'Bougainville Standard Time', 'Bougainville Island (UTC+11:00)', 11),
	(127, 'Russia Time Zone 10', 'Chokurdakh (UTC+11:00)', 11),
	(128, 'Magadan Standard Time', 'Magadan (UTC+11:00)', 11),
	(129, 'Norfolk Standard Time', 'Norfolk Island (UTC+11:00)', 11),
	(130, 'Sakhalin Standard Time', 'Sakhalin (UTC+11:00)', 11),
	(131, 'Central Pacific Standard Time', 'Solomon Is., New Caledonia (UTC+11:00)', 11),
	(132, 'Russia Time Zone 11', 'Anadyr, Petropavlovsk-Kamchatsky (UTC+12:00)', 12),
	(133, 'New Zealand Standard Time', 'Auckland, Wellington (UTC+12:00)', 12),
	(134, 'UTC+12', 'Coordinated Universal Time+12 (UTC+12:00)', 12),
	(135, 'Fiji Standard Time', 'Fiji (UTC+12:00)', 12),
	(136, 'Kamchatka Standard Time', 'Petropavlovsk-Kamchatsky - Old (UTC+12:00)', 12),
	(137, 'Chatham Islands Standard Time', 'Chatham Islands (UTC+12:45)', 12.75),
	(138, 'UTC+13', 'Coordinated Universal Time+13 (UTC+13:00)', 13),
	(139, 'Tonga Standard Time', 'Nuku''alofa (UTC+13:00)', 13),
	(140, 'Samoa Standard Time', 'Samoa (UTC+13:00)', 13),
	(141, 'Line Islands Standard Time', 'Kiritimati Island (UTC+14:00)', 14)
) t (time_zone_id, time_zone_code, time_zone_name, time_zone_offset)

on conflict(time_zone_id) do update
set
	time_zone_code = excluded.time_zone_code,
	time_zone_name = excluded.time_zone_name,
	time_zone_offset = excluded.time_zone_offset
;


-- Post-deployment script Data\wms.location_type.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.location_type) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.location_status.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.location_status
	(
		location_status_id,
		location_status_name
	)
overriding system value 
select
	t.location_status_id, 
	t.location_status_name
from
(
	values
	(1, 'Active'),
	(2, 'Inactive')
) t (location_status_id, location_status_name)

on conflict(location_status_id) do update
set
	location_status_name = excluded.location_status_name
;

do $$ 
begin
	if not exists (select * from wms.location_status where location_status_id >= 101) then
		alter table wms.location_status alter column location_status_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.purchase_order_type.sql
insert into
	wms.purchase_order_type
	(
		purchase_order_type_id,
		purchase_order_type_name
	)
select
	t.purchase_order_type_id, 
	t.purchase_order_type_name
from
(
	values
	(1, 'Standard'),
	(2, 'Cross dock')
) t (purchase_order_type_id, purchase_order_type_name)

on conflict(purchase_order_type_id) do update
set
	purchase_order_type_name = excluded.purchase_order_type_name
;


-- Post-deployment script Data\wms.purchase_order_status.sql
insert into
	wms.purchase_order_status
	(
		purchase_order_status_id,
		purchase_order_status_name
	)
select
	t.purchase_order_status_id, 
	t.purchase_order_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'Created'),
	(3, 'In receiving'),
	(4, 'Received'),
	(5, 'Canceled')
) t (purchase_order_status_id, purchase_order_status_name)

on conflict(purchase_order_status_id) do update
set
	purchase_order_status_name = excluded.purchase_order_status_name
;


-- Post-deployment script Data\wms.inbound_load_status.sql
insert into
	wms.inbound_load_status
	(
		inbound_load_status_id,
		inbound_load_status_name
	)
select
	t.inbound_load_status_id, 
	t.inbound_load_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'In transit'),
	(3, 'On gate'),
	(4, 'Unloading'),
	(5, 'Unloaded'),
	(6, 'Completed'),
	(7, 'Canceled')
) t (inbound_load_status_id, inbound_load_status_name)

on conflict(inbound_load_status_id) do update
set
	inbound_load_status_name = excluded.inbound_load_status_name
;


-- Post-deployment script Data\wms.container_state.sql
insert into
	wms.container_state
	(
		container_state_id,
		container_state_name
	)
select
	t.container_state_id, 
	t.container_state_name
from
(
	values
	(1, 'Available'),
	(2, 'Allocated'),
	(3, 'Locked'),
	(4, 'In Transit')
) t (container_state_id, container_state_name)

on conflict(container_state_id) do update
set
	container_state_name = excluded.container_state_name
;


-- Post-deployment script Data\wms.stock_state.sql
insert into
	wms.stock_state
	(
		stock_state_id,
		stock_state_name
	)
select
	t.stock_state_id, 
	t.stock_state_name
from
(
	values
	(1, 'Available'),
	(2, 'For sale'),
	(3, 'Quality control'),
	(4, 'Damaged'),
	(5, 'Expired')
) t (stock_state_id, stock_state_name)

on conflict(stock_state_id) do update
set
	stock_state_name = excluded.stock_state_name
;


-- Post-deployment script Data\wms.purchase_order_detail_status.sql
insert into
	wms.purchase_order_detail_status
	(
		purchase_order_detail_status_id,
		purchase_order_detail_status_name
	)
select
	t.purchase_order_detail_status_id, 
	t.purchase_order_detail_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'Created'),
	(3, 'In receiving'),
	(4, 'Received'),
	(5, 'Canceled')
) t (purchase_order_detail_status_id, purchase_order_detail_status_name)

on conflict(purchase_order_detail_status_id) do update
set
	purchase_order_detail_status_name = excluded.purchase_order_detail_status_name
;


-- Post-deployment script Data\wms.document_type.sql
insert into
	wms.document_type
	(
		document_type_id,
		document_type_name
	)
select
	t.document_type_id, 
	t.document_type_name
from
(
	values
	(1, 'Purchase order'),
	(2, 'Advanced shipping notice'),
	(3, 'Inbound load')
) t (document_type_id, document_type_name)

on conflict(document_type_id) do update
set
	document_type_name = excluded.document_type_name
;


-- Post-deployment script Data\wms.attribute_data_type.sql
-- The first rows are reserved for system use
-- We insert or update these overriding the system value
-- Rows created by users will have ids greater than the reserved value

insert into
	wms.attribute_data_type
	(
		attribute_data_type_id,
		attribute_data_type_name,
		system_type_name,
		has_options,
		is_system,
		is_active
	)
overriding system value 
select
	t.attribute_data_type_id, 
	t.attribute_data_type_name,
	t.system_type_name,
	t.has_options,
	t.is_system,
	t.is_active
from
(
	values
	(1, 'Boolean', 'bool', false, true, true),
	(2, 'Date', 'date', false, true, true),
	(3, 'DateTime', 'dateTime', false, true, true),
	(4, 'Decimal', 'decimal', false, true, true),
	(5, 'Integer', 'int', false, true, true),
	(6, 'Text', 'string', false, true, true)	
) t (attribute_data_type_id, attribute_data_type_name, system_type_name, has_options, is_system, is_active)

on conflict(attribute_data_type_id) do update
set
	attribute_data_type_name = excluded.attribute_data_type_name,
	system_type_name = excluded.system_type_name,
	has_options = excluded.has_options,
	is_system = excluded.is_system,
	is_active = excluded.is_active
;

do $$ 
begin
	if not exists (select * from wms.attribute_data_type where attribute_data_type_id >= 101) then
		alter table wms.attribute_data_type alter column attribute_data_type_id restart with 101;
	end if;
end $$;


-- Post-deployment script Data\wms.advanced_shipping_notice_status.sql
insert into
	wms.advanced_shipping_notice_status
	(
		advanced_shipping_notice_status_id,
		advanced_shipping_notice_status_name
	)
select
	t.advanced_shipping_notice_status_id, 
	t.advanced_shipping_notice_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'In transit'),
	(3, 'In receiving'),
	(4, 'Received'),
	(5, 'Verified'),
	(6, 'Canceled')
) t (advanced_shipping_notice_status_id, advanced_shipping_notice_status_name)

on conflict(advanced_shipping_notice_status_id) do update
set
	advanced_shipping_notice_status_name = excluded.advanced_shipping_notice_status_name
;


-- Post-deployment script Data\wms.stock_operation_type.sql
insert into
	wms.stock_operation_type
	(
		stock_operation_type_id,
		stock_operation_name
	)
select
	t.stock_operation_type_id, 
	t.stock_operation_name
from
(
	values
	(1, 'Unloading'),
	(2, 'Putaway')
) t (stock_operation_type_id, stock_operation_name)

on conflict(stock_operation_type_id) do update
set
	stock_operation_name = excluded.stock_operation_name
;


-- Post-deployment script Data\wms.security_group.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.security_group) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.role.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.role) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.putaway_type.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.putaway_type) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.permission.sql
insert into
	wms.permission
	(
		permission_id, 
		permission_name,
		permission_key,
		permission_parent_id
	)
select
	t.permission_id, 
	t.permission_name,
	t.permission_key,
	t.permission_parent_id
from
(
	values
	(1, 'Manage master data', 'MasterData', NULL),
	(100, 'View measuring unit type', 'ViewMeasuringUnitType', 1),
	(104, 'View measuring unit system', 'ViewMeasuringUnitSystem', 1),
	(108, 'View language', 'ViewLanguage', 1),
	(112, 'View facility type', 'ViewFacilityType', 1),
	(116, 'View country', 'ViewCountry', 1),
	(124, 'View timezone', 'ViewTimezone', 1),
	(128, 'View stock owner', 'ViewStockOwner', 1),
	(132, 'View product class', 'ViewProductClass', 1),
	(136, 'View measuring unit', 'ViewMeasuringUnit', 1),
	(140, 'View item master status', 'ViewItemMasterStatus', 1),
	(144, 'View inventory priority', 'ViewInventoryPriority', 1),
	(148, 'View facility', 'ViewFacility', 1),
	(152, 'View zone', 'ViewZone', 1),
	(156, 'View purchase order type', 'ViewPurchaseOrderType', 1),
	(160, 'View purchase order status', 'ViewPurchaseOrderStatus', 1),
	(164, 'View partner', 'ViewPartner', 1),
	(172, 'View location type', 'ViewLocationType', 1),
	(176, 'View item master', 'ViewItemMaster', 1),
	(180, 'View purchase order detail status', 'ViewPurchaseOrderDetailStatus', 1),
	(184, 'View purchase order', 'ViewPurchaseOrder', 1),
	(188, 'View location', 'ViewLocation', 1),
	(192, 'View item stock attribute', 'ViewItemStockAttribute', 1),
	(196, 'View item sku attribute', 'ViewItemSkuAttribute', 1),
	(200, 'View item master footprint', 'ViewItemMasterFootprint', 1),
	(204, 'View container state', 'ViewContainerState', 1),
	(208, 'View advanced shipping notice status', 'ViewAdvancedShippingNoticeStatus', 1),
	(212, 'View stock state', 'ViewStockState', 1),
	(216, 'View purchase order detail', 'ViewPurchaseOrderDetail', 1),
	(220, 'View item master footprint detail', 'ViewItemMasterFootprintDetail', 1),
	(224, 'View inbound load status', 'ViewInboundLoadStatus', 1),
	(228, 'View container', 'ViewContainer', 1),
	(232, 'View attribute data type', 'ViewAttributeDataType', 1),
	(236, 'View advanced shipping notice detail status', 'ViewAdvancedShippingNoticeDetailStatus', 1),
	(240, 'View advanced shipping notice', 'ViewAdvancedShippingNotice', 1),
	(244, 'View user', 'ViewUser', 1),
	(248, 'View stock operation type', 'ViewStockOperationType', 1),
	(252, 'View stock attribute', 'ViewStockAttribute', 1),
	(256, 'View stock', 'ViewStock', 1),
	(260, 'View sku attribute', 'ViewSkuAttribute', 1),
	(264, 'View security group', 'ViewSecurityGroup', 1),
	(268, 'View role', 'ViewRole', 1),
	(272, 'View permission', 'ViewPermission', 1),
	(276, 'View packaging type', 'ViewPackagingType', 1),
	(280, 'View inbound load detail status', 'ViewInboundLoadDetailStatus', 1),
	(284, 'View inbound load', 'ViewInboundLoad', 1),
	(288, 'View data translation name', 'ViewDataTranslationName', 1),
	(292, 'View application translation name', 'ViewApplicationTranslationName', 1),
	(416, 'View zone status', 'ViewZoneStatus', 1),
	(296, 'View advanced shipping notice detail', 'ViewAdvancedShippingNoticeDetail', 1),
	(316, 'View user stock owner', 'ViewUserStockOwner', 1),
	(320, 'View user security group', 'ViewUserSecurityGroup', 1),
	(324, 'View user role', 'ViewUserRole', 1),
	(328, 'View user facility', 'ViewUserFacility', 1),
	(332, 'View tenant', 'ViewTenant', 1),
	(336, 'View stock operation', 'ViewStockOperation', 1),
	(340, 'View security group role', 'ViewSecurityGroupRole', 1),
	(344, 'View role permission', 'ViewRolePermission', 1),
	(348, 'View measuring unit conversion', 'ViewMeasuringUnitConversion', 1),
	(360, 'View item stock attribute value', 'ViewItemStockAttributeValue', 1),
	(364, 'View item sku attribute value', 'ViewItemSkuAttributeValue', 1),
	(368, 'View item master stock attribute', 'ViewItemMasterStockAttribute', 1),
	(372, 'View item master sku attribute', 'ViewItemMasterSkuAttribute', 1),
	(376, 'View item master footprint packaging', 'ViewItemMasterFootprintPackaging', 1),
	(380, 'View item master footprint file', 'ViewItemMasterFootprintFile', 1),
	(384, 'View item master file', 'ViewItemMasterFile', 1),
	(388, 'View item master facility', 'ViewItemMasterFacility', 1),
	(392, 'View item master barcode', 'ViewItemMasterBarcode', 1),
	(396, 'View inbound load detail', 'ViewInboundLoadDetail', 1),
	(400, 'View facility stock owner', 'ViewFacilityStockOwner', 1),
	(404, 'View data translation', 'ViewDataTranslation', 1),
	(408, 'View attribute data option', 'ViewAttributeDataOption', 1),
	(412, 'View application translation', 'ViewApplicationTranslation', 1),
	(420, 'View location rule', 'ViewLocationRule', 1),
	(424, 'View aisle status', 'ViewAisleStatus', 1),
	(428, 'View aisle direction', 'ViewAisleDirection', 1),
	(432, 'View rack status', 'ViewRackStatus', 1),
	(436, 'View location weight volume', 'ViewLocationWeightVolume', 1),
	(440, 'View aisle', 'ViewAisle', 1),
	(444, 'View rack', 'ViewRack', 1),
	(448, 'View location hierarchy level', 'ViewLocationHierarchyLevel', 1),
	(452, 'View location class', 'ViewLocationClass', 1),
	(456, 'View level status', 'ViewLevelStatus', 1),
	(460, 'View location status', 'ViewLocationStatus', 1),
	(464, 'View level', 'ViewLevel', 1),
	(468, 'View document type', 'ViewDocumentType', 1),
	(472, 'View putaway type', 'ViewPutawayType', 1),
	(476, 'View document attribute', 'ViewDocumentAttribute', 1),
	(480, 'View carrier type', 'ViewCarrierType', 1),
	(484, 'View location rule stock owner', 'ViewLocationRuleStockOwner', 1),
	(488, 'View location rule stock operation type', 'ViewLocationRuleStockOperationType', 1),
	(492, 'View location rule putaway type', 'ViewLocationRulePutawayType', 1),
	(496, 'View location rule product class', 'ViewLocationRuleProductClass', 1),
	(500, 'View location rule item master', 'ViewLocationRuleItemMaster', 1),
	(504, 'View item master putaway type', 'ViewItemMasterPutawayType', 1),
	(508, 'View document attribute value', 'ViewDocumentAttributeValue', 1),
	(512, 'View carrier', 'ViewCarrier', 1),
	(101, 'Modify measuring unit type', 'ModifyMeasuringUnitType', 100),
	(102, 'Delete measuring unit type', 'DeleteMeasuringUnitType', 100),
	(103, 'Menu measuring unit type', 'MenuMeasuringUnitType', 100),
	(105, 'Modify measuring unit system', 'ModifyMeasuringUnitSystem', 104),
	(106, 'Delete measuring unit system', 'DeleteMeasuringUnitSystem', 104),
	(107, 'Menu measuring unit system', 'MenuMeasuringUnitSystem', 104),
	(109, 'Modify language', 'ModifyLanguage', 108),
	(110, 'Delete language', 'DeleteLanguage', 108),
	(111, 'Menu language', 'MenuLanguage', 108),
	(113, 'Modify facility type', 'ModifyFacilityType', 112),
	(114, 'Delete facility type', 'DeleteFacilityType', 112),
	(115, 'Menu facility type', 'MenuFacilityType', 112),
	(117, 'Modify country', 'ModifyCountry', 116),
	(118, 'Delete country', 'DeleteCountry', 116),
	(119, 'Menu country', 'MenuCountry', 116),
	(125, 'Modify timezone', 'ModifyTimezone', 124),
	(126, 'Delete timezone', 'DeleteTimezone', 124),
	(127, 'Menu timezone', 'MenuTimezone', 124),
	(129, 'Modify stock owner', 'ModifyStockOwner', 128),
	(130, 'Delete stock owner', 'DeleteStockOwner', 128),
	(131, 'Menu stock owner', 'MenuStockOwner', 128),
	(133, 'Modify product class', 'ModifyProductClass', 132),
	(134, 'Delete product class', 'DeleteProductClass', 132),
	(135, 'Menu product class', 'MenuProductClass', 132),
	(137, 'Modify measuring unit', 'ModifyMeasuringUnit', 136),
	(138, 'Delete measuring unit', 'DeleteMeasuringUnit', 136),
	(139, 'Menu measuring unit', 'MenuMeasuringUnit', 136),
	(141, 'Modify item master status', 'ModifyItemMasterStatus', 140),
	(142, 'Delete item master status', 'DeleteItemMasterStatus', 140),
	(143, 'Menu item master status', 'MenuItemMasterStatus', 140),
	(145, 'Modify inventory priority', 'ModifyInventoryPriority', 144),
	(146, 'Delete inventory priority', 'DeleteInventoryPriority', 144),
	(147, 'Menu inventory priority', 'MenuInventoryPriority', 144),
	(149, 'Modify facility', 'ModifyFacility', 148),
	(150, 'Delete facility', 'DeleteFacility', 148),
	(151, 'Menu facility', 'MenuFacility', 148),
	(153, 'Modify zone', 'ModifyZone', 152),
	(154, 'Delete zone', 'DeleteZone', 152),
	(155, 'Menu zone', 'MenuZone', 152),
	(157, 'Modify purchase order type', 'ModifyPurchaseOrderType', 156),
	(158, 'Delete purchase order type', 'DeletePurchaseOrderType', 156),
	(159, 'Menu purchase order type', 'MenuPurchaseOrderType', 156),
	(161, 'Modify purchase order status', 'ModifyPurchaseOrderStatus', 160),
	(162, 'Delete purchase order status', 'DeletePurchaseOrderStatus', 160),
	(163, 'Menu purchase order status', 'MenuPurchaseOrderStatus', 160),
	(165, 'Modify partner', 'ModifyPartner', 164),
	(166, 'Delete partner', 'DeletePartner', 164),
	(167, 'Menu partner', 'MenuPartner', 164),
	(173, 'Modify location type', 'ModifyLocationType', 172),
	(174, 'Delete location type', 'DeleteLocationType', 172),
	(175, 'Menu location type', 'MenuLocationType', 172),
	(177, 'Modify item master', 'ModifyItemMaster', 176),
	(178, 'Delete item master', 'DeleteItemMaster', 176),
	(179, 'Menu item master', 'MenuItemMaster', 176),
	(181, 'Modify purchase order detail status', 'ModifyPurchaseOrderDetailStatus', 180),
	(182, 'Delete purchase order detail status', 'DeletePurchaseOrderDetailStatus', 180),
	(183, 'Menu purchase order detail status', 'MenuPurchaseOrderDetailStatus', 180),
	(185, 'Modify purchase order', 'ModifyPurchaseOrder', 184),
	(186, 'Delete purchase order', 'DeletePurchaseOrder', 184),
	(187, 'Menu purchase order', 'MenuPurchaseOrder', 184),
	(189, 'Modify location', 'ModifyLocation', 188),
	(190, 'Delete location', 'DeleteLocation', 188),
	(191, 'Menu location', 'MenuLocation', 188),
	(193, 'Modify item stock attribute', 'ModifyItemStockAttribute', 192),
	(194, 'Delete item stock attribute', 'DeleteItemStockAttribute', 192),
	(195, 'Menu item stock attribute', 'MenuItemStockAttribute', 192),
	(197, 'Modify item sku attribute', 'ModifyItemSkuAttribute', 196),
	(198, 'Delete item sku attribute', 'DeleteItemSkuAttribute', 196),
	(199, 'Menu item sku attribute', 'MenuItemSkuAttribute', 196),
	(201, 'Modify item master footprint', 'ModifyItemMasterFootprint', 200),
	(202, 'Delete item master footprint', 'DeleteItemMasterFootprint', 200),
	(203, 'Menu item master footprint', 'MenuItemMasterFootprint', 200),
	(205, 'Modify container state', 'ModifyContainerState', 204),
	(206, 'Delete container state', 'DeleteContainerState', 204),
	(207, 'Menu container state', 'MenuContainerState', 204),
	(209, 'Modify advanced shipping notice status', 'ModifyAdvancedShippingNoticeStatus', 208),
	(210, 'Delete advanced shipping notice status', 'DeleteAdvancedShippingNoticeStatus', 208),
	(211, 'Menu advanced shipping notice status', 'MenuAdvancedShippingNoticeStatus', 208),
	(213, 'Modify stock state', 'ModifyStockState', 212),
	(214, 'Delete stock state', 'DeleteStockState', 212),
	(215, 'Menu stock state', 'MenuStockState', 212),
	(217, 'Modify purchase order detail', 'ModifyPurchaseOrderDetail', 216),
	(218, 'Delete purchase order detail', 'DeletePurchaseOrderDetail', 216),
	(219, 'Menu purchase order detail', 'MenuPurchaseOrderDetail', 216),
	(221, 'Modify item master footprint detail', 'ModifyItemMasterFootprintDetail', 220),
	(222, 'Delete item master footprint detail', 'DeleteItemMasterFootprintDetail', 220),
	(223, 'Menu item master footprint detail', 'MenuItemMasterFootprintDetail', 220),
	(225, 'Modify inbound load status', 'ModifyInboundLoadStatus', 224),
	(226, 'Delete inbound load status', 'DeleteInboundLoadStatus', 224),
	(227, 'Menu inbound load status', 'MenuInboundLoadStatus', 224),
	(229, 'Modify container', 'ModifyContainer', 228),
	(230, 'Delete container', 'DeleteContainer', 228),
	(231, 'Menu container', 'MenuContainer', 228),
	(233, 'Modify attribute data type', 'ModifyAttributeDataType', 232),
	(234, 'Delete attribute data type', 'DeleteAttributeDataType', 232),
	(235, 'Menu attribute data type', 'MenuAttributeDataType', 232),
	(237, 'Modify advanced shipping notice detail status', 'ModifyAdvancedShippingNoticeDetailStatus', 236),
	(238, 'Delete advanced shipping notice detail status', 'DeleteAdvancedShippingNoticeDetailStatus', 236),
	(239, 'Menu advanced shipping notice detail status', 'MenuAdvancedShippingNoticeDetailStatus', 236),
	(241, 'Modify advanced shipping notice', 'ModifyAdvancedShippingNotice', 240),
	(242, 'Delete advanced shipping notice', 'DeleteAdvancedShippingNotice', 240),
	(243, 'Menu advanced shipping notice', 'MenuAdvancedShippingNotice', 240),
	(245, 'Modify user', 'ModifyUser', 244),
	(246, 'Delete user', 'DeleteUser', 244),
	(247, 'Menu user', 'MenuUser', 244),
	(249, 'Modify stock operation type', 'ModifyStockOperationType', 248),
	(250, 'Delete stock operation type', 'DeleteStockOperationType', 248),
	(251, 'Menu stock operation type', 'MenuStockOperationType', 248),
	(253, 'Modify stock attribute', 'ModifyStockAttribute', 252),
	(254, 'Delete stock attribute', 'DeleteStockAttribute', 252),
	(255, 'Menu stock attribute', 'MenuStockAttribute', 252),
	(257, 'Modify stock', 'ModifyStock', 256),
	(258, 'Delete stock', 'DeleteStock', 256),
	(259, 'Menu stock', 'MenuStock', 256),
	(261, 'Modify sku attribute', 'ModifySkuAttribute', 260),
	(262, 'Delete sku attribute', 'DeleteSkuAttribute', 260),
	(263, 'Menu sku attribute', 'MenuSkuAttribute', 260),
	(265, 'Modify security group', 'ModifySecurityGroup', 264),
	(266, 'Delete security group', 'DeleteSecurityGroup', 264),
	(267, 'Menu security group', 'MenuSecurityGroup', 264),
	(269, 'Modify role', 'ModifyRole', 268),
	(270, 'Delete role', 'DeleteRole', 268),
	(271, 'Menu role', 'MenuRole', 268),
	(273, 'Modify permission', 'ModifyPermission', 272),
	(274, 'Delete permission', 'DeletePermission', 272),
	(275, 'Menu permission', 'MenuPermission', 272),
	(277, 'Modify packaging type', 'ModifyPackagingType', 276),
	(278, 'Delete packaging type', 'DeletePackagingType', 276),
	(279, 'Menu packaging type', 'MenuPackagingType', 276),
	(281, 'Modify inbound load detail status', 'ModifyInboundLoadDetailStatus', 280),
	(282, 'Delete inbound load detail status', 'DeleteInboundLoadDetailStatus', 280),
	(283, 'Menu inbound load detail status', 'MenuInboundLoadDetailStatus', 280),
	(285, 'Modify inbound load', 'ModifyInboundLoad', 284),
	(286, 'Delete inbound load', 'DeleteInboundLoad', 284),
	(287, 'Menu inbound load', 'MenuInboundLoad', 284),
	(289, 'Modify data translation name', 'ModifyDataTranslationName', 288),
	(290, 'Delete data translation name', 'DeleteDataTranslationName', 288),
	(291, 'Menu data translation name', 'MenuDataTranslationName', 288),
	(293, 'Modify application translation name', 'ModifyApplicationTranslationName', 292),
	(294, 'Delete application translation name', 'DeleteApplicationTranslationName', 292),
	(295, 'Menu application translation name', 'MenuApplicationTranslationName', 292),
	(297, 'Modify advanced shipping notice detail', 'ModifyAdvancedShippingNoticeDetail', 296),
	(298, 'Delete advanced shipping notice detail', 'DeleteAdvancedShippingNoticeDetail', 296),
	(299, 'Menu advanced shipping notice detail', 'MenuAdvancedShippingNoticeDetail', 296),
	(317, 'Modify user stock owner', 'ModifyUserStockOwner', 316),
	(318, 'Delete user stock owner', 'DeleteUserStockOwner', 316),
	(319, 'Menu user stock owner', 'MenuUserStockOwner', 316),
	(321, 'Modify user security group', 'ModifyUserSecurityGroup', 320),
	(322, 'Delete user security group', 'DeleteUserSecurityGroup', 320),
	(323, 'Menu user security group', 'MenuUserSecurityGroup', 320),
	(325, 'Modify user role', 'ModifyUserRole', 324),
	(326, 'Delete user role', 'DeleteUserRole', 324),
	(327, 'Menu user role', 'MenuUserRole', 324),
	(329, 'Modify user facility', 'ModifyUserFacility', 328),
	(330, 'Delete user facility', 'DeleteUserFacility', 328),
	(331, 'Menu user facility', 'MenuUserFacility', 328),
	(333, 'Modify tenant', 'ModifyTenant', 332),
	(334, 'Delete tenant', 'DeleteTenant', 332),
	(335, 'Menu tenant', 'MenuTenant', 332),
	(337, 'Modify stock operation', 'ModifyStockOperation', 336),
	(338, 'Delete stock operation', 'DeleteStockOperation', 336),
	(339, 'Menu stock operation', 'MenuStockOperation', 336),
	(341, 'Modify security group role', 'ModifySecurityGroupRole', 340),
	(342, 'Delete security group role', 'DeleteSecurityGroupRole', 340),
	(343, 'Menu security group role', 'MenuSecurityGroupRole', 340),
	(345, 'Modify role permission', 'ModifyRolePermission', 344),
	(346, 'Delete role permission', 'DeleteRolePermission', 344),
	(347, 'Menu role permission', 'MenuRolePermission', 344),
	(349, 'Modify measuring unit conversion', 'ModifyMeasuringUnitConversion', 348),
	(350, 'Delete measuring unit conversion', 'DeleteMeasuringUnitConversion', 348),
	(351, 'Menu measuring unit conversion', 'MenuMeasuringUnitConversion', 348),
	(361, 'Modify item stock attribute value', 'ModifyItemStockAttributeValue', 360),
	(362, 'Delete item stock attribute value', 'DeleteItemStockAttributeValue', 360),
	(363, 'Menu item stock attribute value', 'MenuItemStockAttributeValue', 360),
	(365, 'Modify item sku attribute value', 'ModifyItemSkuAttributeValue', 364),
	(366, 'Delete item sku attribute value', 'DeleteItemSkuAttributeValue', 364),
	(367, 'Menu item sku attribute value', 'MenuItemSkuAttributeValue', 364),
	(369, 'Modify item master stock attribute', 'ModifyItemMasterStockAttribute', 368),
	(370, 'Delete item master stock attribute', 'DeleteItemMasterStockAttribute', 368),
	(371, 'Menu item master stock attribute', 'MenuItemMasterStockAttribute', 368),
	(373, 'Modify item master sku attribute', 'ModifyItemMasterSkuAttribute', 372),
	(374, 'Delete item master sku attribute', 'DeleteItemMasterSkuAttribute', 372),
	(375, 'Menu item master sku attribute', 'MenuItemMasterSkuAttribute', 372),
	(377, 'Modify item master footprint packaging', 'ModifyItemMasterFootprintPackaging', 376),
	(378, 'Delete item master footprint packaging', 'DeleteItemMasterFootprintPackaging', 376),
	(379, 'Menu item master footprint packaging', 'MenuItemMasterFootprintPackaging', 376),
	(381, 'Modify item master footprint file', 'ModifyItemMasterFootprintFile', 380),
	(382, 'Delete item master footprint file', 'DeleteItemMasterFootprintFile', 380),
	(383, 'Menu item master footprint file', 'MenuItemMasterFootprintFile', 380),
	(385, 'Modify item master file', 'ModifyItemMasterFile', 384),
	(386, 'Delete item master file', 'DeleteItemMasterFile', 384),
	(387, 'Menu item master file', 'MenuItemMasterFile', 384),
	(389, 'Modify item master facility', 'ModifyItemMasterFacility', 388),
	(390, 'Delete item master facility', 'DeleteItemMasterFacility', 388),
	(391, 'Menu item master facility', 'MenuItemMasterFacility', 388),
	(393, 'Modify item master barcode', 'ModifyItemMasterBarcode', 392),
	(394, 'Delete item master barcode', 'DeleteItemMasterBarcode', 392),
	(395, 'Menu item master barcode', 'MenuItemMasterBarcode', 392),
	(397, 'Modify inbound load detail', 'ModifyInboundLoadDetail', 396),
	(398, 'Delete inbound load detail', 'DeleteInboundLoadDetail', 396),
	(399, 'Menu inbound load detail', 'MenuInboundLoadDetail', 396),
	(401, 'Modify facility stock owner', 'ModifyFacilityStockOwner', 400),
	(402, 'Delete facility stock owner', 'DeleteFacilityStockOwner', 400),
	(403, 'Menu facility stock owner', 'MenuFacilityStockOwner', 400),
	(405, 'Modify data translation', 'ModifyDataTranslation', 404),
	(406, 'Delete data translation', 'DeleteDataTranslation', 404),
	(407, 'Menu data translation', 'MenuDataTranslation', 404),
	(409, 'Modify attribute data option', 'ModifyAttributeDataOption', 408),
	(410, 'Delete attribute data option', 'DeleteAttributeDataOption', 408),
	(411, 'Menu attribute data option', 'MenuAttributeDataOption', 408),
	(413, 'Modify application translation', 'ModifyApplicationTranslation', 412),
	(414, 'Delete application translation', 'DeleteApplicationTranslation', 412),
	(415, 'Menu application translation', 'MenuApplicationTranslation', 412),
	(417, 'Modify zone status', 'ModifyZoneStatus', 416),
	(418, 'Delete zone status', 'DeleteZoneStatus', 416),
	(419, 'Menu zone status', 'MenuZoneStatus', 416),
	(421, 'Modify location rule', 'ModifyLocationRule', 420),
	(422, 'Delete location rule', 'DeleteLocationRule', 420),
	(423, 'Menu location rule', 'MenuLocationRule', 420),
	(425, 'Modify aisle status', 'ModifyAisleStatus', 424),
	(426, 'Delete aisle status', 'DeleteAisleStatus', 424),
	(427, 'Menu aisle status', 'MenuAisleStatus', 424),
	(429, 'Modify aisle direction', 'ModifyAisleDirection', 428),
	(430, 'Delete aisle direction', 'DeleteAisleDirection', 428),
	(431, 'Menu aisle direction', 'MenuAisleDirection', 428),
	(433, 'Modify rack status', 'ModifyRackStatus', 432),
	(434, 'Delete rack status', 'DeleteRackStatus', 432),
	(435, 'Menu rack status', 'MenuRackStatus', 432),
	(437, 'Modify location weight volume', 'ModifyLocationWeightVolume', 436),
	(438, 'Delete location weight volume', 'DeleteLocationWeightVolume', 436),
	(439, 'Menu location weight volume', 'MenuLocationWeightVolume', 436),
	(441, 'Modify aisle', 'ModifyAisle', 440),
	(442, 'Delete aisle', 'DeleteAisle', 440),
	(443, 'Menu aisle', 'MenuAisle', 440),
	(445, 'Modify rack', 'ModifyRack', 444),
	(446, 'Delete rack', 'DeleteRack', 444),
	(447, 'Menu rack', 'MenuRack', 444),
	(449, 'Modify location hierarchy level', 'ModifyLocationHierarchyLevel', 448),
	(450, 'Delete location hierarchy level', 'DeleteLocationHierarchyLevel', 448),
	(451, 'Menu location hierarchy level', 'MenuLocationHierarchyLevel', 448),
	(453, 'Modify location class', 'ModifyLocationClass', 452),
	(454, 'Delete location class', 'DeleteLocationClass', 452),
	(455, 'Menu location class', 'MenuLocationClass', 452),
	(457, 'Modify level status', 'ModifyLevelStatus', 456),
	(458, 'Delete level status', 'DeleteLevelStatus', 456),
	(459, 'Menu level status', 'MenuLevelStatus', 456),
	(461, 'Modify location status', 'ModifyLocationStatus', 460),
	(462, 'Delete location status', 'DeleteLocationStatus', 460),
	(463, 'Menu location status', 'MenuLocationStatus', 460),
	(465, 'Modify level', 'ModifyLevel', 464),
	(466, 'Delete level', 'DeleteLevel', 464),
	(467, 'Menu level', 'MenuLevel', 464),
	(469, 'Modify document type', 'ModifyDocumentType', 468),
	(470, 'Delete document type', 'DeleteDocumentType', 468),
	(471, 'Menu document type', 'MenuDocumentType', 468),
	(473, 'Modify putaway type', 'ModifyPutawayType', 472),
	(474, 'Delete putaway type', 'DeletePutawayType', 472),
	(475, 'Menu putaway type', 'MenuPutawayType', 472),
	(477, 'Modify document attribute', 'ModifyDocumentAttribute', 476),
	(478, 'Delete document attribute', 'DeleteDocumentAttribute', 476),
	(479, 'Menu document attribute', 'MenuDocumentAttribute', 476),
	(481, 'Modify carrier type', 'ModifyCarrierType', 480),
	(482, 'Delete carrier type', 'DeleteCarrierType', 480),
	(483, 'Menu carrier type', 'MenuCarrierType', 480),
	(485, 'Modify location rule stock owner', 'ModifyLocationRuleStockOwner', 484),
	(486, 'Delete location rule stock owner', 'DeleteLocationRuleStockOwner', 484),
	(487, 'Menu location rule stock owner', 'MenuLocationRuleStockOwner', 484),
	(489, 'Modify location rule stock operation type', 'ModifyLocationRuleStockOperationType', 488),
	(490, 'Delete location rule stock operation type', 'DeleteLocationRuleStockOperationType', 488),
	(491, 'Menu location rule stock operation type', 'MenuLocationRuleStockOperationType', 488),
	(493, 'Modify location rule putaway type', 'ModifyLocationRulePutawayType', 492),
	(494, 'Delete location rule putaway type', 'DeleteLocationRulePutawayType', 492),
	(495, 'Menu location rule putaway type', 'MenuLocationRulePutawayType', 492),
	(497, 'Modify location rule product class', 'ModifyLocationRuleProductClass', 496),
	(498, 'Delete location rule product class', 'DeleteLocationRuleProductClass', 496),
	(499, 'Menu location rule product class', 'MenuLocationRuleProductClass', 496),
	(501, 'Modify location rule item master', 'ModifyLocationRuleItemMaster', 500),
	(502, 'Delete location rule item master', 'DeleteLocationRuleItemMaster', 500),
	(503, 'Menu location rule item master', 'MenuLocationRuleItemMaster', 500),
	(505, 'Modify item master putaway type', 'ModifyItemMasterPutawayType', 504),
	(506, 'Delete item master putaway type', 'DeleteItemMasterPutawayType', 504),
	(507, 'Menu item master putaway type', 'MenuItemMasterPutawayType', 504),
	(509, 'Modify document attribute value', 'ModifyDocumentAttributeValue', 508),
	(510, 'Delete document attribute value', 'DeleteDocumentAttributeValue', 508),
	(511, 'Menu document attribute value', 'MenuDocumentAttributeValue', 508),
	(513, 'Modify carrier', 'ModifyCarrier', 512),
	(514, 'Delete carrier', 'DeleteCarrier', 512),
	(515, 'Menu carrier', 'MenuCarrier', 512),
	(516, 'View container document', 'ViewContainerDocument', 1),
	(517, 'Modify container document', 'ModifyContainerDocument', 516),
	(518, 'Delete container document', 'DeleteContainerDocument', 516),
	(519, 'Menu container document', 'MenuContainerDocument', 516)
) t (permission_id, permission_name, permission_key, permission_parent_id)

on conflict(permission_id) do update
set
	permission_name = excluded.permission_name,
	permission_key = excluded.permission_key,
	permission_parent_id = excluded.permission_parent_id
;


-- Post-deployment script Data\wms.packaging_type.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.packaging_type) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.inbound_load_detail_status.sql
insert into
	wms.inbound_load_detail_status
	(
		inbound_load_detail_status_id,
		inbound_load_detail_status_name
	)
select
	t.inbound_load_detail_status_id, 
	t.inbound_load_detail_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'In transit'),
	(3, 'On gate'),
	(4, 'Unloading'),
	(5, 'Unloaded'),
	(6, 'Completed'),
	(7, 'Canceled')
) t (inbound_load_detail_status_id, inbound_load_detail_status_name)

on conflict(inbound_load_detail_status_id) do update
set
	inbound_load_detail_status_name = excluded.inbound_load_detail_status_name
;


-- Post-deployment script Data\wms.carrier_type.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.carrier_type) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.advanced_shipping_notice_detail_status.sql
insert into
	wms.advanced_shipping_notice_detail_status
	(
		advanced_shipping_notice_detail_status_id,
		advanced_shipping_notice_detail_status_name
	)
select
	t.advanced_shipping_notice_detail_status_id, 
	t.advanced_shipping_notice_detail_status_name
from
(
	values
	(1, 'In editing'),
	(2, 'In transit'),
	(3, 'In receiving'),
	(4, 'Received'),
	(5, 'Verified'),
	(6, 'Canceled')
) t (advanced_shipping_notice_detail_status_id, advanced_shipping_notice_detail_status_name)

on conflict(advanced_shipping_notice_detail_status_id) do update
set
	advanced_shipping_notice_detail_status_name = excluded.advanced_shipping_notice_detail_status_name
;


-- Post-deployment script Data\wms.security_group_role.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.security_group_role) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.role_permission.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.role_permission) then
		
		-- Insert initial rows here
		
	end if;
end $$;


-- Post-deployment script Data\wms.measuring_unit_conversion.sql
-- The script populates the initial rows and runs only if the table is empty.

do $$ 
begin
	if not exists (select * from wms.measuring_unit_conversion) then
		
		insert into
			wms.measuring_unit_conversion
			(
				measuring_unit_source_id,
				measuring_unit_destination_id,
				factor
			)
		select
			ms.measuring_unit_id,
			md.measuring_unit_id,
			t.factor
		from
		(
			values
			-- Weight
			('mg', 'g', 1, 1, 0.001),
			('mg', 'kg', 1, 1, 1E-06),
			('mg', 't', 1, 1, 1E-09),
			('g', 'mg', 1, 1, 1000),
			('g', 'kg', 1, 1, 0.001),
			('g', 't', 1, 1, 1E-06),
			('kg', 'mg', 1, 1, 1000000),
			('kg', 'g', 1, 1, 1000),
			('kg', 't', 1, 1, 0.001),
			('t', 'mg', 1, 1, 1000000000),
			('t', 'g', 1, 1, 1000000),
			('t', 'kg', 1, 1, 1000),
	
			-- Length
			('mm', 'cm', 1, 2, 0.1),
			('mm', 'dm', 1, 2, 0.01),
			('mm', 'm', 1, 2, 0.001),
			('mm', 'dam', 1, 2, 0.0001),
			('mm', 'hm', 1, 2, 1E-05),
			('mm', 'km', 1, 2, 1E-06),
			('cm', 'mm', 1, 2, 10),
			('cm', 'dm', 1, 2, 0.1),
			('cm', 'm', 1, 2, 0.01),
			('cm', 'dam', 1, 2, 0.001),
			('cm', 'hm', 1, 2, 0.0001),
			('cm', 'km', 1, 2, 1E-05),
			('dm', 'mm', 1, 2, 100),
			('dm', 'cm', 1, 2, 10),
			('dm', 'm', 1, 2, 0.1),
			('dm', 'dam', 1, 2, 0.01),
			('dm', 'hm', 1, 2, 0.001),
			('dm', 'km', 1, 2, 0.0001),
			('m', 'mm', 1, 2, 1000),
			('m', 'cm', 1, 2, 100),
			('m', 'dm', 1, 2, 10),
			('m', 'dam', 1, 2, 0.1),
			('m', 'hm', 1, 2, 0.01),
			('m', 'km', 1, 2, 0.001),
			('dam', 'mm', 1, 2, 10000),
			('dam', 'cm', 1, 2, 1000),
			('dam', 'dm', 1, 2, 100),
			('dam', 'm', 1, 2, 10),
			('dam', 'hm', 1, 2, 0.1),
			('dam', 'km', 1, 2, 0.01),
			('hm', 'mm', 1, 2, 100000),
			('hm', 'cm', 1, 2, 10000),
			('hm', 'dm', 1, 2, 1000),
			('hm', 'm', 1, 2, 100),
			('hm', 'dam', 1, 2, 10),
			('hm', 'km', 1, 2, 0.1),
			('km', 'mm', 1, 2, 1000000),
			('km', 'cm', 1, 2, 100000),
			('km', 'dm', 1, 2, 10000),
			('km', 'm', 1, 2, 1000),
			('km', 'dam', 1, 2, 100),
			('km', 'hm', 1, 2, 10),	
	
			-- Volume
            ('ml', 'cl', 1, 3, 0.1),
            ('ml', 'dl', 1, 3, 0.01),
            ('ml', 'l', 1, 3, 0.001),
            ('ml', 'dal', 1, 3, 0.0001),
            ('ml', 'hal', 1, 3, 1E-05),
            ('ml', 'kl', 1, 3, 1E-06),
            ('ml', 'mm3', 1, 3, 1000),
            ('ml', 'cm3', 1, 3, 1),
            ('ml', 'dm3', 1, 3, 0.001),
            ('ml', 'm3', 1, 3, 1E-06),
            ('ml', 'dam3', 1, 3, 1E-09),
            ('ml', 'ham3', 1, 3, 1E-12),
            ('ml', 'km3', 1, 3, 1E-15),
            ('cl', 'ml', 1, 3, 10),
            ('cl', 'dl', 1, 3, 0.1),
            ('cl', 'l', 1, 3, 0.01),
            ('cl', 'dal', 1, 3, 0.001),
            ('cl', 'hal', 1, 3, 0.0001),
            ('cl', 'kl', 1, 3, 1E-05),
            ('cl', 'mm3', 1, 3, 10000),
            ('cl', 'cm3', 1, 3, 10),
            ('cl', 'dm3', 1, 3, 0.01),
            ('cl', 'm3', 1, 3, 1E-05),
            ('cl', 'dam3', 1, 3, 1E-08),
            ('cl', 'ham3', 1, 3, 1E-11),
            ('cl', 'km3', 1, 3, 1E-14),
            ('dl', 'ml', 1, 3, 100),
            ('dl', 'cl', 1, 3, 10),
            ('dl', 'l', 1, 3, 0.1),
            ('dl', 'dal', 1, 3, 0.01),
            ('dl', 'hal', 1, 3, 0.001),
            ('dl', 'kl', 1, 3, 0.0001),
            ('dl', 'mm3', 1, 3, 100000),
            ('dl', 'cm3', 1, 3, 100),
            ('dl', 'dm3', 1, 3, 0.1),
            ('dl', 'm3', 1, 3, 0.0001),
            ('dl', 'dam3', 1, 3, 1E-07),
            ('dl', 'ham3', 1, 3, 1E-10),
            ('dl', 'km3', 1, 3, 1E-13),
            ('l', 'ml', 1, 3, 1000),
            ('l', 'cl', 1, 3, 100),
            ('l', 'dl', 1, 3, 10),
            ('l', 'dal', 1, 3, 0.1),
            ('l', 'hal', 1, 3, 0.01),
            ('l', 'kl', 1, 3, 0.001),
            ('l', 'mm3', 1, 3, 1000000),
            ('l', 'cm3', 1, 3, 1000),
            ('l', 'dm3', 1, 3, 1),
            ('l', 'm3', 1, 3, 0.001),
            ('l', 'dam3', 1, 3, 1E-06),
            ('l', 'ham3', 1, 3, 1E-09),
            ('l', 'km3', 1, 3, 1E-12),
            ('dal', 'ml', 1, 3, 10000),
            ('dal', 'cl', 1, 3, 1000),
            ('dal', 'dl', 1, 3, 100),
            ('dal', 'l', 1, 3, 10),
            ('dal', 'hal', 1, 3, 0.1),
            ('dal', 'kl', 1, 3, 0.01),
            ('dal', 'mm3', 1, 3, 10000000),
            ('dal', 'cm3', 1, 3, 10000),
            ('dal', 'dm3', 1, 3, 10),
            ('dal', 'm3', 1, 3, 0.01),
            ('dal', 'dam3', 1, 3, 1E-05),
            ('dal', 'ham3', 1, 3, 1E-08),
            ('dal', 'km3', 1, 3, 1E-11),
            ('hal', 'ml', 1, 3, 100000),
            ('hal', 'cl', 1, 3, 10000),
            ('hal', 'dl', 1, 3, 1000),
            ('hal', 'l', 1, 3, 100),
            ('hal', 'dal', 1, 3, 10),
            ('hal', 'kl', 1, 3, 0.1),
            ('hal', 'mm3', 1, 3, 100000000),
            ('hal', 'cm3', 1, 3, 100000),
            ('hal', 'dm3', 1, 3, 100),
            ('hal', 'm3', 1, 3, 0.1),
            ('hal', 'dam3', 1, 3, 0.0001),
            ('hal', 'ham3', 1, 3, 1E-07),
            ('hal', 'km3', 1, 3, 1E-10),
            ('kl', 'ml', 1, 3, 1000000),
            ('kl', 'cl', 1, 3, 100000),
            ('kl', 'dl', 1, 3, 10000),
            ('kl', 'l', 1, 3, 1000),
            ('kl', 'dal', 1, 3, 100),
            ('kl', 'hal', 1, 3, 10),
            ('kl', 'mm3', 1, 3, 1000000000),
            ('kl', 'cm3', 1, 3, 1000000),
            ('kl', 'dm3', 1, 3, 1000),
            ('kl', 'm3', 1, 3, 1),
            ('kl', 'dam3', 1, 3, 0.001),
            ('kl', 'ham3', 1, 3, 1E-06),
            ('kl', 'km3', 1, 3, 1E-09),
            ('mm3', 'ml', 1, 3, 0.001),
            ('mm3', 'cl', 1, 3, 0.0001),
            ('mm3', 'dl', 1, 3, 1E-05),
            ('mm3', 'l', 1, 3, 1E-06),
            ('mm3', 'dal', 1, 3, 1E-07),
            ('mm3', 'hal', 1, 3, 1E-08),
            ('mm3', 'kl', 1, 3, 1E-09),
            ('mm3', 'cm3', 1, 3, 0.001),
            ('mm3', 'dm3', 1, 3, 1E-06),
            ('mm3', 'm3', 1, 3, 1E-09),
            ('mm3', 'dam3', 1, 3, 1E-12),
            ('mm3', 'ham3', 1, 3, 1E-15),
            ('mm3', 'km3', 1, 3, 1E-18),
            ('cm3', 'ml', 1, 3, 1),
            ('cm3', 'cl', 1, 3, 0.1),
            ('cm3', 'dl', 1, 3, 0.01),
            ('cm3', 'l', 1, 3, 0.001),
            ('cm3', 'dal', 1, 3, 0.0001),
            ('cm3', 'hal', 1, 3, 1E-05),
            ('cm3', 'kl', 1, 3, 1E-06),
            ('cm3', 'mm3', 1, 3, 1000),
            ('cm3', 'dm3', 1, 3, 0.001),
            ('cm3', 'm3', 1, 3, 1E-06),
            ('cm3', 'dam3', 1, 3, 1E-09),
            ('cm3', 'ham3', 1, 3, 1E-12),
            ('cm3', 'km3', 1, 3, 1E-15),
            ('dm3', 'ml', 1, 3, 1000),
            ('dm3', 'cl', 1, 3, 100),
            ('dm3', 'dl', 1, 3, 10),
            ('dm3', 'l', 1, 3, 1),
            ('dm3', 'dal', 1, 3, 0.1),
            ('dm3', 'hal', 1, 3, 0.01),
            ('dm3', 'kl', 1, 3, 0.001),
            ('dm3', 'mm3', 1, 3, 1000000),
            ('dm3', 'cm3', 1, 3, 1000),
            ('dm3', 'm3', 1, 3, 0.001),
            ('dm3', 'dam3', 1, 3, 1E-06),
            ('dm3', 'ham3', 1, 3, 1E-09),
            ('dm3', 'km3', 1, 3, 1E-12),
            ('m3', 'ml', 1, 3, 1000000),
            ('m3', 'cl', 1, 3, 100000),
            ('m3', 'dl', 1, 3, 10000),
            ('m3', 'l', 1, 3, 1000),
            ('m3', 'dal', 1, 3, 100),
            ('m3', 'hal', 1, 3, 10),
            ('m3', 'kl', 1, 3, 1),
            ('m3', 'mm3', 1, 3, 1000000000),
            ('m3', 'cm3', 1, 3, 1000000),
            ('m3', 'dm3', 1, 3, 1000),
            ('m3', 'dam3', 1, 3, 0.001),
            ('m3', 'ham3', 1, 3, 1E-06),
            ('m3', 'km3', 1, 3, 1E-09),
            ('dam3', 'ml', 1, 3, 1000000000),
            ('dam3', 'cl', 1, 3, 100000000),
            ('dam3', 'dl', 1, 3, 10000000),
            ('dam3', 'l', 1, 3, 1000000),
            ('dam3', 'dal', 1, 3, 100000),
            ('dam3', 'hal', 1, 3, 10000),
            ('dam3', 'kl', 1, 3, 1000),
            ('dam3', 'mm3', 1, 3, 1000000000000),
            ('dam3', 'cm3', 1, 3, 1000000000),
            ('dam3', 'dm3', 1, 3, 1000000),
            ('dam3', 'm3', 1, 3, 1000),
            ('dam3', 'ham3', 1, 3, 0.001),
            ('dam3', 'km3', 1, 3, 1E-06),
            ('ham3', 'ml', 1, 3, 1000000000000),
            ('ham3', 'cl', 1, 3, 100000000000),
            ('ham3', 'dl', 1, 3, 10000000000),
            ('ham3', 'l', 1, 3, 1000000000),
            ('ham3', 'dal', 1, 3, 100000000),
            ('ham3', 'hal', 1, 3, 10000000),
            ('ham3', 'kl', 1, 3, 1000000),
            ('ham3', 'mm3', 1, 3, 1000000000000000),
            ('ham3', 'cm3', 1, 3, 1000000000000),
            ('ham3', 'dm3', 1, 3, 1000000000),
            ('ham3', 'm3', 1, 3, 1000000),
            ('ham3', 'dam3', 1, 3, 1000),
            ('ham3', 'km3', 1, 3, 0.001),
            ('km3', 'ml', 1, 3, 1000000000000000),
            ('km3', 'cl', 1, 3, 100000000000000),
            ('km3', 'dl', 1, 3, 10000000000000),
            ('km3', 'l', 1, 3, 1000000000000),
            ('km3', 'dal', 1, 3, 100000000000),
            ('km3', 'hal', 1, 3, 10000000000),
            ('km3', 'kl', 1, 3, 1000000000),
            ('km3', 'mm3', 1, 3, 1E+18),
            ('km3', 'cm3', 1, 3, 1000000000000000),
            ('km3', 'dm3', 1, 3, 1000000000000),
            ('km3', 'm3', 1, 3, 1000000000),
            ('km3', 'dam3', 1, 3, 1000000),
            ('km3', 'ham3', 1, 3, 1000)
		) t (source_abbreviation, destination_abbreviation, measuring_unit_system_id, measuring_unit_type_id, factor)

		inner join
			wms.measuring_unit ms
		on
			ms.measuring_unit_abbreviation = t.source_abbreviation
			and ms.measuring_unit_system_id = t.measuring_unit_system_id
			and ms.measuring_unit_type_id = t.measuring_unit_type_id
	
		inner join
			wms.measuring_unit md
		on
			md.measuring_unit_abbreviation = t.destination_abbreviation
			and md.measuring_unit_system_id = t.measuring_unit_system_id
			and md.measuring_unit_type_id = t.measuring_unit_type_id

		order by
			1,
			2;
		
	end if;
end $$;


-- Post-deployment script Misc\wms.nmul.sql
-- SQL Examiner isn't aware of Aggregates, so this is added manually as a post-deployment script

CREATE OR REPLACE AGGREGATE wms.nmul(numeric) (
    SFUNC = numeric_mul,
    STYPE = numeric ,
    FINALFUNC_MODIFY = READ_ONLY,
    MFINALFUNC_MODIFY = READ_ONLY
);


-- Post-deployment script Permissions\wmsapi.sql
GRANT USAGE ON SCHEMA wms TO $(DatabaseUser);

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA wms TO $(DatabaseUser);

GRANT SELECT ON ALL SEQUENCES IN SCHEMA wms TO $(DatabaseUser);


-- Change the database version
insert into wms.migration (migration_id, migration_name) values (1, '20240223-115150') on conflict(migration_id) do update set migration_name = excluded.migration_name;

COMMIT TRANSACTION;


	v_stock_attribute character varying(500);
begin
	if (p_item_stock_attribute_id is null) then
		return null;
	else
		begin
			
			select string_agg(attr,', ')
			into v_stock_attribute
			from
			(select wms.translate_row('stock_attribute','stock_attribute_name',sa.stock_attribute_id,sa.stock_attribute_name)||':'||isav.attribute_value as attr
			from 
			wms.item_stock_attribute_value isav
			inner join
			wms.stock_attribute sa
			on sa.stock_attribute_id = isav.stock_attribute_id
			and isav.item_stock_attribute_id = p_item_stock_attribute_id
			order by sa.stock_attribute_name
			) a;
			
		end;
	end if;

	return v_stock_attribute;
end;
$BODY$;
