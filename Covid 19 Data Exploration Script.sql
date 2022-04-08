/*
Covid 19 Data Exploration 
Link to Dataset: https://ourworldindata.org/covid-deaths
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


Select *
From owid_covid_data_csv
Where continent is not null 
order by 3,4



-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From  owid_covid_death_data_csv
Where continent is not null 
order by 2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, 
	(cast(total_deaths as real)/ cast(total_cases as real))*100 as DeathPercentage
From owid_covid_death_data_csv
Where location like '%states%'
and continent is not null 
--order by 1

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid by Location

Select Location, date, Population, total_cases, 
	(cast(total_cases as real)/ cast(population as real))*100 as PercentPopulationInfected
From owid_covid_death_data_csv
Where location like '%states%'
order by 1

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, 
	MAX(total_cases) as HighestInfectionCount,  
	MAX((cast(total_cases as real)/ cast(population as real)))*100 as PercentPopulationInfected
From owid_covid_death_data_csv
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Rate compared to Population

Select Location, Population, 
	MAX((cast(total_deaths as real)/ cast(population as real)))*100 as PercentPopulationDeaths
From owid_covid_death_data_csv
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationDeaths desc


-- Locations with Highest Death Count per Population

Select Location, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
From owid_covid_death_data_csv
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
From owid_covid_death_data_csv
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From owid_covid_death_data_csv
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1


-- Join two tables 

Select *
From owid_covid_death_data_csv dea
join owid_covid_vax_data_csv vac 
	on dea.location = vac.location 
	and dea.date = vac.date 
	
	
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingTotalPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From owid_covid_death_data_csv dea
Join owid_covid_vax_data_csv vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3