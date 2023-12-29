select * from chicago_public_schools;
select * from chicago_crime;
select community_area_number from chicago_socioeconomic_data;

--Q1 List the case number, type of crime and community area for all crimes in community area number 18.
select CR.case_number,CR.primary_type,CSD.community_area_number from chicago_crime CR
inner join chicago_socioeconomic_data CSD on CR.community_area_number = CSD.community_area_number
where CSD.community_area_number = '18';

--Q2 List all crimes that took place at a school. Include case number, crime type and community name.
select CR.case_number,CR.primary_type,CSD.community_area_number,CR.location_description from chicago_crime CR
left join chicago_socioeconomic_data CSD on CR.community_area_number = CSD.community_area_number
where CR.location_description like '%SCHOOL%'; 

-- For the communities of Oakland, Armour Square, Edgewater and CHICAGO list the associated community_area_numbers and the case_numbers.
select CR.community_area_number,CR.case_number,CSD.community_area_name from chicago_crime CR
full outer join chicago_socioeconomic_data CSD on CR.community_area_number = CSD.community_area_number
where CSD.community_area_name in ('Oakland', 'Armour Square', 'Edgewater','CHICAGO');

-- Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
select CPS.name_of_school,CSD.community_area_name,CPS.average_student_attendance from chicago_public_schools CPS
JOIN chicago_socioeconomic_data CSD ON CPS.community_area_number = CSD.community_area_number
WHERE CSD.hardship_index='98';

-- Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
select CR.case_number, CR.primary_type,CSD.community_area_name,CR.location_description from chicago_crime CR
left join chicago_socioeconomic_data CSD on CR.community_area_number = CSD.community_area_number
where CR.location_description like '%SCHOOL%'

-- Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.
drop view FROM_CPS;
CREATE VIEW FROM_CPS AS
SELECT name_of_school AS School_Name,
       Safety_Icon AS Safety_Rating,
       Family_Involvement_Icon AS Family_Rating,
       Environment_Icon AS Environment_Rating,
       Instruction_Icon AS Instruction_Rating,
       Leaders_Icon AS Leaders_Rating,
       Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools;
select * from FROM_CPS;
-- select Leaders_Score from chicago_public_schools

-- Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer.
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE AS    
SELECT School_ID, Leaders_Score FROM CHICAGO_PUBLIC_SCHOOLS
GO;   
exec UPDATE_LEADERS_SCORE_EXAMPLE
