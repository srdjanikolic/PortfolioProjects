

		--COVID DATA ACROSS THE WORLD--ALL THE DATA THAT IS USED IS RECORDED UP TO April 30, 2021


select Location, date, total_cases,new_cases, 
total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2


-- Total Cases vs Total Deaths, "chance" od dying if contracted COVID in Austria

select Location, date, total_cases, 
total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%austria%'
order by 1,2

--Total Cases vs whole Population shows the total percentage of population infected on a given day in Austria

select Location, date, total_cases, population,
 (total_cases/population)*100 as PercentageOfPopulationInfected
from PortfolioProject..CovidDeaths$
where location like '%austria%'
order by 1,2


-- Percentage of People infected with COVID-19 compared to the whole population in Austria including the last date recorded April 30, 2021

select Location, Population, max(total_cases) as HighestInfectionCount,
 max((total_cases/population))*100 as PercentageOfPopulationInfected
from PortfolioProject..CovidDeaths$
where location like '%austria%'
group by location, population
order by PercentageOfPopulationInfected


-- Total Death Count for Austria

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where location like '%austria%'
group by location
order by TotalDeathCount


-- break search by continent

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is null
group by location
order by TotalDeathCount desc


-- showing continents with highest death count

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global numbers

select date, sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(New_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

-- death percentage globally

select sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(New_deaths as int))/(sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2


--Join Deaths and Vaccination Tables

Select * 
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date


-- Total population vs vaccination 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.Date) as RollingCountPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With POPvsVAC(Continent, Location, Date, Population, New_Vaccinations, RollingCountPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.Date) as RollingCountPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingCountPeopleVaccinated/Population)*100 as PercentageofPeopleVaccinated
from POPvsVAC


--Temp Table

Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingCountPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.Date) as RollingCountPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
select *,(RollingCountPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



--Creating View for later visualisations

create View 
PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.Date) as RollingCountPeopleVaccinated
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select * from
PercentPopulationVaccinated