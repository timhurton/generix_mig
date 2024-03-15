-- *************************************************
-- *     DROP OBJECTS
-- *************************************************

-- APUTI
DROP TRIGGER aputi_before_update_anonymise ON "lidl_neowms".aputi; 
DROP TRIGGER aputi_before_update_anonymise ON "lidl_neowms".aputi;
DROP FUNCTION "lidl_neowms".fnc_anonymise_aputi();
--  GECLI
DROP TRIGGER gecli_before_update_anonymise ON "lidl_neowms".gecli; 
DROP TRIGGER gecli_before_update_anonymise ON "lidl_neowms".gecli;
DROP FUNCTION "lidl_neowms".fnc_anonymise_gecli();
-- GEFOU	   
DROP TRIGGER gefou_before_update_anonymise ON "lidl_neowms".gefou; 
DROP TRIGGER gefou_before_insert_anonymise ON "lidl_neowms".gefou;
DROP FUNCTION "lidl_neowms".fnc_anonymise_gefou();
-- GETRA
DROP TRIGGER getra_before_update_anonymise ON "lidl_neowms".getra; 
DROP TRIGGER getra_before_insert_anonymise ON "lidl_neowms".getra;
DROP FUNCTION "lidl_neowms".fnc_anonymise_getra();
-- GEACT
DROP TRIGGER geact_before_update_anonymise ON "lidl_neowms".geact; 
DROP TRIGGER geact_before_insert_anonymise ON "lidl_neowms".geact;
DROP FUNCTION "lidl_neowms".fnc_anonymise_geact();
-- APMAILU
DROP TRIGGER apmailu_before_update_anonymise ON "lidl_neowms".apmailu; 
DROP TRIGGER apmailu_before_insert_anonymise ON "lidl_neowms".apmailu;
DROP FUNCTION "lidl_neowms".fnc_anonymise_apmailu();

-- *************************************************
-- *     CREATE OBJECTS
-- *************************************************

-- APUTI
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_aputi()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.nomuti IS NOT NULL THEN 
    NEW.nomuti := CASE WHEN length(NEW.nomuti) > 0 THEN SUBSTR(encode(gen_random_bytes(30), 'hex'),1,30) ELSE NEW.nomuti END;
  END IF;

  IF NEW.pasuti IS NOT NULL THEN 
    NEW.pasuti := CASE WHEN length(NEW.pasuti) > 0 THEN SUBSTR(encode(gen_random_bytes(10), 'hex'),1,10) ELSE NEW.pasuti END;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER aputi_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".aputi
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_aputi();
       
CREATE OR REPLACE TRIGGER aputi_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".aputi
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_aputi();

-- GECLI
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_gecli()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.ad1cli IS NOT NULL THEN 
    NEW.ad1cli := CASE WHEN length(NEW.ad1cli) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad1cli END;
  END IF;

  IF NEW.ad2cli IS NOT NULL THEN 
    NEW.ad2cli := CASE WHEN length(NEW.ad2cli) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad2cli END;
  END IF;

  IF NEW.ad3cli IS NOT NULL THEN 
    NEW.ad3cli := CASE WHEN length(NEW.ad3cli) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad3cli END;
  END IF;

  IF NEW.vilcli IS NOT NULL THEN 
    NEW.vilcli := CASE WHEN length(NEW.vilcli) > 0 THEN SUBSTR(encode(gen_random_bytes(58), 'hex'),1,58) ELSE NEW.vilcli END;
  END IF;

  IF NEW.telcli IS NOT NULL THEN 
    NEW.telcli := CASE WHEN length(NEW.telcli) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.telcli END;
  END IF;

  IF NEW.faxcli IS NOT NULL THEN 
    NEW.faxcli := CASE WHEN length(NEW.faxcli) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.faxcli END;
  END IF;

  IF NEW.cpocli IS NOT NULL THEN 
    NEW.cpocli := CASE WHEN NEW.cpocli IS NOT NULL THEN FLOOR(RANDOM()*(99999- 1) + 1) ELSE NEW.cpocli END;
  END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER gecli_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".gecli
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_gecli();
       
CREATE OR REPLACE TRIGGER gecli_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".gecli
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_gecli();

-- GEFOU
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_gefou()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.ad1fou IS NOT NULL THEN 
    NEW.ad1fou := CASE WHEN length(NEW.ad1fou) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad1fou END;
  END IF;

  IF NEW.ad2fou IS NOT NULL THEN 
    NEW.ad2fou := CASE WHEN length(NEW.ad2fou) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad2fou END;
  END IF;

  IF NEW.ad3fou IS NOT NULL THEN 
    NEW.ad3fou := CASE WHEN length(NEW.ad3fou) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad3fou END;
  END IF;

  IF NEW.vilfou IS NOT NULL THEN 
    NEW.vilfou := CASE WHEN length(NEW.vilfou) > 0 THEN SUBSTR(encode(gen_random_bytes(58), 'hex'),1,58) ELSE NEW.vilfou END;
  END IF;

  IF NEW.telfou IS NOT NULL THEN 
    NEW.telfou := CASE WHEN length(NEW.telfou) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.telfou END;
  END IF;

  IF NEW.faxfou IS NOT NULL THEN 
    NEW.faxfou := CASE WHEN length(NEW.faxfou) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.faxfou END;
  END IF;

  IF NEW.cpofou IS NOT NULL THEN 
    NEW.cpofou := CASE WHEN NEW.cpofou IS NOT NULL THEN FLOOR(RANDOM()*(99999- 1) + 1) ELSE NEW.cpofou END;
  END IF;

  IF NEW.emladr IS NOT NULL THEN 
    NEW.emladr := CASE WHEN length(NEW.emladr) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.emladr END;
  END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER gefou_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".gefou
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_gefou();
       
CREATE OR REPLACE TRIGGER gefou_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".gefou
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_gefou();

-- GETRA
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_getra()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.ad1tra IS NOT NULL THEN 
    NEW.ad1tra := CASE WHEN length(NEW.ad1tra) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad1tra END;
  END IF;

  IF NEW.ad2tra IS NOT NULL THEN 
    NEW.ad2tra := CASE WHEN length(NEW.ad2tra) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad2tra END;
  END IF;

  IF NEW.ad3tra IS NOT NULL THEN 
    NEW.ad3tra := CASE WHEN length(NEW.ad3tra) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad3tra END;
  END IF;

  IF NEW.viltra IS NOT NULL THEN 
    NEW.viltra := CASE WHEN length(NEW.viltra) > 0 THEN SUBSTR(encode(gen_random_bytes(58), 'hex'),1,58) ELSE NEW.viltra END;
  END IF;

  IF NEW.teltra IS NOT NULL THEN 
    NEW.teltra := CASE WHEN length(NEW.teltra) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.teltra END;
  END IF;

  IF NEW.faxtra IS NOT NULL THEN 
    NEW.faxtra := CASE WHEN length(NEW.faxtra) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.faxtra END;
  END IF;

  IF NEW.cpotra IS NOT NULL THEN 
    NEW.cpotra := CASE WHEN NEW.cpotra IS NOT NULL THEN FLOOR(RANDOM()*(99999- 1) + 1) ELSE NEW.cpotra END;
  END IF;

IF NEW.emladr IS NOT NULL THEN 
    NEW.emladr := CASE WHEN length(NEW.emladr) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.emladr END;
  END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER getra_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".getra
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_getra();
       
CREATE OR REPLACE TRIGGER getra_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".getra
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_getra();

-- GEACT
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_geact()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.ad1act IS NOT NULL THEN 
    NEW.ad1act := CASE WHEN length(NEW.ad1act) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad1act END;
  END IF;

  IF NEW.ad2act IS NOT NULL THEN 
    NEW.ad2act := CASE WHEN length(NEW.ad2act) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad2act END;
  END IF;

  IF NEW.ad3act IS NOT NULL THEN 
    NEW.ad3act := CASE WHEN length(NEW.ad3act) > 0 THEN SUBSTR(encode(gen_random_bytes(38), 'hex'),1,38) ELSE NEW.ad3act END;
  END IF;

  IF NEW.vilact IS NOT NULL THEN 
    NEW.vilact := CASE WHEN length(NEW.vilact) > 0 THEN SUBSTR(encode(gen_random_bytes(58), 'hex'),1,58) ELSE NEW.vilact END;
  END IF;

  IF NEW.telact IS NOT NULL THEN 
    NEW.telact := CASE WHEN length(NEW.telact) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.telact END;
  END IF;

  IF NEW.faxact IS NOT NULL THEN 
    NEW.faxact := CASE WHEN length(NEW.faxact) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.faxact END;
  END IF;

  IF NEW.cpoact IS NOT NULL THEN 
    NEW.cpoact := CASE WHEN NEW.cpoact IS NOT NULL THEN FLOOR(RANDOM()*(99999- 1) + 1) ELSE NEW.cpoact END;
  END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER geact_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".geact
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_geact();
       
CREATE OR REPLACE TRIGGER geact_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".geact
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_geact();

-- APMAILU
CREATE OR REPLACE FUNCTION "lidl_neowms".fnc_anonymise_apmailu()
RETURNS TRIGGER AS $$
BEGIN
  
  IF NEW.emladr IS NOT NULL THEN 
    NEW.emladr := CASE WHEN length(NEW.emladr) > 0 THEN SUBSTR(encode(gen_random_bytes(20), 'hex'),1,20) ELSE NEW.emladr END;
  END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER apmailu_before_update_anonymise
   BEFORE UPDATE
   ON "lidl_neowms".apmailu
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_apmailu();
       
CREATE OR REPLACE TRIGGER apmailu_before_insert_anonymise
   BEFORE INSERT
   ON "lidl_neowms".apmailu
    FOR EACH ROW
       EXECUTE FUNCTION "lidl_neowms".fnc_anonymise_apmailu();
	   
-- *************************************************
-- *     FORCE UPDATES
-- *************************************************

-- APUTI
UPDATE "lidl_neowms".aputi 
   SET nomuti = nomuti
      ,pasuti = pasuti;  

-- GECLI
UPDATE "lidl_neowms".gecli 
	SET ad1cli = ad1cli
	   ,ad2cli = ad2cli
	   ,ad3cli = ad3cli
	   ,vilcli = vilcli
	   ,telcli = telcli
	   ,faxcli = faxcli
	   ,cpocli = cpocli;

-- GEFOU
UPDATE "lidl_neowms".gefou 
	SET ad1fou = ad1fou
	   ,ad2fou = ad2fou
	   ,ad3fou = ad3fou
	   ,vilfou = vilfou
	   ,telfou = telfou
	   ,faxfou = faxfou
	   ,cpofou = cpofou
	   ,emladr = emladr;

-- GETRA
UPDATE "lidl_neowms".getra 
	SET ad1tra = ad1tra
	   ,ad2tra = ad2tra
	   ,ad3tra = ad3tra
	   ,viltra = viltra
	   ,teltra = teltra
	   ,faxtra = faxtra
	   ,cpotra = cpotra
	   ,emladr = emladr;

-- GEACT
UPDATE "lidl_neowms".geact 
	SET ad1act = ad1act
	   ,ad2act = ad2act
	   ,ad3act = ad3act
	   ,vilact = vilact
	   ,telact = telact
	   ,faxact = faxact
	   ,cpoact = cpoact;

-- APMAILU
UPDATE "lidl_neowms".apmailu 
	SET emladr = emladr;
	   
