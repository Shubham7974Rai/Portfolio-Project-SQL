select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows chances of dying from Covid in your country

select location,date,total_cases,total_deaths, 
(total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths$
where location like 'India'
order by 1,2

--Looking at Total cases vs Population

select location,date,population, total_cases,
(total_cases/population)*100 as Cases_Percentage
from CovidDeaths$
--where location like 'India'
order by 1,2

--Country with highest infection rate 

select location,population, max(total_cases) as HighestInfectioncount,
max((total_cases/population))*100 as Infection_Percentage
from CovidDeaths$
group by population,location
--where location like 'India'
order by Infection_Percentage desc

--Country with highest death count over population

select location,max(cast(total_deaths as int)) as Death_Count
from CovidDeaths$
where continent is not null
group by location
--where location like 'India'
order by Death_Count desc

--Split in continents

select continent,max(cast(total_deaths as int)) as Death_Count
from CovidDeaths$
where continent is not null
group by continent
--where location like 'India'
order by Death_Count desc

--Showing Continent with Highest death count

select continent,max(cast(total_deaths as int)) as Death_Count
from CovidDeaths$
where continent is not null
group by continent
--where location like 'India'
order by Death_Count desc

--Global Number

select date,sum(new_cases)as Totalnew_cases,sum(new_deaths)as totalnew_deaths,
sum(new_deaths)/sum(new_cases)*100 as Death_Percentage
from CovidDeaths$
where continent is not null and new_cases!=0
group by date
order by 1,2


select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingpplVac
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location=vac.location
	and dea.date=vac.date 
 where dea.continent is not null
 order by 2,3


-- USE CTE 

with PopvsVac (Continent,location, date, population,new_vaccinations, RollingpplVac)
as
(
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingpplVac
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location=vac.location
	and dea.date=vac.date 
 where dea.continent is not null
 --order by 2,3
 )
select *, (RollingpplVac/population)*100
from PopvsVac

--Creating view for visualisation

create view PrecentPop as

select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingpplVac
from CovidDeaths$ as dea
join CovidVaccinations$ as vac
	on dea.location=vac.location
	and dea.date=vac.date 
 --where dea.continent is not null
 --order by 2,3

 select * from PrecentPop




