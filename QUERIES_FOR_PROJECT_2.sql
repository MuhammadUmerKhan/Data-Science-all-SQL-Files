-- Query 1
SELECT SUM(new_cases) as Total_Cases, SUM(new_deaths) as Total_Deaths , ((SUM(new_deaths)/SUM(new_cases))*100) as Death_Percentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- Query 2
Select location, SUM(new_deaths) as TotalDeathCount
From coviddeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Query 3
SELECT 
location, population, MAX(total_cases) as Highest_count,  MAX((total_cases/population))*100 as Percent_Population_effected
FROM coviddeaths
WHERE location is NOT NULL
GROUP BY location, population 
ORDER BY Percent_Population_effected DESC ;

-- Query 4
SELECT 
location, population, date, MAX(total_cases) as Highest_count,  MAX((total_cases/population))*100 as Percent_Population_effected
FROM coviddeaths
GROUP BY location, population, date
ORDER BY Percent_Population_effected DESC;