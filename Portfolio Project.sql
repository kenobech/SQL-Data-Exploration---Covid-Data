-- Fetch all records from CovidDeaths table, ordered by columns 3 and 4
Select *
From [Portfolio Project].dbo.CovidDeaths
Order by 3, 4;

-- Fetch records where continent is not null, ordered by columns 3 and 4
Select *
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Order by 3, 4;

-- Uncomment the following block to fetch data from CovidVaccinations table
-- Select *
-- From [Portfolio Project]..CovidVaccinations
-- Order by 3, 4;

-- Select specific columns for analysis
Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].dbo.CovidDeaths
Order by 1, 2;

-- Analyze Total Cases vs Total Deaths to calculate death percentage
Select location, date, total_cases, total_deaths, 
       (total_deaths / total_cases) * 100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Order by 1, 2;

-- Analyze Total Cases vs Population to calculate infection percentage
Select location, date, total_cases, total_deaths, 
       (total_cases / population) * 100 as InfectionPercentage
From [Portfolio Project].dbo.CovidDeaths
Where location like '%states%'
Order by 1, 2;

-- Analyze Total Cases vs Population for all countries
-- Note: This query is similar to the previous one but applies to all countries
Select location, date, population, total_cases, 
       (total_cases / population) * 100 as InfectionPercentage
From [Portfolio Project].dbo.CovidDeaths
Where location like '%states%'
Order by 1, 2;

-- Identify countries with the highest infection rate compared to population
Select location, population, 
       Max(total_cases) as HighestInfectionCount, 
       Max((total_cases / population) * 100) as PercentPopulationInfected
From [Portfolio Project].dbo.CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc;

-- Identify countries with the highest death count per population
Select location, 
       Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc;

-- Analyze death counts by continent
Select continent, 
       Max(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc;

-- Analyze global numbers for new cases and deaths
Select date, 
       sum(new_cases) as TotalCases, 
       sum(cast(new_deaths as int)) as TotalDeaths, 
       (sum(cast(new_deaths as int)) / sum(new_cases)) * 100 as DeathPercentage
From [Portfolio Project].dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1;

-- Join CovidDeaths and CovidVaccinations tables on location and date
Select *
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
     And dea.date = vac.date;

-- Analyze Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
     And dea.date = vac.date
Where dea.continent is not null
Order by 2, 3;

-- Use CTE to calculate rolling vaccination numbers
With PopVsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           Sum(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
    From [Portfolio Project].dbo.CovidDeaths dea
    Join [Portfolio Project].dbo.CovidVaccinations vac
         On dea.location = vac.location
         And dea.date = vac.date
    Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated / Population) * 100 as PercentVaccinated
From PopVsVac;

-- Create a temporary table to store vaccination percentages
Create Table #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_Vaccinations numeric,
    RollingPeopleVaccinated numeric
);

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       Sum(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
     And dea.date = vac.date
Where dea.continent is not null;

Select *, (RollingPeopleVaccinated / Population) * 100 as PercentVaccinated
From #PercentPopulationVaccinated;

-- Create a view to store vaccination data for visualization
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       Sum(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
     On dea.location = vac.location
     And dea.date = vac.date
Where dea.continent is not null;

Select *
From PercentPopulationVaccinated;