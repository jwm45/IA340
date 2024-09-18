--4.1
/*no because of the 1-Many relationship and the fact that Virginia is a primary key */ 

--4.2
insert into income(fips,income,year) values('80',6000,2025)
/* No because we do not have a state representing 80 in fips */ 

--4.3
  /* creating name table*/
CREATE TABLE name_table (
    fips_code VARCHAR(10) PRIMARY KEY, -- Assuming FIPS codes are strings of up to 10 characters
    name VARCHAR(255) NOT NULL
);

/* creating income table*/
CREATE TABLE income_table (
    fips_code VARCHAR(10) NOT NULL,
    income DECIMAL(15, 2) NOT NULL,  -- Income with two decimal precision
    year INT NOT NULL,
    PRIMARY KEY (fips_code, year),  -- Composite primary key using FIPS code and year
    FOREIGN KEY (fips_code) REFERENCES name_table(fips_code) -- Foreign key constraint
);

--4.5
/* yes ChatGPT recognized the ERD diagram and was able to provide code related to it*/

--4.6
/* the code works perfectly*/

 WITH RecentIncome AS (
    SELECT fips, income, year
    FROM income
    WHERE year = (SELECT MAX(year) FROM income)
)
SELECT n.name, ri.income, ri.year
FROM name n
JOIN RecentIncome ri
ON n.fips = ri.fips
ORDER BY ri.income DESC
LIMIT 1;

--4.7 
/* my prompt was "give me the code to calculate the VA population growth rate in the past five years" 
I did not have to modify my prompt at all. And the code works perfect in pgAdmin */
WITH PopulationData AS (
    SELECT fips, pop, year
    FROM population
    WHERE fips = '51'  -- Assuming '51' is the FIPS code for Virginia
    AND year IN ((SELECT MAX(year) FROM population) - 5, (SELECT MAX(year) FROM population))
)
SELECT 
    MAX(CASE WHEN year = (SELECT MAX(year) FROM population) THEN pop END) AS population_end,
    MAX(CASE WHEN year = (SELECT MAX(year) - 5 FROM population) THEN pop END) AS population_start,
    ROUND(
        (MAX(CASE WHEN year = (SELECT MAX(year) FROM population) THEN pop END) / 
         MAX(CASE WHEN year = (SELECT MAX(year) - 5 FROM population) THEN pop END) - 1) * 100, 2
    ) AS growth_rate
FROM PopulationData;

--4.8
/* No ChatGPT does not always give 100% accurate information in its responses; all information derived from it must be used cautiously. */ 






