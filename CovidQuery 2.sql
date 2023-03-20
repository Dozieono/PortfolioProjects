select*
From PortfolioProject1..CovidDeaths$
where continent is not null
order by 3,4


--select*
--From PortfolioProject1..CovidVaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths$
where continent is not null
order by 1,2


-- Looking at the total cases vs total deaths
-- Shows the likelihood of dying if you were to contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
order by 1,2

--Looking at the total cases vs the population
select location, date,population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
order by 1,2


--Looking at countries with highest infection rate compared to population
select location,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofPopulationInfected
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by location,population
order by PercentofPopulationInfected desc

--Showing countries with highest death count per population
select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by location
order by TotalDeathCount desc


--BREAKING IT DOWN BY CONTINENT


--showing the continents with the highest death count per population
select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by continent
order by TotalDeathCount desc


--Looking at continents with highest infection rate compared to population
select continent,population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofPopulationInfected
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by continent,population
order by PercentofPopulationInfected desc




--GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by date
order by 1,2


--world total
select SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
--Group by date
order by 1,2


--Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationCount

from PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
 


 --USE CTE

 With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingVaccinationCount)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationCount

from PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

Select *, (RollingVaccinationCount/Population)*100 as RollingVaccinationPercentage
From PopvsVac






--Creating view to store data for later visualization

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinationCount

from PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3


Create View WorldInfectionTotals as
select date, SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where continent is not null
--where location like '%nigeria%'
Group by date
--order by 1,2


Select *
From PercentPopulationVaccinated