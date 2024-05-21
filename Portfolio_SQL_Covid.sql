Select *
FROM PortfolioProject..CovidDeaths$
where continent is not null
Order by 3,4

--Select *
--FROM PortfolioProject..CovidVaccinations$
--Order by 3,4

--Select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject.dbo.CovidDeaths$
order by 1,2

--looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract Covid by country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
where location like '%states%'
order by 1,2

--looking at the total cases vs population
--Shows what percentage of population got Covid

Select Location, date,population ,total_cases, (total_cases/population)*100 as ContractPercentage
FROM PortfolioProject.dbo.CovidDeaths$
where location like '%states%'
order by 1,2



--looking at countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
Group by location, population
order by PercentofPopulationInfected desc

--Create View Total Infected

Create View Total_Infected_By_Country as
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
Group by location, population

--Showing countries with highest death count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
Group by location 
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccinations
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3

--USE CTE

With PopsVsVac (Continent, location, date, population, new_vaccinations, Rolling_Vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccinations
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3
)

Select * , (Rolling_Vaccinations/population)*100
From PopsVsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric, 
Rolling_Vaccinations numeric, 
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccinations
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null

Select * , (Rolling_Vaccinations/population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccinations
From PortfolioProject.dbo.CovidDeaths$ dea
Join PortfolioProject.dbo.CovidVaccinations$ vac
	On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null


