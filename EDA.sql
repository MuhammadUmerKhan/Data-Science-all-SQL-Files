-- Active: 1704353692862@@127.0.0.1@3306@my_data1
use my_data1;
SELECT * FROM spacex;

-- Task 1
-- Display the names of the unique launch sites in the space mission
SELECT DISTINCT(Launch_site) FROM spacex;

-- Task 2
-- Display 5 records where launch sites begin with the string 'CCA'
SELECT (Launch_Site) FROM spacex WHERE Launch_Site LIKE 'CCA%' LIMIT 5;

-- Task 3
-- Display the total payload mass carried by boosters launched by NASA (CRS)
SELECT * FROM spacex;
SELECT SUM(PAYLOAD_MASS_KG) as PayloadMass FROM spacex;

-- Task 4
-- Display average payload mass carried by booster version F9 v1.1
SELECT * FROM spacex;
SELECT Booster_version, AVG(PAYLOAD_MASS_KG) FROM spacex WHERE Booster_Version = 'F9 v1.1';

-- Task 5
-- List the date when the first succesful landing outcome in ground pad was acheived
SELECT * FROM spacex;
SELECT MIN(Date) FROM spacex;


-- Task 6
-- List the names of the boosters which have success in drone ship and have payload mass greater than 4000 but less than 6000
SELECT * FROM spacex;
SELECT Booster_Version, PAYLOAD_MASS_KG FROM spacex WHERE PAYLOAD_MASS_KG > 4000 AND PAYLOAD_MASS_KG < 6000;

-- Task 7
-- List the total number of successful and failure mission outcomes
SELECT * FROM spacex;
SELECT Mission_Outcome, COUNT(Mission_Outcome) FROM spacex GROUP BY Mission_Outcome; 

-- Task 8
-- List the names of the booster_versions which have carried the maximum payload mass. Use a subquery
SELECT Booster_Version, PAYLOAD_MASS_KG FROM  spacex WHERE PAYLOAD_MASS_KG = (SELECT MAX(PAYLOAD_MASS_KG) FROM spacex);

-- Task 9
-- List the records which will display the month names, failure landing_outcomes in drone ship ,booster versions, launch_site for the months in year 2015.
-- Note: SQLLite does not support monthnames. So you need to use substr(Date, 6,2) as month to get the months and substr(Date,0,5)='2015' for year.
SELECT * FROM spacex;
SELECT MONTHNAME(Date),Landing_Outcome,Booster_Version,Launch_Site FROM spacex WHERE EXTRACT(YEAR FROM Date) = '2015';

-- Task 10
-- Rank the count of landing outcomes (such as Failure (drone ship) or Success (ground pad)) between the date 2010-06-04 and 2017-03-20, in descending order
SELECT * FROM spacex;
SELECT Date, Landing_Outcome FROM spacex WHERE DATE BETWEEN '2010-06-04' AND '2017-06-04' ORDER BY Date DESC;