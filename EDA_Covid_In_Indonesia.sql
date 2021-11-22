-- The Datasets Contain Covid Data in the World from 1 January 2020 to 06 November 2021

-- Looking rate_cases, rate_deaths and rate_vaccination in Indonesia Over the Date
SELECT 
    date, CAST(new_cases as INT) as new_cases, CAST(total_cases as INT) as total_cases,
    CAST(new_deaths as INT) as new_deaths, CAST(total_deaths as INT) as total_deaths,
    CAST(new_vaccinations as INT) as new_vaccinations, CAST(people_fully_vaccinated as INT) as people_fully_vaccinated,population,
    round(((total_cases/population)*100),2) as rate_cases, round(((total_deaths/total_cases)*100),2) as rate_deaths,
    round(((people_fully_vaccinated/population)*100),2) as rate_vaccinations
FROM 
    `practice-project-323312.CovidData.Covid_06112021`
WHERE 
    location = 'Indonesia';

-- Looking rate_cases, rate_deaths and rate_vaccination Country in Asia Over the Date
SELECT 
    location, date, CAST(new_cases as INT) as new_cases, CAST(total_cases as INT) as total_cases,
    CAST(new_deaths as INT) as new_deaths, CAST(total_deaths as INT) as total_deaths,
    CAST(new_vaccinations as INT) as new_vaccinations, CAST(people_fully_vaccinated as INT) as people_fully_vaccinated,population,
    round(((total_cases/population)*100),2) as rate_cases, round(((total_deaths/total_cases)*100),2) as rate_deaths,
    round(((people_fully_vaccinated/population)*100),2) as rate_vaccinations,
FROM 
    `practice-project-323312.CovidData.Covid_06112021`
WHERE 
    continent = 'Asia';

-- Indonesia Compare with Other Countries in Asia
SELECT 
    location, round(((SUM(new_cases)/MAX(population))*100),2) as rate_cases,
    round(((SUM(new_deaths)/SUM(new_cases))*100),2) as rate_deaths,
    round(((MAX(people_fully_vaccinated)/MAX(population))*100),2) as rate_vaccinations
FROM 
    `practice-project-323312.CovidData.Covid_06112021`
WHERE 
    continent = 'Asia'
GROUP BY 
    location
ORDER BY 
    location;

-- Case rate rank in Asia
WITH covidasia as
(SELECT 
    location, round(((SUM(new_cases)/MAX(population))*100),2) as rate_cases,
    round(((SUM(new_deaths)/SUM(new_cases))*100),2) as rate_deaths,
    round(((MAX(people_fully_vaccinated)/MAX(population))*100),2) as rate_vaccinations
FROM 
    `practice-project-323312.CovidData.Covid_06112021`
WHERE 
    continent = 'Asia'
GROUP BY 
    location)
SELECT 
    location, rate_cases,
    DENSE_RANK() OVER (ORDER BY rate_cases DESC) as cases_rank
FROM covidasia
ORDER BY rate_cases DESC;

-- Deaths rate rank in Asia
SELECT 
    a.location, a.rate_deaths,
    DENSE_RANK() OVER (ORDER BY a.rate_deaths DESC) as deaths_rank 
FROM 
    (SELECT location, round(((SUM(new_cases)/MAX(population))*100),2) as rate_cases,
    round(((SUM(new_deaths)/SUM(new_cases))*100),2) as rate_deaths,
    round(((MAX(people_fully_vaccinated)/MAX(population))*100),2) as rate_vaccinations
    FROM 
        `practice-project-323312.CovidData.Covid_06112021`
    WHERE 
        continent = 'Asia'
    GROUP BY 
        location
    ORDER BY 
        location) as a
ORDER BY 
    rate_deaths DESC;

-- Vaccinations rate rank in Asia
SELECT 
    a.location, a.rate_vaccinations,
    DENSE_RANK() OVER (ORDER BY a.rate_vaccinations DESC) as vaccination_rank 
FROM 
    (SELECT location, round(((SUM(new_cases)/MAX(population))*100),2) as rate_cases,
    round(((SUM(new_deaths)/SUM(new_cases))*100),2) as rate_deaths,
    round(((MAX(people_fully_vaccinated)/MAX(population))*100),2) as rate_vaccinations
    FROM 
        `practice-project-323312.CovidData.Covid_06112021`
    WHERE 
        continent = 'Asia'
    GROUP BY 
        location
    ORDER BY 
        location) as a
ORDER BY 
    rate_vaccinations DESC;