SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

SELECT location, date, population, total_cases, new_cases, total_deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Nigeria' and continent is not null
ORDER BY 1,2

SELECT location, date, population, total_cases, (total_cases/population)*100 as PopulationPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Nigeria' and continent is not null
ORDER BY 1,2

SELECT location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as HighestInfectionPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestInfectionPercentage desc

SELECT location, MAX(total_deaths) as HighestDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY location 
ORDER BY HighestDeathCount desc

SELECT location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as HighestDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestDeathPercentage desc

SELECT continent, MAX(total_deaths) as HighestDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeathCount desc

SELECT continent, location, population, MAX(total_deaths) as HighestDeathCount, (MAX(total_deaths)/population)*100 as ContinentDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY continent, location, population
ORDER BY ContinentDeathPercentage desc

SELECT date, SUM(new_cases) AS Totalnew_cases, SUM(new_deaths) AS Totalnew_deaths,
(SUM(new_deaths)/SUM(NEW_cases))*100 as GlobalDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE new_cases > 0 and continent is not null and new_deaths is not null
GROUP BY date
ORDER BY 1,2

SELECT death.continent, death.location, death.date, death.population, 
vaccin.new_vaccinations, SUM(CAST(vaccin.new_vaccinations AS bigint)) 
OVER (Partition by death.location ORDER BY death.location, death.date) as TotalPeopleVaccination
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
ON death.location = vaccin.location
and death.date = vaccin.date
WHERE death.continent is not null
ORDER BY 2,3

With DeavsVac (continent,location, date, population, new_vaccinations, TotalPeopleVaccination) 
as
(
SELECT death.continent, death.location, death.date, death.population, 
vaccin.new_vaccinations, SUM(CAST(vaccin.new_vaccinations AS bigint)) 
OVER (Partition by death.location ORDER BY death.location, death.date) as TotalPeopleVaccination
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
ON death.location = vaccin.location
and death.date = vaccin.date
WHERE death.continent is not null
--ORDER BY 2,3
)
SELECT *, (TotalPeopleVaccination/population)*100 as TotalPeopleVaccinationPercentage
FROM DeavsVac

CREATE View ContinentDeathPercentage as
SELECT continent, location, population, MAX(total_deaths) as HighestDeathCount, (MAX(total_deaths)/population)*100 as ContinentDeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location = 'Nigeria'
WHERE continent is not null
GROUP BY continent, location, population
--ORDER BY ContinentDeathPercentage desc