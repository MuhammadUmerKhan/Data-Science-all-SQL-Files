use employees;
-- select EMPLOYEE_ID,F_NAME,L_NAME,SALARY from employees where SALARY < (select avg(SALARY) from employees) 
-- select EMPLOYEE_ID,F_NAME,L_NAME,(select max(SALARY) FROM employees) as MAX_SALARY from employees; 
-- select * from ( select EMPLOYEE_ID, F_NAME, L_NAME, DEP_ID from EMPLOYEES) AS EMP4ALL;
-- select EMPLOYEE_ID, F_NAME, L_NAME, DEP_ID from EMPLOYEES as EMP4ALL;

-- -------------------------------------------------------------------------------------------
-- select * from employees where JOB_ID in (select JOB_IDENT FROM JOBS);
-- select * from employees where JOB_ID IN (select JOB_IDENT FROM JOBS where JOB_TITLE='Jr.SoftwareDeveloper');
-- select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from jobs where JOB_IDENT in(select JOB_ID from employees where year(B_DATE) < 1976 and SEX = 'F');
select E.EMPLOYEE_ID,E.F_NAME,E.L_NAME,J.JOB_TITLE from employees E, JOBS J where E.JOB_ID = J.JOB_IDENT; 

