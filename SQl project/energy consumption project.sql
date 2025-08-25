create database energy_consumption;
use energy_consumption;
-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

select * from country;




-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM CONSUMPTION;

-- project questions to solve 
-- 1) What is the total emission per country for the most recent year available?

select country,
          sum(emission) as total_emission
from emission_3
where year=(
     select max(year)
     from emission_3
)
group by country
order by total_emission desc;
select * from emission_3;


-- What are the top 5 countries by GDP in the most recent year?
SELECT * FROM GDP_3;
select * from gdp_3
where year=(
 select max(year)
 from gdp_3
 )
 order by value desc
 limit 5;
 
 -- Compare energy production and consumption by country and year. 
 select p.country,
        p.year,
        p.production,
        c.consumption
from production p
join consumption c
   on p.country=c.country
   and p.year=c.year
order by p.country desc ,c.year desc;

-- Which energy types contribute most to emissions across all countries?
select * from emission_3;
select energy_type,
  sum(emission) as total_emission
from emission_3
group by energy_type
order by total_emission
limit 1;

-- Trend Analysis Over Time
-- How have global emissions changed year over year?
select * from emission_3;
select year,
   sum(emission) as total_emission
from emission_3
group by year 
order by total_emission;
-- Annual emissions grew by 6,309 units (2020–2023), 
-- 2020	67852
-- 2021	70976
-- 2022	72445
-- 2023	74161


-- What is the trend in GDP for each country over the given years?
select * from gdp_3;
select country,
     year,
    sum(value) as total_gdp
from gdp_3
group by country, year
order by country,year;

-- How has population growth affected total emissions in each country?
select * from population;
-- country, year , value
select * from emission_3;
-- country, energy type, year, emission, per capita emission
-- using join can be solved
select p.countries,
       p.value,
       p.year,
       sum(e.emission) as total_emission
from population p
join emission_3 e 
  on p.countries=e.country
  and p.year=e.year
group by p.countries, p.year, p.value
order by p.countries,p.year,total_emission;
       
-- Has energy consumption increased or decreased over the years for major economies?
select country,
    sum(value) as total_economy
    from gdp_3
group by country
order by total_economy desc
limit 5;
-- 5 major econommies were china, us, india, japan, germany
select country,
      year,
      sum(consumption) as total_energy_consumption
from consumption
where country in ('China','United States','India','Japan','Germany')
group by year, country
order by  total_energy_consumption desc;

-- What is the average yearly change in emissions per capita for each country?
select * from emission_3;
select country,
    avg(per_capita_emission) as avg_emission,
    year
    from emission_3
group by year, country
order by country, year, avg_emission;

-- What is the emission-to-GDP ratio for each country by year?
select  * from gdp_3;
-- country, year, value
select * from emission_3;
 -- country, energy_type, year, emission, per_capita_emission
 select g.country, 
        g.year,
        sum(e.emission) as total_emission,
        g.value as gdp,
        sum(e.emission)/g.value as eg_ratio
from gdp_3 g
join emission_3 e
  on g.country = e.country
  and g.year = e. year
group by g.country, g.year, g.value
order by eg_ratio desc, e.year, g.country desc;
 
-- What is the energy consumption per capita for each country over the last decade?
select * from consumption;
-- country, energy, year, consumption
select * from population;
-- countries, year, value
select c.country,
       p.value,
       c.year,
       sum(consumption) as total_consumption,
       sum(consumption)/ value as energy_consumption_per_capita
from consumption c
join population p 
   on c.country = p.countries
   and c.year = p.year
where c.year >= 2020
group by c.country, p.value, c.year
order by energy_consumption_per_capita desc, c.year, c.country desc;


-- How does energy production per capita vary across countries
select * from production;
-- country, energy, year, production
select * from population;
-- countries, year, value 
select p.country,
       pe.value,
       sum(p.production)/ value as energy_per_capita
       
from production p 
join population pe
   on p.country = pe.countries
group by p.country, pe.value
order by energy_per_capita desc, p.country;

-- Which countries have the highest energy consumption relative to GDP?
select * from consumption;
-- country, energy, year, consumption
select * from gdp_3;
-- country, year, value 
select c.country,
       sum(c.consumption) as total_consumption,
       g.value,
       sum(c.consumption)/ g.value as consumption_gdp_ratio
from consumption c
join gdp_3 g
    on c.country = g.country
    and c.year = g. year
group by c.country, g.value, c.year
order by  consumption_gdp_ratio desc
limit 1;

-- What is the correlation between GDP growth and energy production growth?
select * from gdp_3;
-- country, year, value
select * from production;
-- country, energy, year, production
select g.country,
       g.year,
       g.value as total_gdp,
       p.production as total_production
from gdp_3 g 
join production p 
   on g.country = p. country
   and g.year = p.year
group by g.country, g.value, p.year
order by total_production;

  -- What are the top 10 countries by population and how do their emissions compare?
  select * from population;
  -- countries, year, values
  select * from emission_3;
  -- country, energy_type, year, emission, per_capita_emission
  select p.countries,
         p.value,
         sum(e.emission) as total_emission
 from population p 
 join emission_3 e 
    on p.countries=e.country
    and p.year=e.year
 where p.countries in (
   select distinct countries 
     from population
)
group by p.countries,p.value
order by p.value desc;

-- Which countries have improved (reduced) their per capita emissions the most over the last decade?
-- country, energy_type, year, emission, per_capita_emission
-- in populationn table countries, year, value
   select e.country,
		e.year,
       (sum(e.emission) / p.value) as per_capita_emission
       
from emission_3 e
join population p
   on e.year=p.year 
   and e.country = p.countries
where e.year in (
     (select max(year) from emission_3),
     (select max(year) - 3 from emission_3)
     
)
group by e.country, e.year, p.value
order by e.country,e.year ,p.value, per_capita_emission desc;
       


-- What is the global share (%) of emissions by country?
-- country, energy_type, year, emission, per_capita_emission
select country,
       sum(emission) as total_emission_countrys,
       sum(emission) * 100 / ( select sum(emission) from emission_3) as global_share
from emission_3
group by country
order by global_share desc;



-- last question:: What is the global average GDP, emission, and population by year?
-- country, year, value for gdp
-- country , energy_type, year, emission, per_capita_emission for emission tbale
-- countries, year, value for population
select g.country,
       g.year,
       avg(g.value) as avg_gdp,
       avg(e.emission) as avg_emission,
       avg(p.value) as avg_population
from gdp_3 g
join emission_3 e 
   on g.country = e.country
   and g.year = e.year
join population p 
   on p.countries = e.country
   and p.year = e.year
group by p.countries, e.year, p.value
order by avg_population desc,avg_emission desc,avg_gdp desc;
       

