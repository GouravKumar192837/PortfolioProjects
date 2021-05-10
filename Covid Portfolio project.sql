Select *
From PortfolioProject..CovidDeaths 
where continent is not null
order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--Show the likelihood of dying if get the virus
Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject..CovidDeaths
Where location = 'INDIA'
order by 1,2

--Looking at the total cases vs Population
Select location,date,population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location = 'INDIA'
order by 1,2

--Loooking at countries with highest infection rate compared to population
Select location,population,MAX(total_cases) as infection_Count, Max((total_cases/population))*100 as MaxPercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location,population
order by MaxPercentPopulationInfected desc

-- Showing the countries with the highest deathcount per population
Select location,MAX(cast(total_deaths as int)) as death_Count
From PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by death_Count desc

--Showing the continents with the highest deathcount per population
Select continent,MAX(cast(total_deaths as int)) as death_Count
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by death_Count desc

-- breaking global numbers
Select date,SUM(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'INDIA'
where continent is not null
group by date
order by 1,2


--looking at total population vs vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


--use cte
with popvsvac (continent,location,date,population,new_vaccinations,Rolling_people_vaccinated)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select *,(Rolling_people_vaccinated/population)*100
from popvsvac


--temptable
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
)
insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *,(Rolling_people_vaccinated/population)*100
from #percentpopulationvaccinated

--creating view to store data for visualization

create view percentpopulationvaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over  (partition by dea.location order by dea.location,dea.date) as Rolling_people_vaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated








