/*
Project One: SQL Data Exploration - COVID-19 Deaths & Vaccinations

The following source data was pulled from: https://ourworldindata.org/covid-deaths
*/

SELECT *
FROM ProjectOne..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM ProjectOne..CovidVaccinations
--ORDER BY 3,4

-- Data being used for project:

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM ProjectOne..CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs. Total Deaths
-- In Canada, June 2020 showed the highest likelyhood of dying if you contracted COVID-19, with ~8.27% being the chances of death.

SELECT Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 AS DeathPercentage
FROM ProjectOne..CovidDeaths
WHERE location like '%canada%'
ORDER BY 1,2

-- Looking at Total Cases vs. Population
-- By March 30, 2024, roughly ~12.4% of Canadians had tested positive for COVID-19.

SELECT Location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 AS CasesPercentage
FROM ProjectOne..CovidDeaths
WHERE location like '%canada%'
ORDER BY 1,2

-- Looking at Countries with the Highest Case Rate vs. the Population
-- Latvia has the highest case rate, with 52% of its population being tested positive for COVID-19 at its peak.

SELECT Location, population, MAX(total_cases) AS HighestCaseCount, (cast(MAX(total_cases) as float)/cast(population as float))*100 as CaseRate
FROM ProjectOne..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY population, location
ORDER BY CaseRate DESC

-- Looking at the highest death count by Country
-- USA seems to the highest death count from the start of the Pandemic to now.

SELECT location, MAX(cast(total_deaths as int)) as DeathCount
FROM ProjectOne..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY DeathCount DESC

-- To further dive into this death count, we can also look at it via the continents
-- Notice that North America has the highest death count recorded in comparison to the other Continents.

SELECT continent, MAX(cast(total_deaths as int)) as DeathCount
FROM ProjectOne..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathCount DESC

-- To broaden this even further out, we can look at the entire World's death toll (in percentage)
-- Notice that from the world's data, <1% of the world's population has passed away due to COVID-19.

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM ProjectOne..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

/*
Now, to Explore Covid Vaccinations data with Covid Deaths data:
*/

-- Looking at Total Population vs. Vaccinations
-- This is using a CTE, where we are able to show the percentage of people vaccinated based on the populations per day!

WITH TotalPopvsVaccs (Continent, Location, Date, Population, New_Vaccinations, CumulativeCountOfPeopleVaccinated)
as
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
	SUM(CONVERT(int, vacs.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS CumulativeCountOfPeopleVaccinated
FROM ProjectOne..CovidDeaths deaths
JOIN ProjectOne..CovidVaccinations vacs
	ON deaths.location = vacs.location AND deaths.date = vacs.date
WHERE deaths.continent IS NOT NULL
)

SELECT *, (CumulativeCountOfPeopleVaccinated/Population)*100
FROM TotalPopvsVaccs

-- Now, we can create a temp table to see this via a different perspective

DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CumulativeCountOfPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
	SUM(CONVERT(bigint, vacs.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS CumulativeCountOfPeopleVaccinated
FROM ProjectOne..CovidDeaths deaths
JOIN ProjectOne..CovidVaccinations vacs
	ON deaths.location = vacs.location AND deaths.date = vacs.date
WHERE deaths.continent IS NOT NULL


SELECT *, (CumulativeCountOfPeopleVaccinated/Population)*100
FROM #PercentagePopulationVaccinated

-- Now, we can create a view to make it easier when looking at the data

CREATE VIEW PercentagePopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
	SUM(CONVERT(bigint, vacs.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS CumulativeCountOfPeopleVaccinated
FROM ProjectOne..CovidDeaths deaths
JOIN ProjectOne..CovidVaccinations vacs
	ON deaths.location = vacs.location AND deaths.date = vacs.date
WHERE deaths.continent IS NOT NULL