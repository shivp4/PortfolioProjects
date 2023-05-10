Select *
From portfolioproject.covid_deaths
where continent is not null
order by 3,4;

Select *
From portfolioproject.covid_vaccinations
order by 3,4;

Select location,date,total_cases,new_cases,total_deaths,population
From portfolioproject.covid_deaths
where continent is not null
order by 1,2;

/*Looking at total cases vs total deaths*/

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From portfolioproject.covid_deaths
Where location like '%india%' and continent is not null
order by 1,2;
/*shows likelihood of dying if you contract covidin your country*/

/*looking at total cases vs population*/
/*shows what percentage got covid*/
Select location,date,total_cases,population,(total_cases/population)*100 as PercentagePopulationInfected
From portfolioproject.covid_deaths
/*Where location like '%india%'*/
order by 1,2;

/*looking at countries with highest infection rate compared to population*/
Select location,population,max(total_cases) as HighestInfection,max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject.covid_deaths
/*Where location like '%india%'*/
group by location,population
order by PercentPopulationInfected desc;

/*Showing countries with highest death count per population*/
Select continent,max(cast(total_deaths as unsigned int)) as TotalDeathCount
From portfolioproject.covid_deaths
/*Where location like '%india%'*/
group by continent
order by TotalDeathCount desc;

/*showing continents with highest death count per population*/
Select continent,max(cast(total_deaths as unsigned int)) as TotalDeathCount
From portfolioproject.covid_deaths
/*Where location like '%india%'*/
where continent is not null
group by continent
order by TotalDeathCount desc;


/*global numbesrs*/
Select sum(new_cases) as total_cases,sum(cast(new_deaths as unsigned int)) as total_deaths,sum(cast(new_deaths as unsigned int))/ sum(new_cases)*100 as DeathPercentage
From portfolioproject.covid_deaths
/*Where location like '%india%' and*/ 
where continent is not null
/*group by date*/
order by 1,2;

/*looking at total population vs total vaccination*/
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned int)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
From portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
order by location,date;

/*USE CTE*/
With popvsvac (continent, location,date, population,new_vaccinations,rollingpeoplevaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned int)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
From portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null)
/*order by location,date*/

Select *, (rollingpeoplevaccinated/population)*100
from popvsvac


/*Temp TAble

DROP Table if exists 
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
/*, (RollingPeopleVaccinated/population)*100*/ 
/*From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
/*order by 2,3*/

/*Select *,(rolling_count_vac/population)*100
From percent_population_vaccinated*/


/*Creatin View to store for Data Visualization*/
Create View PercentPopulationVaccinated as 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as unsigned int)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
From portfolioproject.covid_deaths dea
join portfolioproject.covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null

Select *
From percentpopulationvaccinated
