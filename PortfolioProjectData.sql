SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4



SELECT *
FROM CovidVaccinations
ORDER BY 3,4



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



--Total Cases vs Total Deaths
--Percentage of dying when you got the COVID

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location like 'Canada' and continent IS NOT NULL
ORDER BY 1,2



--Total Cases vs Population
--Shows what percentage of population got COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS CovidGotPercentage
FROM CovidDeaths
WHERE location like 'Canada' and continent IS NOT NULL
ORDER BY 1,2



-- Countries with the Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS CovidGotPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY CovidGotPercentage DESC



-- Countries with the Highest Death Count per Population

SELECT location, MAX(CAST(Total_deaths AS INT)) AS HighestDeathCount ,population
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP by location, population
ORDER BY HighestDeathCount DESC



--Continents

SELECT continent, MAX(CAST(Total_deaths AS INT)) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP by continent
ORDER BY HighestDeathCount DESC



--Continents with the highest death count per population

SELECT continent, MAX(CAST(Total_deaths AS INT)) AS HighestDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP by continent
ORDER BY HighestDeathCount DESC



-- Global Numbers

SELECT SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS INT)) AS Total_death, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2



-- Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2



--CTE

WITH PopVsVaccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population)*100 AS VaccinatedProcentage
FROM PopVsVaccination



--TempTable

DROP TABLE IF EXISTS #PercentaPopulationVaccinated
CREATE TABLE #PercentaPopulationVaccinated
(
Continent nvarchar(255),
Location varchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentaPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100 AS VaccinatedProcentage
FROM #PercentaPopulationVaccinated



--View to store data

CREATE VIEW PercentaPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentaPopulationVaccinated









