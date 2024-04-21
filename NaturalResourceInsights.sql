/*
Project Two: SQL Data Exploration - Natural Resources (Gas, Coal, Oil)

The following data used can be found on this website: https://ourworldindata.org/explorers/natural-resources

This project takes a closer look at some of the insights I found with natural resources!
*/

-- First, we can look at the general fields we have from each of the tables I created from the dataset:

SELECT *
FROM PortfolioProject..NaturalGas
ORDER BY 16

SELECT *
FROM PortfolioProject..NaturalCoal
ORDER BY 16

SELECT *
FROM PortfolioProject..NaturalOil
ORDER BY 16


-- Now, I will look at specific data I want to use for my insights. Below are all three tables listed out with specific columns I will focus on:

SELECT NaturalGas.Entity, NaturalGas.Year, NaturalGas.Population, NaturalGas.[Gas production], NaturalGas.[Gas consumption], NaturalGas.[Gas reserves]
FROM PortfolioProject..NaturalGas

SELECT NaturalOil.Entity, NaturalOil.Year, NaturalOil.Population, NaturalOil.[Oil production], NaturalOil.[Oil consumption], NaturalOil.[Oil reserves]
FROM PortfolioProject..NaturalOil

SELECT NaturalCoal.Entity, NaturalCoal.Year, NaturalCoal.Population, NaturalCoal.[Coal production], NaturalCoal.[Coal consumption], NaturalCoal.[Coal reserves]
FROM PortfolioProject..NaturalCoal

SELECT NaturalGas.Entity, NaturalGas.Year, NaturalGas.Population, NaturalGas.[Gas production per capita], NaturalGas.[Gas consumption per capita], NaturalGas.[Gas exports per capita], NaturalGas.[Gas imports per capita], NaturalGas.[Gas reserves per capita]
FROM PortfolioProject..NaturalGas

SELECT NaturalOil.Entity, NaturalOil.Year, NaturalOil.Population, NaturalOil.[Oil production per capita], NaturalOil.[Oil consumption per capita], NaturalOil.[Oil exports per capita], NaturalOil.[Oil imports per capita], NaturalOil.[Oil reserves per capita]
FROM PortfolioProject..NaturalOil

SELECT NaturalCoal.Entity, NaturalCoal.Year, NaturalCoal.Population, NaturalCoal.[Coal production per capita], NaturalCoal.[Coal consumption per capita], NaturalCoal.[Coal exports per capita], NaturalCoal.[Coal imports per capita], NaturalCoal.[Coal reserves per capita]
FROM PortfolioProject..NaturalCoal

-- Looking at the highest amount of Gas consumption vs. production by country
-- In 1986, Canadians had 74.42% of gas consumption in comparison to production, making it the highest in Canadian history.
-- As for the World's highest, Moldova had the highest amount of consumption versus production in 2019!

SELECT NaturalGas.Entity, NaturalGas.Year, NaturalGas.Population, NaturalGas.[Gas consumption], NaturalGas.[Gas production], (cast(NaturalGas.[Gas consumption] as float)/cast(NULLIF(NaturalGas.[Gas production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalGas
-- WHERE NaturalGas.Entity like '%canada%'
ORDER BY 6 DESC

-- Looking at highest amount of Gas consumption vs. population by country
-- On average, Qatar consumes the most amount of natural gas based on its population size!

SELECT NaturalGas.Entity, NaturalGas.Year, NaturalGas.Population, NaturalGas.[Gas consumption], NaturalGas.[Gas production], (cast(NaturalGas.[Gas consumption] as float)/cast(NaturalGas.Population as float))*100 AS ConsVsPopPercentage
FROM PortfolioProject..NaturalGas
ORDER BY 6 DESC

-- Looking at highest amount of Oil consumption vs. production by country
-- in 1993, Sweden has the highest amount of oil consumption vs. production

SELECT NaturalOil.Entity, NaturalOil.Year, NaturalOil.Population, NaturalOil.[Oil consumption], NaturalOil.[Oil production], (cast(NaturalOil.[Oil consumption] as float)/cast(NULLIF(NaturalOil.[Oil production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalOil
--WHERE Entity LIKE '%canada%'
ORDER BY 6 DESC

-- Looking at highest amount of Coal consumption vs. production by country
-- Notice that in 2006, Morocco had the highest amount of coal consumption vs production!

SELECT NaturalCoal.Entity, NaturalCoal.Year, NaturalCoal.Population, NaturalCoal.[Coal consumption], NaturalCoal.[Coal production], (cast(NaturalCoal.[Coal consumption] as float)/cast(NULLIF(NaturalCoal.[Coal production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalCoal
--WHERE Entity LIKE '%canada%'
ORDER BY 6 DESC

-- Looking at the highest amount of natural resources (gas, oil, coal) consumed and produced by country
-- Based on this query, the United States consumes the highest amount of natural resources.

SELECT Gas.Entity, Gas.Year, Gas.[Population], Gas.[Gas consumption], Gas.[Gas reserves], Gas.[Gas imports], Oil.[Oil consumption], Oil.[Oil reserves], Oil.[Oil imports], Coal.[Coal consumption], Coal.[Coal reserves], Coal.[Coal imports]
FROM PortfolioProject..NaturalGas Gas
JOIN NaturalOil Oil
	ON Gas.Entity = Oil.Entity
JOIN NaturalCoal Coal
	ON Gas.Entity = Coal.Entity
WHERE Oil.[Oil consumption] IS NOT NULL AND Coal.[Coal consumption] IS NOT NULL
ORDER BY 4 DESC

-- Now, we can create views from these insights:
-- These views can be used to look at top 10, bottom 10, etc.

CREATE VIEW GasPercentageConsumedVsProduced AS
SELECT NaturalGas.Entity, NaturalGas.Year, NaturalGas.Population, NaturalGas.[Gas consumption], NaturalGas.[Gas production], (cast(NaturalGas.[Gas consumption] as float)/cast(NULLIF(NaturalGas.[Gas production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalGas
-- WHERE NaturalGas.Entity like '%canada%'
--ORDER BY 6 DESC

CREATE VIEW OilPercentageConsumedVsProduced AS
SELECT NaturalOil.Entity, NaturalOil.Year, NaturalOil.Population, NaturalOil.[Oil consumption], NaturalOil.[Oil production], (cast(NaturalOil.[Oil consumption] as float)/cast(NULLIF(NaturalOil.[Oil production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalOil
--WHERE Entity LIKE '%canada%'
--ORDER BY 6 DESC

CREATE VIEW CoalPercentageConsumedVsProduced AS
SELECT NaturalCoal.Entity, NaturalCoal.Year, NaturalCoal.Population, NaturalCoal.[Coal consumption], NaturalCoal.[Coal production], (cast(NaturalCoal.[Coal consumption] as float)/cast(NULLIF(NaturalCoal.[Coal production], 0) as float))*100 AS ConsVsProdPercentage
FROM PortfolioProject..NaturalCoal
--WHERE Entity LIKE '%canada%'
--ORDER BY 6 DESC