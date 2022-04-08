/*
Queries used for Tableau Project
*/



-- 1. Death Percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From owid_covid_death_data_csv  
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- 2. Death Count

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From owid_covid_death_data_csv  
--Where location like '%states%'
Where continent is not null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3. Percent of Population Infected

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((cast(total_cases as real)/cast(population as real)))*100 as PercentPopulationInfected
From owid_covid_death_data_csv  
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4. Percent of Population Infected Over Time


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,   Max((cast(total_cases as real)/cast(population as real)))*100 PercentPopulationInfected
From owid_covid_death_data_csv  
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc