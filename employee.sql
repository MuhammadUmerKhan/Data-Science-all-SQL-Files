-- USE newdatabase;
-- CREATE TABLE employee(
--     ID INT PRIMARY KEY NOT NULL,
--     F_NAME VARCHAR(6),
--     L_NAME VARCHAR(6)
-- );
-- ALTER TABLE employee ADD SEX VARCHAR(1);
-- ALTER TABLE employee ADD B_DATE VARCHAR(6);
-- ALTER TABLE employee ADD SALARY INT;

-- SELECT * FROM employee;

-- create database employee;
-- create table employee(
-- 	EMP_ID VARCHAR(5),
-- 	F_NAME VARCHAR(10),
-- 	L_NAME VARCHAR(10),
-- 	SSN int,
-- 	B_DATE VARCHAR(10),
-- 	SEX VARCHAR(1),
-- 	ADDRESS VARCHAR(50),
-- 	JOB_ID INT,
-- 	SALARY INT,
-- 	MANAGER_ID INT,
-- 	DEP_ID INT 
-- )
-- CREATE TABLE JOB_HISTORY(
-- 	EMPL_ID VARCHAR(5),
-- 	START_DATE VARCHAR(10),
-- 	JOBS_ID INT,
-- 	DEPT_ID INT
	
-- )
-- CREATE TABLE JOBS(
-- 	JOB_IDENT INT,
-- 	JOB_TITLE VARCHAR(50),
-- 	MIN_SALARY INT,
-- 	MAX_SALARY INT
-- )
-- CREATE TABLE DEPARTMENTS(
-- 	DEPT_ID_DEP INT,
-- 	DEP_NAME VARCHAR(30),
-- 	MANAGER_ID INT,
-- 	LOC_ID VARCHAR(5)
-- )
-- CREATE TABLE LOCATIONS(
-- 	LOC_ID VARCHAR(5),
-- 	DEP_ID_LOC INT
-- )
-- SELECT * FROM DEPARTMENTS;

-- INSERT INTO employee VALUES('E1002', 'Alice', 'James','123457', '1972-07-31', 'F', '980 Berry In ,Elgin,IL', '200', '80000', '30002', '5'),
-- ('E1003', 'Steve', 'Wells','123458', '1980-08-10', 'M', '291 Springs, Gary,IL', '300', '50000', '30002', '5');

-- INSERT INTO JOB_HISTORY VALUES('E1001','2000-01-30','100','2'),('E1002','2010-08-16','200','5'),('E1003','2016-08-10','300','5');

-- INSERT INTO JOBS VALUES
-- 	('100','Sr.Architect','60000','100000'),
-- 	('100','Sr.Software Developer','60000','80000'),
-- 	('100','Jr.Software Developer','40000','60000');

-- insert into LOCATIONS values
-- ('L0001','2'),('L0002','5'),('L0003','7');

-- INSERT INTO DEPARTMENTS VALUES
-- ('2','Architect Group','30001','L0001'),
-- ('5','Software Development','30002','L0002'),('7','Design Team','30003','L0003'),('2','Software','30004','L0004');

