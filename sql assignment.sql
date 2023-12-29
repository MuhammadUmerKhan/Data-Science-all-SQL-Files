-- SQL Assignment --

-- Q1: Use the Inner join operation with the EMPLOYEES table as the left table and the JOB_HISTORY table as the right table.

-- select E.F_name,E.L_name,JH.start_date from employees E inner join job_history as JH on E.employee_id = JH.employee_id
-- where E.dep_id = '5';


-- Q2: Select the names, job start dates, and job titles of all employees who work for the department number 5.

-- select E.F_name,E.L_name,JH.start_date,J.job_title from employees as E 
-- inner join job_history as JH on E.employee_id = JH.employee_id
-- inner join jobs as J on E.job_id = J.job_ident 
-- where E.dep_id = '5';