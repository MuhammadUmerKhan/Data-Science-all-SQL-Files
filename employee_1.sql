-- use employees;
-- -- select * from employees;
-- -- select * from employees where SALARY < avg(SALARY)  Produce Limit Error
-- -- select F_NAME,L_NAME,SALARY from employees where SALARY < (select avg(SALARY) from employees);
-- -- select EMP_ID, SALARY, MAX(SALARY) AS MAX_SALARY from EMPLOYEES;	 Produce error	
-- -- select EMPLOYEE_ID, SALARY, (select max(SALARY) from employees) as  MAX_SALARY from employees; 

-- select * from (select EMPLOYEE_ID, F_NAME, L_NAME, DEP_ID from EMPLOYEES) AS EMP4ALL;
ALTER TABLE employee
ALTER COLUMN L_NAME INT;





insert into LOCATIONS(LOC_ID,DEP_ID_LOC) valueS
("l0001","2");

SELECT * FROM LOCATIONS;