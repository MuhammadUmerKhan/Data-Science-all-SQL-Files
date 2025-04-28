-- =============================================================================
-- SQL Practice: Day 2 - Employee and Project Management Database
-- Description: Schema and solutions for 10 normal-difficulty SQL problems to build AI engineering skills.
-- Author: [Your Name]
-- Date: April 26, 2025
-- Database: day_2 (Departments, Employees, Projects, Employee_Projects)
-- =============================================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS day_2;
USE day_2;

-- =============================================================================
-- Table: Departments
-- Description: Stores department information, including manager references
-- =============================================================================
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name TEXT NOT NULL,
    manager_id INT
);

INSERT INTO Departments (department_id, department_name, manager_id) VALUES
(1, 'HR', 101),
(2, 'Engineering', 102),
(3, 'Marketing', 103),
(4, 'Sales', NULL);

-- =============================================================================
-- Table: Employees
-- Description: Stores employee details with department references
-- =============================================================================
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Employees (employee_id, first_name, last_name, department_id, hire_date, salary) VALUES
(101, 'Alice', 'Smith', 1, '2018-06-01', 60000.00),
(102, 'Bob', 'Johnson', 2, '2019-01-15', 95000.00),
(103, 'Carol', 'Lee', 2, '2020-03-10', 85000.00),
(104, 'David', 'Kim', 3, '2021-07-22', 72000.00),
(105, 'Eva', 'Brown', 1, '2017-09-05', 65000.00),
(106, 'Frank', 'Wright', 2, '2022-01-10', 78000.00),
(107, 'Grace', 'Green', 3, '2020-11-19', 73000.00);

-- =============================================================================
-- Table: Projects
-- Description: Stores project details with department references
-- =============================================================================
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name TEXT NOT NULL,
    department_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Projects (project_id, project_name, department_id, start_date, end_date) VALUES
(201, 'Recruitment Drive', 1, '2023-01-01', NULL),
(202, 'Website Redesign', 2, '2022-10-01', '2023-12-31'),
(203, 'Product Launch', 3, '2023-04-01', NULL),
(204, 'Sales Automation', 4, '2023-06-15', '2024-01-15');

-- =============================================================================
-- Table: Employee_Projects
-- Description: Stores employee assignments to projects with roles
-- =============================================================================
CREATE TABLE Employee_Projects (
    employee_id INT,
    project_id INT,
    role TEXT NOT NULL,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Employee_Projects (employee_id, project_id, role) VALUES
(101, 201, 'Lead'),
(105, 201, 'Coordinator'),
(102, 202, 'Developer'),
(103, 202, 'UI Designer'),
(106, 202, 'Tester'),
(104, 203, 'Analyst'),
(107, 203, 'Marketer'),
(103, 203, 'Support'),
(102, 204, 'Consultant');

-- =============================================================================
-- Problem 1: Employee Project Count (Normal)
-- Description: List all employees and their total number of projects, including those with no projects.
-- Output: first_name, last_name, total_projects
-- =============================================================================
SELECT 
    e.first_name,
    e.last_name,
    COUNT(ep.project_id) AS total_projects
FROM 
    Employees e
LEFT JOIN 
    Employee_Projects ep ON e.employee_id = ep.employee_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name
ORDER BY 
    total_projects DESC, e.first_name ASC;

-- =============================================================================
-- Problem 2: Active Projects by Department (Normal)
-- Description: Find departments with active projects (end_date IS NULL).
-- Output: department_name, active_projects
-- =============================================================================
SELECT 
    d.department_name,
    COUNT(p.project_id) AS active_projects
FROM 
    Departments d
INNER JOIN 
    Projects p ON d.department_id = p.department_id
WHERE 
    p.end_date IS NULL
GROUP BY 
    d.department_id, d.department_name
ORDER BY 
    active_projects DESC, d.department_name ASC;

-- =============================================================================
-- Problem 3: High-Salary Employees in Engineering (Normal)
-- Description: Find Engineering department employees with salary > 80,000.
-- Output: first_name, last_name, salary, hire_date
-- =============================================================================
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    e.hire_date
FROM 
    Employees e
INNER JOIN 
    Departments d ON e.department_id = d.department_id
WHERE 
    d.department_id = 2
    AND e.salary > 80000
ORDER BY 
    e.salary DESC, e.first_name ASC;

-- =============================================================================
-- Problem 4: Employees Without Projects (Normal)
-- Description: List employees not assigned to any projects.
-- Output: first_name, last_name, department_id
-- =============================================================================
SELECT 
    e.first_name,
    e.last_name,
    e.department_id
FROM 
    Employees e
LEFT JOIN 
    Employee_Projects ep ON e.employee_id = ep.employee_id
WHERE 
    ep.project_id IS NULL
ORDER BY 
    e.first_name ASC;

-- =============================================================================
-- Problem 5: Department Salary Totals (Normal)
-- Description: Calculate total salary per department, including those with no employees.
-- Output: department_name, total_salary
-- =============================================================================
SELECT 
    d.department_name,
    COALESCE(ROUND(SUM(e.salary), 2), 0) AS total_salary
FROM 
    Departments d
LEFT JOIN 
    Employees e ON d.department_id = e.department_id
GROUP BY 
    d.department_id, d.department_name
ORDER BY 
    total_salary DESC, d.department_name ASC;

-- =============================================================================
-- Problem 6: Projects with Multiple Employees (Normal)
-- Description: Find projects with more than one assigned employee.
-- Output: project_name, employee_count
-- =============================================================================
SELECT 
    p.project_name,
    COUNT(ep.employee_id) AS employee_count
FROM 
    Projects p
INNER JOIN 
    Employee_Projects ep ON p.project_id = ep.project_id
GROUP BY 
    p.project_id, p.project_name
HAVING 
    COUNT(ep.employee_id) > 1
ORDER BY 
    employee_count DESC, p.project_name ASC;

-- =============================================================================
-- Problem 7: Employees Hired After 2020 (Normal)
-- Description: List employees hired after January 1, 2020, with their department.
-- Output: first_name, last_name, department_name, hire_date
-- =============================================================================
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    e.hire_date
FROM 
    Employees e
INNER JOIN 
    Departments d ON e.department_id = d.department_id
WHERE 
    e.hire_date > '2020-01-01'
ORDER BY 
    e.hire_date ASC;

-- =============================================================================
-- Problem 8: Project Roles by Department (Normal)
-- Description: Count employees in each role for Engineering department projects.
-- Output: role, employee_count
-- =============================================================================
SELECT 
    ep.role,
    COUNT(ep.employee_id) AS employee_count
FROM 
    Departments d
INNER JOIN 
    Projects p ON d.department_id = p.department_id
INNER JOIN 
    Employee_Projects ep ON p.project_id = ep.project_id
WHERE 
    d.department_id = 2
GROUP BY 
    ep.role
ORDER BY 
    employee_count DESC, ep.role ASC;

-- =============================================================================
-- Problem 9: Managers with Active Projects (Normal)
-- Description: List managers working on active projects (end_date IS NULL).
-- Output: first_name, last_name, project_name
-- =============================================================================
SELECT 
    e.first_name,
    e.last_name,
    p.project_name
FROM 
    Departments d
INNER JOIN 
    Employees e ON d.manager_id = e.employee_id
INNER JOIN 
    Employee_Projects ep ON e.employee_id = ep.employee_id
INNER JOIN 
    Projects p ON ep.project_id = p.project_id
WHERE 
    p.end_date IS NULL
ORDER BY 
    p.project_name ASC;

-- =============================================================================
-- Problem 10: Average Salary by Project Role (Normal)
-- Description: Calculate average salary for each project role.
-- Output: role, avg_salary
-- =============================================================================
SELECT 
    ep.role,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM 
    Employees e
INNER JOIN 
    Employee_Projects ep ON e.employee_id = ep.employee_id
GROUP BY 
    ep.role
ORDER BY 
    avg_salary DESC, ep.role ASC;