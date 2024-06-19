--Fixing the id

SELECT *
FROM Crime_main

ALTER TABLE Crime_main
ADD crime_id INT

SELECT SUBSTRING(REPLACE(REPLACE(DR_NO, ':',''),'.',''), 1, 9) AS crime_id
FROM Crime_main

UPDATE Crime_main
SET crime_id = SUBSTRING(REPLACE(REPLACE(DR_NO, ':',''),'.',''), 1, 9)

ALTER TABLE Crime_main
DROP COLUMN DR_NO

--Fixing the dates(rptd,occ,time)+ rename

ALTER TABLE Crime_main
ALTER COLUMN Date_Rptd DATE

ALTER TABLE Crime_main
ALTER COLUMN DATE_OCC DATE

ALTER TABLE Crime_main
ALTER COLUMN TIME_OCC TIME(0)

EXEC sp_rename 'Crime_main.Date_Rptd', 'reported_date', 'COLUMN'
EXEC sp_rename 'Crime_main.DATE_OCC', 'occurrence_date', 'COLUMN'
EXEC sp_rename 'Crime_main.TIME_OCC', 'occurrence_time', 'COLUMN'
EXEC sp_rename 'Crime_main.AREA', 'area', 'COLUMN'
EXEC sp_rename 'Crime_main.AREA_NAME', 'area_name', 'COLUMN'
EXEC sp_rename 'Crime_main.Vict_Sex', 'gender', 'COLUMN'
EXEC sp_rename 'Crime_main.Premis_Desc', 'premis_desc', 'COLUMN'
EXEC sp_rename 'Crime_main.Weapon_Desc', 'weapon', 'COLUMN'
EXEC sp_rename 'Crime_main.Status_Desc', 'status', 'COLUMN'
EXEC sp_rename 'Crime_main.LOCATION', 'location', 'COLUMN'

--Cleaning(not need data)

ALTER TABLE Crime_main
DROP COLUMN Rpt_Dist_No

ALTER TABLE Crime_main
DROP COLUMN Part_1_2

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd

ALTER TABLE Crime_main
DROP COLUMN Mocodes

ALTER TABLE Crime_main
DROP COLUMN Vict_Age

ALTER TABLE Crime_main
DROP COLUMN Premis_Cd

ALTER TABLE Crime_main
DROP COLUMN Weapon_Used_Cd

ALTER TABLE Crime_main
DROP COLUMN Status

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd_1

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd_2

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd_3

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd_4

ALTER TABLE Crime_main
DROP COLUMN Vict_Descent

ALTER TABLE Crime_main
DROP COLUMN Cross_Street

ALTER TABLE Crime_main
DROP COLUMN Crm_Cd_Desc

--Changing the data

SELECT Vict_sex, COUNT(crime_id)
FROM Crime_main
GROUP BY Vict_sex

DELETE
FROM Crime_main
WHERE Vict_sex = 'H'

DELETE
FROM Crime_main
WHERE Vict_sex IS NULL

DELETE
FROM Crime_main
WHERE Vict_sex = '-'

SELECT Vict_sex,
CASE
	WHEN Vict_sex = 'F' THEN 'Female'
	WHEN Vict_sex = 'M' THEN 'Male'
	WHEN Vict_sex = 'X' THEN 'Unknown'
END 
FROM Crime_main

UPDATE Crime_main
SET Vict_sex =	CASE
					WHEN Vict_sex = 'F' THEN 'Female'
					WHEN Vict_sex = 'M' THEN 'Male'
					WHEN Vict_sex = 'X' THEN 'Unknown'
				END

SELECT *
FROM Crime_main

--reserv copy

SELECT *
INTO crime_reserv
FROM Crime_main

---------------


SELECT Premis_Desc, COUNT(crime_id)
FROM Crime_main
GROUP BY Premis_Desc
ORDER BY COUNT(crime_id) DESC

SELECT Premis_Desc, COUNT(crime_id),
CASE
	WHEN Premis_Desc = 'SINGLE FAMILY DWELLING' OR Premis_Desc = 'MULTI-UNIT DWELLING (APARTMENT, DUPLEX, ETC)' THEN 'Living House'
	WHEN Premis_Desc = 'STREET' OR Premis_Desc = 'SIDEWALK' OR Premis_Desc = 'DRIVEWAY' OR Premis_Desc = 'PARKING LOT' THEN 'On Street'
	WHEN Premis_Desc = 'VEHICLE, PASSENGER/TRUCK' OR Premis_Desc = 'GARAGE/CARPORT' THEN 'Truck'
	WHEN Premis_Desc = 'RESTAURANT/FAST FOOD' OR Premis_Desc = 'DEPARTMENT STORE' OR Premis_Desc = 'OTHER BUSINESS' THEN 'Store'
	ELSE 'Others'
END
FROM Crime_main
GROUP BY Premis_Desc
ORDER BY COUNT(crime_id) DESC

BEGIN TRANSACTION;
UPDATE Crime_main
SET Premis_Desc =	CASE
						WHEN Premis_Desc = 'SINGLE FAMILY DWELLING' OR Premis_Desc = 'MULTI-UNIT DWELLING (APARTMENT, DUPLEX, ETC)' THEN 'Living House'
						WHEN Premis_Desc = 'STREET' OR Premis_Desc = 'SIDEWALK' OR Premis_Desc = 'DRIVEWAY' OR Premis_Desc = 'PARKING LOT' THEN 'On Street'
						WHEN Premis_Desc = 'VEHICLE, PASSENGER/TRUCK' OR Premis_Desc = 'GARAGE/CARPORT' THEN 'Truck'
						WHEN Premis_Desc = 'RESTAURANT/FAST FOOD' OR Premis_Desc = 'DEPARTMENT STORE' OR Premis_Desc = 'OTHER BUSINESS' THEN 'Store'
						ELSE 'Others'
					END;
COMMIT;

SELECT Weapon_Desc, COUNT(crime_id)
FROM Crime_main
GROUP BY Weapon_Desc
ORDER BY COUNT(crime_id) DESC

SELECT Weapon_Desc, COUNT(crime_id),
CASE
	WHEN Weapon_Desc = 'STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)' OR Weapon_Desc = 'VERBAL THREAT' THEN 'Hands'
	WHEN Weapon_Desc = 'HAND GUN' OR Weapon_Desc = 'SEMI-AUTOMATIC PISTOL' THEN 'Pistol'
	WHEN Weapon_Desc = 'KNIFE WITH BLADE 6INCHES OR LESS' OR Weapon_Desc = 'OTHER KNIFE' THEN 'Knife'
	WHEN Weapon_Desc = 'VEHICLE' THEN 'Vehicle'
	ELSE 'Others'
END
FROM Crime_main
GROUP BY Weapon_Desc
ORDER BY COUNT(crime_id) DESC

BEGIN TRANSACTION;
UPDATE Crime_main
SET Weapon_Desc =	CASE
						WHEN Weapon_Desc = 'STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)' OR Weapon_Desc = 'VERBAL THREAT' THEN 'Hands'
						WHEN Weapon_Desc = 'HAND GUN' OR Weapon_Desc = 'SEMI-AUTOMATIC PISTOL' THEN 'Pistol'
						WHEN Weapon_Desc = 'KNIFE WITH BLADE 6INCHES OR LESS' OR Weapon_Desc = 'OTHER KNIFE' THEN 'Knife'
						WHEN Weapon_Desc = 'VEHICLE' THEN 'Vehicle'
						ELSE 'Others'
					END
COMMIT;

SELECT Status_Desc, COUNT(crime_id)
FROM Crime_main
GROUP BY Status_Desc
ORDER BY COUNT(crime_id) DESC

SELECT Status_Desc
FROM Crime_main
WHERE Status_Desc = 'UNK'

DELETE
FROM Crime_main
WHERE Status_Desc = 'UNK'

-- Correcting location

SELECT LOCATION, SUBSTRING((TRIM(LOCATION)),1 , CHARINDEX('     ', LOCATION))
FROM Crime_main

BEGIN TRANSACTION;
UPDATE Crime_main
SET LOCATION = SUBSTRING((TRIM(LOCATION)),1 , CHARINDEX('     ', LOCATION))
COMMIT;

SELECT LOCATION
FROM Crime_main

BEGIN TRANSACTION
DELETE
FROM Crime_main
WHERE LOCATION = ' '
COMMIT;

SELECT *, LEN(LOCATION)
FROM Crime_main
WHERE LEN(LOCATION) <= 10

BEGIN TRANSACTION
DELETE
FROM Crime_main
WHERE LEN(LOCATION) <= 10
COMMIT;
-------------------------
DELETE
FROM Crime_main
WHERE crime_id IS NULL

-- Dublications check

WITH CT_T AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY crime_id, reported_date ORDER BY reported_date) AS dubs
FROM Crime_main
)
SELECT *
FROM CT_T
WHERE dubs > 1




