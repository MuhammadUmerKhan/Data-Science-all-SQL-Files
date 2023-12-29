use pet;
-- CREATE DATABASE PRACTICE__1;
-- USE PRACTICE;

-- create table PETRESCUE (
-- 	ID INTEGER NOT NULL,
-- 	ANIMAL VARCHAR(20),
-- 	QUANTITY INTEGER,
-- 	COST DECIMAL(6,2),
-- 	RESCUEDATE DATE,
-- 	PRIMARY KEY (ID)
-- 	);

-- insert into PETRESCUE values 
-- 	(1,'Cat',9,450.09,'2018-05-29'),
-- 	(2,'Dog',3,666.66,'2018-06-01'),
-- 	(3,'Dog',1,100.00,'2018-06-04'),
-- 	(4,'Parrot',2,50.00,'2018-06-04'),
-- 	(5,'Dog',1,75.75,'2018-06-10'),
-- 	(6,'Hamster',6,60.60,'2018-06-11'),
-- 	(7,'Cat',1,44.44,'2018-06-11'),
-- 	(8,'Goldfish',24,48.48,'2018-06-14'),
-- 	(9,'Dog',2,222.22,'2018-06-15')
	
-- ;
-- SELECT * FROM PETRESCUE;
-- SELECT SUM(COST) as COST_DETAIL FROM PETRESCUE;
-- SELECT MAX(QUANTITY) as QUANTITY_DETAIL FROM PETRESCUE;
-- SELECT AVG(COST) as AVG_DETAIL FROM PETRESCUE;
-- select AVG(COST/QUANTITY) from PETRESCUE where ANIMAL = 'Dog';
-- select round(COST) from PETRESCUE;
-- select length(ANIMAL) from PETRESCUE; 
-- select ucase(ANIMAL) from PETRESCUE;
-- select lower(ANIMAL) from PETRESCUE;

-- select distinct(ucase(ANIMAL)) FROM PETRESCUE;
-- select * from PETRESCUE where lower(ANIMAL)='cat';
-- select day(RESCUEDATE) from PETRESCUE where ANIMAL='Cat';
-- select SUM(QUANTITY) from PETRESCUE where MONTH(RESCUEDATE)='05';
-- select sum(QUANTITY) from PETRESCUE where DAY(RESCUEDATE)='14';
-- select date_add(RESCUEDATE, INTERVAL 3 DAY) from PETRESCUE;
-- select DATEDIFF(CURRENT_TIMESTAMP,RESCUEDATE) from PETRESCUE;

-- select * from petrescue;
select dayofweek(RESCUEDATE) from petrescue where ANIMAL='Dog';