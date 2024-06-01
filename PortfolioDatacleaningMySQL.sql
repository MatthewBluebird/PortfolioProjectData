SELECT *
FROM layoffs;

-- Remove Duplicates
-- Standardize the Data
-- Null Values or blank values
-- Remove Any Columns

CREATE TABLE layoffs_changins
LIKE layoffs;

INSERT INTO layoffs_changins
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_changins2;


WITH dublicate_cte AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY company, industry, location, stage, country , total_laid_off, percentage_laid_off, funds_raised_millions, `date` ORDER BY country) AS dublcation_rows
FROM layoffs_changins
)
SELECT *
FROM dublicate_cte
WHERE dublcation_rows > 1;


CREATE TABLE `layoffs_changins2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `dublcation_rows` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_changins2
SELECT *, ROW_NUMBER() OVER (PARTITION BY company, industry, location, stage, country , total_laid_off, percentage_laid_off, funds_raised_millions, `date` ORDER BY country) AS dublcation_rows
FROM layoffs_changins;

SELECT *
FROM layoffs_changins2
WHERE dublcation_rows > 1;

-- Standardize the Data

SELECT company, TRIM(company)
FROM layoffs_changins2;

UPDATE layoffs_changins2
SET company = TRIM(company);

SELECT *
FROM layoffs_changins2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_changins2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_changins2
WHERE country LIKE 'United States%';

UPDATE layoffs_changins2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Date format

SELECT `date`
FROM layoffs_changins2;

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_changins2;

UPDATE layoffs_changins2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Changing data type

ALTER TABLE layoffs_changins2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_changins2;

-- working with nulls

SELECT * 
FROM layoffs_changins2
WHERE industry IS NULL;

UPDATE layoffs_changins2
SET industry = NULL
WHERE industry = '';

SELECT f1.industry, f2.industry
FROM layoffs_changins2 f1
JOIN layoffs_changins2 f2
	ON f1.company = f2.company
WHERE f1.industry IS NULL AND f2.industry IS NOT NULL;

UPDATE layoffs_changins2 f1
JOIN layoffs_changins2 f2
	ON f1.company = f2.company
SET f1.industry = f2.industry
WHERE f1.industry IS NULL AND f2.industry IS NOT NULL;


SELECT *
FROM layoffs_changins2;

ALTER TABLE layoffs_changins2
DROP COLUMN dublcation_rows;

























