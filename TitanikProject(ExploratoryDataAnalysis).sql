-- Joining all tables

SELECT TOP 10 PT1.*, TI2.fare, DT3.embarked, DT3.home_dest, CI4.pclass
FROM Titanik..Passengers_titanik PT1
JOIN Titanik..Ticket_info TI2
ON PT1.ticket = TI2.ticket
JOIN Titanik..Destination_titanik DT3
ON PT1.personal_id = DT3.ticket_id
JOIN Titanik..Cabine_info CI4
ON PT1.ticket = CI4.ticket

-- Precentage of people who survived vs died

SELECT if_survived, COUNT(if_survived) AS survival_rate, CONCAT(CAST(CAST(COUNT(if_survived) AS DECIMAL (10,2))
/CAST((SELECT COUNT(if_survived) FROM Titanik..Passengers_titanik) AS DECIMAL (10,2))AS DECIMAL (10,2))*100, ' %') AS percentage,
(SELECT COUNT(if_survived) FROM Titanik..Passengers_titanik WHERE if_survived <> 'Unknown') AS total
FROM Titanik..Passengers_titanik
WHERE if_survived <> 'Unknown'
GROUP BY if_survived
ORDER BY survival_rate 

-- Survived(The difference between gender)

WITH total_table1 AS
(
SELECT gender, COUNT(personal_id) AS total_passengers,
CONCAT(CAST(CAST(COUNT(personal_id)AS DECIMAL (10,2))/(SELECT COUNT(personal_id) FROM Titanik..Passengers_titanik) *100 AS DECIMAL(10,2)), ' %') AS gender_rate
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL
GROUP BY gender
), total_table2 AS
(
SELECT gender,COUNT(if_survived) AS count_suevived
FROM Titanik..Passengers_titanik
WHERE if_survived = 'Yes'
GROUP BY gender
)
SELECT tab1.gender , tab2.count_suevived, tab1.total_passengers, tab1.gender_rate, 
CONCAT(CAST((CAST(tab2.count_suevived AS DECIMAL(10,2))/tab1.total_passengers)*100 AS DECIMAL(10,2)), ' %') AS survival_rate
FROM total_table1 tab1
LEFT JOIN total_table2 tab2
ON tab1.gender = tab2.gender

-- Survived(The difference between age_variations)

WITH total_table3 AS
(
SELECT gender, variations, COUNT(if_survived) AS count_survived
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL AND if_survived = 'Yes'
GROUP BY gender, variations
), total_table4 AS
(
SELECT gender, variations, COUNT(personal_id) AS count_total
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL
GROUP BY gender, variations
)
SELECT tab3.gender, tab3.variations, tab3.count_survived, tab4.count_total,
CONCAT(CAST((CAST(tab3.count_survived AS DECIMAL(10,2))/tab4.count_total)*100 AS DECIMAL(10,2)), ' %') AS percent_survived
FROM total_table3 tab3
RIGHT JOIN total_table4 tab4
ON tab3.variations = tab4.variations AND tab3.gender = tab4.gender
ORDER BY gender, variations

--Survived(The difference between title name)

WITH total_table5 AS
(
SELECT title, COUNT(CASE WHEN if_survived = 'Yes' THEN 1 ELSE NULL END) AS count_survived
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL AND title <> ' Martin (Elizabeth L'
GROUP BY title
),total_table6 AS
(
SELECT title, COUNT(personal_id) AS count_total
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL AND title <> ' Martin (Elizabeth L'
GROUP BY title
)
SELECT tab6.title, tab5.count_survived, tab6.count_total, CONCAT(CAST((CAST(tab5.count_survived AS DECIMAL(10,2))/tab6.count_total)*100 AS DECIMAL(10,2)), ' %') AS percent_survived
FROM total_table5 tab5
RIGHT JOIN total_table6 tab6
ON tab5.title = tab6.title

--Another variant of the previous query

SELECT title, COUNT(CASE WHEN if_survived = 'Yes' THEN 1 ELSE NULL END) AS count_survived ,COUNT(personal_id) AS count_total,
CONCAT(CAST((CAST(COUNT(CASE WHEN if_survived = 'Yes' THEN 1 ELSE NULL END) AS DECIMAL(10,2))/COUNT(personal_id))*100 AS DECIMAL(10,2)), ' %') AS percent_survived
FROM Titanik..Passengers_titanik
WHERE gender IS NOT NULL AND title <> ' Martin (Elizabeth L'
GROUP BY title

--Grouping title names

WITH table_tem1 AS
(
SELECT
CASE
	WHEN TRIM(title) IN ('Dr', 'Rev', 'Col', 'Major', 'Jonkheer', 'Sir', 'Don', 'Capt') AND gender = 'Male' THEN 'Mr'
	WHEN TRIM(title) IN ('Mlle', 'Ms') AND gender = 'Female' THEN 'Miss'
	WHEN TRIM(title) IN ('Dr', 'the Countess', 'Mme', 'Lady', 'Dona','Martin (Elizabeth L') AND gender = 'Female' THEN 'Mrs'
	ELSE TRIM(title)
END AS grouping_title_names,
(CASE WHEN if_survived = 'Yes' THEN 1 ELSE NULL END) AS count_survived, personal_id
FROM Titanik..Passengers_titanik
WHERE title IS NOT NULL
)
SELECT grouping_title_names, COUNT(count_survived) AS count_survived, COUNT(personal_id) AS count_total, 
CONCAT(CAST((CAST(COUNT(count_survived)AS DECIMAL(10,2))/COUNT(personal_id))*100 AS DECIMAL(10,2)), ' %') AS percent_survived
FROM table_tem1
GROUP BY grouping_title_names
HAVING COUNT(count_survived) <> 0

--Survived(The difference between cabine class)

SELECT CI2.pclass, COUNT(CASE WHEN PT1.if_survived = 'Yes' THEN 1 ELSE NULL END) AS count_survived, COUNT(PT1.personal_id) AS count_total, 
CONCAT(CAST((CAST(COUNT(CASE WHEN PT1.if_survived = 'Yes' THEN 1 ELSE NULL END) AS DECIMAL(10,2))/COUNT(PT1.personal_id))*100 AS DECIMAL(10,2)), ' %') AS percent_survived
FROM Titanik..Passengers_titanik PT1
JOIN Titanik..Cabine_info CI2
ON PT1.ticket = CI2.ticket
GROUP BY CI2.pclass
ORDER BY CI2.pclass

--Survived(The difference between cabine class and gender)

SELECT CI2.pclass, COUNT(PT1.personal_id) AS count_total,
COUNT(CASE WHEN PT1.gender = 'Male' THEN 1 ELSE NULL END) AS male_count_total, COUNT(CASE WHEN PT1.gender = 'Female' THEN 1 ELSE NULL END) AS female_count_total,
CONCAT(CAST((CAST(COUNT(CASE WHEN PT1.gender = 'Male' AND PT1.if_survived = 'Yes' THEN 1 ELSE NULL END)AS DECIMAL(10,2))/COUNT(CASE WHEN PT1.gender = 'Male' THEN 1 ELSE NULL END))*100 AS DECIMAL(10,2)), ' %') AS male_survived_rate,
CONCAT(CAST((CAST(COUNT(CASE WHEN PT1.gender = 'Female' AND PT1.if_survived = 'Yes' THEN 1 ELSE NULL END)AS DECIMAL(10,2))/COUNT(CASE WHEN PT1.gender = 'Female' THEN 1 ELSE NULL END))*100 AS DECIMAL(10,2)), ' %') AS female_survived_rate,
COUNT(CASE WHEN PT1.gender = 'Male'AND PT1.if_survived = 'Yes' THEN 1 ELSE NULL END) AS male_count_survived, COUNT(CASE WHEN PT1.gender = 'Female' AND PT1.if_survived = 'Yes' THEN 1 ELSE NULL END) AS female_count_survived,
COUNT(CASE WHEN PT1.if_survived = 'Yes' THEN 1 ELSE NULL END) AS count_survived
FROM Titanik..Passengers_titanik PT1
JOIN Titanik..Cabine_info CI2
ON PT1.ticket = CI2.ticket
GROUP BY CI2.pclass
ORDER BY CI2.pclass

--The difference between family type

SELECT  
CASE 
	WHEN f.family_count = 1 AND f.count_passengers = 1 THEN 'alone' 
	WHEN f.family_count = 1 AND f.count_passengers > 1 THEN 'one_falmily' 
	WHEN f.family_count > 1 AND f.count_passengers > 1 THEN 'mix_falmily' 
ELSE '0' 
END AS type_falmily, COUNT(f.ticket) AS count_ticket, SUM(count_passengers) AS total_passengers
FROM 
(
SELECT ticket, COUNT(DISTINCT(family)) AS family_count,
COUNT(personal_id) AS count_passengers
FROM Titanik..Passengers_titanik
GROUP BY ticket
HAVING COUNT(DISTINCT(family)) <> 0
)f
GROUP BY CASE 
	WHEN f.family_count = 1 AND f.count_passengers = 1 THEN 'alone' 
	WHEN f.family_count = 1 AND f.count_passengers > 1 THEN 'one_falmily' 
	WHEN f.family_count > 1 AND f.count_passengers > 1 THEN 'mix_falmily' 
ELSE '0' 
END

--Survived(The difference between family type by gender)

SELECT  
CASE 
	WHEN f.family_count = 1 AND f.count_passengers = 1 THEN 'alone' 
	WHEN f.family_count = 1 AND f.count_passengers > 1 THEN 'one_falmily' 
	WHEN f.family_count > 1 AND f.count_passengers > 1 THEN 'mix_falmily' 
ELSE '0' 
END AS type_falmily, COUNT(f.ticket) AS count_ticket, SUM(f.male_count) AS male_count_survived, 
SUM(f.female_count) AS female_count_survived, SUM(count_passengers) AS count_passengers_total , SUM(survival_count) AS survival_count,
CONCAT(CAST((CAST(SUM(f.male_count)AS DECIMAL(10,2))/SUM(survival_count))*100 AS DECIMAL (10,2)), ' %') AS survival_rate_male,
CONCAT(CAST((CAST(SUM(f.female_count)AS DECIMAL(10,2))/SUM(survival_count))*100 AS DECIMAL (10,2)), ' %') AS survival_rate_female
FROM 
(
SELECT ticket, COUNT(DISTINCT(family)) AS family_count, COUNT(CASE WHEN gender = 'Male' AND if_survived = 'Yes' THEN 1 ELSE NULL END) AS male_count,
COUNT(CASE WHEN gender = 'Female' AND if_survived = 'Yes' THEN 1 ELSE NULL END) AS female_count,
COUNT(personal_id) AS count_passengers , COUNT(CASE WHEN if_survived = 'Yes' THEN 1 ELSE NULL END) AS survival_count
FROM Titanik..Passengers_titanik
GROUP BY ticket
HAVING COUNT(DISTINCT(family)) <> 0
)f
GROUP BY CASE 
	WHEN f.family_count = 1 AND f.count_passengers = 1 THEN 'alone' 
	WHEN f.family_count = 1 AND f.count_passengers > 1 THEN 'one_falmily' 
	WHEN f.family_count > 1 AND f.count_passengers > 1 THEN 'mix_falmily' 
ELSE '0' 
END