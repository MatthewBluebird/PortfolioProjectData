
-- Fixing price

SELECT CONCAT(CAST(fare AS DECIMAL(10,2)), ' $')
FROM Ticket_info

UPDATE Ticket_info 
SET fare = CAST(fare AS DECIMAL(10,2))

-- Fixing survived rate

SELECT survived,
CASE
	WHEN survived = 1 THEN 'Yes'
	WHEN survived = 0 THEN 'No'
	Else 'Unknown'
END
FROM Ticket_info

ALTER TABLE Ticket_info
ALTER COLUMN survived nvarchar(50)

UPDATE Ticket_info
SET survived = CASE
					WHEN survived = 1 THEN 'Yes'
					WHEN survived = 0 THEN 'No'
					Else 'Unknown'
				END

-- Fixing age

SELECT *
FROM Passengers_titanik

SELECT ROUND(age, 0)
FROM Passengers_titanik

UPDATE Passengers_titanik
SET age = ROUND(age, 0)

--Fixing name

ALTER TABLE Passengers_titanik
ADD first_name varchar(50),
last_name varchar(50),
title varchar(50)

SELECT *, PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),3),PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),2), PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),1)
FROM Passengers_titanik

SELECT *
FROM Passengers_titanik

EXEC sp_rename 'Passengers_titanik.first_name', 'family', 'COLUMN'
EXEC sp_rename 'Passengers_titanik.last_name', 'full_name', 'COLUMN'

BEGIN TRANSACTION;
UPDATE Passengers_titanik
SET family = PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),3)
COMMIT

ALTER TABLE Passengers_titanik
ALTER COLUMN full_name nvarchar(255)

BEGIN TRANSACTION;
UPDATE Passengers_titanik
SET full_name = PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),1)
COMMIT;

BEGIN TRANSACTION;
UPDATE Passengers_titanik
SET title = PARSENAME(REPLACE(REPLACE(name, ',', '.'), '"', ''),2)
COMMIT;

SELECT *
FROM Passengers_titanik

ALTER TABLE Passengers_titanik
DROP COLUMN name

-- Adding variations by age

SELECT *,
CASE
	WHEN age >= 0 AND age <= 20 THEN '0-20'
	WHEN age > 20 AND age <= 40 THEN '21-40'
	WHEN age > 40 AND age <= 60 THEN '41-60'
	WHEN age > 60 AND age <= 80 THEN '61-80'
	WHEN age IS NULL THEN 'Unknown'
	ELSE '81+'
END AS variations
FROM Passengers_titanik

ALTER TABLE Passengers_titanik
ADD variations nvarchar(50)

UPDATE Passengers_titanik
SET variations =	CASE
						WHEN age >= 0 AND age <= 20 THEN '0-20'
						WHEN age > 20 AND age <= 40 THEN '21-40'
						WHEN age > 40 AND age <= 60 THEN '41-60'
						WHEN age > 60 AND age <= 80 THEN '61-80'
						WHEN age IS NULL THEN 'Unknown'
						ELSE '81+'
					END

SELECT *
FROM Passengers_titanik

--
SELECT *,
CASE
	WHEN embarked = 'S' THEN 'England'
	WHEN embarked = 'C' THEN 'France'
	WHEN embarked = 'Q' THEN 'Ireland'
END
FROM Destination_titanik

BEGIN TRANSACTION;
UPDATE Destination_titanik
SET embarked = CASE
					WHEN embarked = 'S' THEN 'England'
					WHEN embarked = 'C' THEN 'France'
					WHEN embarked = 'Q' THEN 'Ireland'
				END
COMMIT;



SELECT *
FROM Ticket_info
JOIN Passengers_titanik
ON Ticket_info.ticket = Passengers_titanik.ticket

SELECT *
FROM Ticket_info
WHERE ticket = '24160'

SELECT *
FROM Passengers_titanik
WHERE ticket = '24160'

-- fixing incorrect connetion between colums

SELECT *
FROM Passengers_titanik

ALTER TABLE Passengers_titanik
ADD personal_id INT PRIMARY KEY IDENTITY(10001,1)

ALTER TABLE Ticket_info
DROP COLUMN personal_id

ALTER TABLE Ticket_info
ADD personal_id INT PRIMARY KEY IDENTITY(10001,1)

ALTER TABLE Passengers_titanik
ADD if_survived nvarchar(50) 

SELECT *
FROM Ticket_info
JOIN Passengers_titanik
ON Ticket_info.personal_id = Passengers_titanik.personal_id

BEGIN TRANSACTION;
UPDATE Passengers_titanik
SET Passengers_titanik.if_survived = Ticket_info.survived
FROM Ticket_info
WHERE Ticket_info.personal_id = Passengers_titanik.personal_id
COMMIT;

ALTER TABLE Ticket_info
DROP CONSTRAINT PK__Ticket_i__C16BAC15314BE4EA

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Ticket_info' AND CONSTRAINT_TYPE = 'PRIMARY KEY';

ALTER TABLE Ticket_info
DROP COLUMN personal_id

ALTER TABLE Ticket_info
DROP COLUMN survived



--Removing all dublications

WITH rem_dubs AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ticket ORDER BY ticket) AS dublications
FROM Ticket_info
)
SELECT *
FROM rem_dubs
WHERE dublications > 1

BEGIN TRANSACTION;
WITH rem_dubs AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ticket ORDER BY ticket) AS dublications
FROM Ticket_info
)
DELETE
FROM rem_dubs
WHERE dublications > 1
COMMIT;

WITH rem_dubs_cabine AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ticket ORDER BY ticket) AS dublications
FROM Cabine_info
)
SELECT *
FROM rem_dubs_cabine
WHERE dublications > 1

BEGIN TRANSACTION;
WITH rem_dubs_cabine AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ticket ORDER BY ticket) AS dublications
FROM Cabine_info
)
DELETE
FROM rem_dubs_cabine
WHERE dublications > 1
COMMIT;

SELECT *
FROM Cabine_info
WHERE cabin = 'C22 C26'

ALTER TABLE Cabine_info
DROP COLUMN cabin

--Checking the connections

SELECT *
FROM Ticket_info
JOIN Passengers_titanik
ON Ticket_info.ticket = Passengers_titanik.ticket
JOIN Destination_titanik
ON Passengers_titanik.personal_id = Destination_titanik.ticket_id
JOIN Cabine_info
ON Passengers_titanik.ticket = Cabine_info.ticket




















