-- Create a new database
CREATE DATABASE CompanyDB;

-- Use the new database
-- USE CompanyDB;

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    Budget DECIMAL(10, 2)
);

-- Create EmployeeProjects table to handle many-to-many relationship
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Insert data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (1, 'Human Resources');
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (2, 'Engineering');
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (3, 'Marketing');

-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary) VALUES (1, 'John', 'Doe', 2, 60000);
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary) VALUES (2, 'Jane', 'Smith', 1, 50000);
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary) VALUES (3, 'Emily', 'Johnson', 3, 45000);
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary) VALUES (4, 'Michael', 'Brown', 2, 75000);

-- Insert data into Projects table
INSERT INTO Projects (ProjectID, ProjectName, Budget) VALUES (1, 'Project A', 100000);
INSERT INTO Projects (ProjectID, ProjectName, Budget) VALUES (2, 'Project B', 150000);
INSERT INTO Projects (ProjectID, ProjectName, Budget) VALUES (3, 'Project C', 200000);

-- Insert data into EmployeeProjects table
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (1, 1);
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (1, 2);
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (2, 3);
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (3, 1);
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (4, 2);
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES (4, 3);


select * from employees;
select * from employeeprojects;
select * from departments;
select * from projects;

select e.firstname, e.lastname, d.departmentname 
from employees e join departments d on e.departmentid = d.departmentid;

select projectname, budget from projects where budget>100000;

select e.firstname, e.lastname, p.projectname from employees e
join employeeprojects ep on e.employeeid = ep.employeeid
join projects p on ep.projectid = p.projectid;


select e.firstname, e.lastname, sum(p.budget) from employees e
join employeeprojects ep on e.employeeid = ep.employeeid
join projects p on ep.projectid = p.projectid group by e.employeeid;

select d.departmentname, avg(e.salary) as AVG_SALARY 
from employees e join departments d on e.departmentid = d.departmentid group by d.departmentid;