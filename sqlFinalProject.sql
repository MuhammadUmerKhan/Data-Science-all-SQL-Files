select * from chicago_crime;	
select * from chicago_public_schools;
select * from chicago_socioeconomic_data;
-- Find the total number of crimes recorded in the CRIME table.
select count(*) as total_crimes from chicago_crime;

select community_area_name,community_area_number,per_capita_income from chicago_socioeconomic_data where per_capita_income<11000 ;

select distinct case_number from chicago_crime where description like '%MINOR%';

SELECT DISTINCT CASE_NUMBER, PRIMARY_TYPE, DATE, DESCRIPTION FROM chicago_crime WHERE PRIMARY_TYPE='KIDNAPPING';

select distinct(primary_type),location_description from chicago_crime where location_description like '%SCHOOL%';

SELECT elementary_middle_high_school, AVG(safety_score) AS average_safety_score
FROM chicago_public_schools
GROUP BY elementary_middle_high_school;	

select  distinct community_area_name, percent_households_below_poverty from chicago_socioeconomic_data order by percent_households_below_poverty desc limit 5;

select community_area_number,count(community_area_number ) as FREQUENCY from chicago_crime group by community_area_number order by count(community_area_number) desc limit 1;

select community_area_name from chicago_socioeconomic_data where hardship_index = (select max(hardship_index) from chicago_socioeconomic_data);

SELECT community_area_name FROM chicago_socioeconomic_data 
WHERE COMMUNITY_AREA_NUMBER = (SELECT COMMUNITY_AREA_NUMBER FROM CHICAGO_CRIME
    GROUP BY COMMUNITY_AREA_NUMBER
    ORDER BY COUNT(COMMUNITY_AREA_NUMBER) DESC
    LIMIT 1)
LIMIT 1;