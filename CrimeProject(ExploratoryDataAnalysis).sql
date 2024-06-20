USE Crime

SELECT *
FROM Crime_main

--procentage by Gender

SELECT gender, CAST((COUNT(gender)/(SELECT CAST(COUNT(crime_id) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS procentage_by_gender
FROM Crime_main
GROUP BY gender

--procentage by Description area

SELECT premis_desc, CAST((COUNT(premis_desc)/(SELECT CAST(COUNT(crime_id) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS procentage_by_description_area
FROM Crime_main
GROUP BY premis_desc

--procentage by Status

SELECT status, CAST((COUNT(status)/(SELECT CAST(COUNT(crime_id) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS procentage_by_status
FROM Crime_main
GROUP BY status

--procentage by Area name

SELECT area_name, CAST((COUNT(area_name)/(SELECT CAST(COUNT(crime_id) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS procentage_by_area_name
FROM Crime_main
GROUP BY area_name

--procentage by Weapon

SELECT weapon, CAST((COUNT(weapon)/(SELECT CAST(COUNT(crime_id) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS procentage_by_weapon
FROM Crime_main
GROUP BY weapon

-- crimes by Years

SELECT DATEPART(YEAR ,reported_date) AS separate_years, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY DATEPART(YEAR ,reported_date)
ORDER BY separate_years

-- crimes by Month

SELECT DATENAME(MONTH ,reported_date) AS separate_month, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY DATENAME(MONTH ,reported_date), DATEPART(MONTH ,reported_date)
ORDER BY DATEPART(MONTH ,reported_date)

-- crimes by Weekly

SELECT DATENAME(DW ,reported_date) AS separate_dw, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY DATENAME(DW ,reported_date), DATEPART(DW ,reported_date)
ORDER BY DATEPART(DW ,reported_date)

-- crimes by Time

SELECT DATEPART(HOUR ,occurrence_time) AS separate_hour, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY DATEPART(HOUR ,occurrence_time)
ORDER BY separate_hour

-- procentage Gender by area name

SELECT gender, area_name, CAST((COUNT(gender)/(SELECT CAST(COUNT(area_name) AS DECIMAL(10,2)) FROM Crime_main)*100) AS DECIMAL(10,2)) AS gender_by_area_name
FROM Crime_main
WHERE gender = 'Male' OR gender = 'Female'
GROUP BY area_name ,gender
ORDER BY area_name

-- crimes by Gender

SELECT gender, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY gender
ORDER BY crimes DESC

-- crimes by Weapon

SELECT weapon, COUNT(crime_id) AS crimes
FROM Crime_main
GROUP BY weapon
ORDER BY crimes DESC

-- crimes by adult and juv arest (male)

SELECT status, COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Male' AND (status = 'Adult Arrest' OR status = 'Juv Arrest')
GROUP BY status
ORDER BY status

-- crimes by adult and juv arest (Female)

SELECT status, COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Female' AND (status = 'Adult Arrest' OR status = 'Juv Arrest')
GROUP BY status
ORDER BY status

-- Difference between male and female by adult arrest

SELECT status, 
ABS((SELECT COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Male' AND (status = 'Adult Arrest')
GROUP BY status
)-
(SELECT COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Female' AND (status = 'Adult Arrest')
GROUP BY status
)) AS difference_crimes
FROM Crime_main
WHERE status = 'Adult Arrest'
GROUP BY status

-- Difference between male and female by juv arrest

SELECT status, 
ABS((SELECT COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Male' AND (status = 'Juv Arrest')
GROUP BY status
)-
(SELECT COUNT(crime_id) AS crimes
FROM Crime_main
WHERE gender = 'Female' AND (status = 'Juv Arrest')
GROUP BY status
)) AS difference_crimes
FROM Crime_main
WHERE status = 'Juv Arrest'
GROUP BY status

-- crimes in Living house by male and female

SELECT gender, COUNT(crime_id) AS living_house_crimes
FROM Crime_main
WHERE Premis_Desc = 'Living House' AND (gender = 'Male' OR gender = 'Female')
GROUP BY gender

-- crimes on Street by male and female by month

SELECT gender, COUNT(crime_id) AS street_crimes, DATENAME(MONTH, reported_date) AS different_month
FROM Crime_main
WHERE Premis_Desc = 'On Street' AND (gender = 'Male' OR gender = 'Female')
GROUP BY gender, DATENAME(MONTH, reported_date), DATEPART(MONTH, reported_date)
ORDER BY DATEPART(MONTH, reported_date)

-- crimes in Living house by male and female by year

SELECT gender, COUNT(crime_id) AS living_house_crimes ,DATEPART(YEAR, reported_date) AS different_year
FROM Crime_main
WHERE Premis_Desc = 'Living House' AND (gender = 'Male' OR gender = 'Female')
GROUP BY gender ,DATEPART(YEAR, reported_date)
ORDER BY DATEPART(YEAR, reported_date)

-- the Highest day

SELECT reported_date, COUNT(crime_id) AS crime
FROM Crime_main
GROUP BY reported_date
ORDER BY crime DESC










