
SELECT *
FROM layoffs_changins2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_changins2;

SELECT *
FROM layoffs_changins2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- total laid offs

SELECT company, SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- date

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

SELECT MONTH(`date`), SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY MONTH(`date`)
ORDER BY 1;

-- Rolling_total

WITH CTE_laid_off AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
FROM layoffs_changins2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total
FROM CTE_laid_off;

-- Ranking

WITH Company_year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_changins2
GROUP BY company, YEAR(`date`)
), Compaby_Year_rank AS (
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Compaby_Year_rank
WHERE Ranking <=5;



