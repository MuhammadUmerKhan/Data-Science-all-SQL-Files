-- Select the names and job start dates of all employees who work for the department number 5.
select E.F_NAME,E.L_NAME,JH.START_DATE FROM EMPLOYEE E
INNER JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID
WHERE JH.DEPT_ID = '5';

-- Select the names, job start dates, and job titles of all employees who work for the department number 5.

select E.F_NAME,E.L_NAME,JH.START_DATE,J.JOB_TITLE FROM EMPLOYEE E
INNER JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID
INNER JOIN JOBS AS J ON E.JOB_ID = J.JOB_IDENT
WHERE JH.DEPT_ID = '5';

-- Perform a Left Outer Join on the EMPLOYEES and DEPARTMENT tables and select employee id, last name, department id and department name for
-- all employees.

SELECT E.F_NAME,E.L_NAME,E.EMP_ID,DP.DEPT_ID_DEP,DP.DEP_NAME FROM EMPLOYEE AS E
LEFT OUTER JOIN DEPARTMENTS AS DP ON E.DEP_ID = DP.DEPT_ID_DEP;


-- Re-write the previous query but limit the result set to include only the rows for employees born before 1980.

select E.EMP_ID,E.L_NAME,E.DEP_ID,D.DEP_NAME
from EMPLOYEE AS E 
LEFT OUTER JOIN DEPARTMENTS AS D ON E.DEP_ID=D.DEPT_ID_DEP 
AND YEAR(E.B_DATE) < 1980;

-- Perform a Full Join on the EMPLOYEES and DEPARTMENT tables and select the First name, Last name and Department name of all employees.

SELECT F_NAME,L_NAME,DEP_NAME FROM EMPLOYEE AS E
LEFT OUTER JOIN DEPARTMENTS AS DP ON E.DEP_ID = DP.DEPT_ID_DEP

UNION 

SELECT F_NAME,L_NAME,DEP_NAME FROM EMPLOYEE AS E
RIGHT OUTER JOIN DEPARTMENTS AS DP ON E.DEP_ID = DP.DEPT_ID_DEP

-- Re-write the previous query but have the result set include all employee names but department id and department names only for male employees.

SELECT F_NAME,L_NAME,DEP_NAME FROM EMPLOYEE AS E
LEFT OUTER JOIN DEPARTMENTS AS DP ON E.DEP_ID = DP.DEPT_ID_DEP AND E.SEX = 'M'

UNION 

SELECT F_NAME,L_NAME,DEP_NAME FROM EMPLOYEE AS E
RIGHT OUTER JOIN DEPARTMENTS AS DP ON E.DEP_ID = DP.DEPT_ID_DEP
AND E.SEX = 'M';





CREATE VIEW EMP_VIEW (EMP_ID, FIRSTNAME, LASTNAME)
AS SELECT EMP_ID, F_NAME, L_NAME
FROM EMPLOYEE 
WHERE DEP_ID = 7; 

SELECT * FROM EMP_VIEW;