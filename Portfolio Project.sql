Select *
From [Portfolio Project].dbo.CovidDeaths
Order by 3,4


Select *
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Order by 3,4
--Select *
--From [Portfolio Project]..CovidVaccinations
--Order by 3,4

-- Select Data that we are going to be using


Select location,date,total_cases,new_cases,total_deaths,population
From [Portfolio Project].dbo.CovidDeaths
Order by 1,2



-- Looking at Total Cases Vs Total Deaths
-- Show the likelihood of dying if you contract Covid-19 in your country

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Order by 1,2

Select location,date,total_cases,total_deaths, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where location like '%states%'
Order by 1,2


-- Looking at the Total Cases Vs Population
-- Shows what percentage of population got Covid

Select location,date,population, total_cases, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where location like '%states%'
Order by 1,2


-- Looking at countries with highest Infection Rate compared to Population

Select location,population, Max (total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by location,population
Order by PercentPopulationInfected desc


--Showing the countries with the Highest DeathCount per Population

Select location, Max (cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc


-- Let's break things down by Continent


Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is null
Group by location
Order by TotalDeathCount desc


-- Showing Continents with the Highest Death Count Per Population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Global numbers

Select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1,2

Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(CAST(new_deaths AS int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


-- Join the CovidDeaths and CovidVaccinations table. The join is on location and date

Select *
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date


-- Looking at Total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
Order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
      ,Sum(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
Order by 2, 3


-- Use CTE

with PopVsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
      ,Sum(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac


-- Use Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
      ,Sum(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
      ,Sum(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
	 And dea.date = vac.date
Where dea.continent is not null

Select*
From PercentPopulationVaccinated