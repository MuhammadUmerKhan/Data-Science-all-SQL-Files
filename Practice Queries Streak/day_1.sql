-- =============================================================================
-- SQL Practice: Day 1 - E-Commerce Database
-- Description: Schema and solutions for 10 SQL problems to build data skills for AI engineering.
-- Author: [Your Name]
-- Date: April 25, 2025
-- Database: day_1 (E-commerce with Customers, Orders, Products, OrderDetails)
-- =============================================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS day_1;
USE day_1;

-- =============================================================================
-- Table: Customers
-- Description: Stores customer information
-- =============================================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE
);

INSERT INTO Customers (customer_id, name, email, city, join_date) VALUES
(1, 'Ali', 'ali@gmail.com', 'Lahore', '2023-01-05'),
(2, 'Sara', 'sara@yahoo.com', 'Karachi', '2023-03-15'),
(3, 'Zara', 'zara@hotmail.com', 'Lahore', '2023-02-10'),
(4, 'Usman', 'usman@gmail.com', 'Islamabad', '2023-04-01');

-- =============================================================================
-- Table: Orders
-- Description: Stores order details with reference to customers
-- =============================================================================
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, customer_id, amount, status, order_date) VALUES
(101, 1, 500.00, 'Completed', '2023-04-12'),
(102, 1, 120.00, 'Pending', '2023-04-15'),
(103, 2, 800.00, 'Completed', '2023-04-10'),
(104, 3, 450.00, 'Cancelled', '2023-04-08'),
(105, 4, 700.00, 'Completed', '2023-04-17');

-- =============================================================================
-- Table: Products
-- Description: Stores product information
-- =============================================================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

INSERT INTO Products (product_id, name, category, price, stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 10),
(2, 'Phone', 'Electronics', 700.00, 5),
(3, 'Shoes', 'Fashion', 50.00, 100),
(4, 'Watch', 'Accessories', 150.00, 20);

-- =============================================================================
-- Table: OrderDetails
-- Description: Stores details of products in each order
-- =============================================================================
CREATE TABLE OrderDetails (
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderDetails (detail_id, order_id, product_id, quantity) VALUES
(1, 101, 1, 1),
(2, 101, 3, 2),
(3, 102, 4, 1),
(4, 103, 2, 1),
(5, 104, 3, 1),
(6, 105, 1, 1);

-- =============================================================================
-- Problem 1: Customer Order Summary (Easy)
-- Description: Retrieve all customers and their total number of orders, including those with no orders.
-- Output: name, email, total_orders
-- =============================================================================
SELECT 
    c.name,
    c.email,
    COUNT(o.order_id) AS total_orders
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name, c.email
ORDER BY 
    c.name ASC;

-- =============================================================================
-- Problem 2: Completed Orders by City (Normal)
-- Description: Calculate total amount of completed orders per city with completed orders.
-- Output: city, total_amount
-- =============================================================================
SELECT 
    c.city,
    SUM(o.amount) AS total_amount
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.customer_id = o.customer_id
WHERE 
    o.status = 'Completed'
GROUP BY 
    c.city
ORDER BY 
    total_amount DESC;

-- =============================================================================
-- Problem 3: Recent Customers (Easy)
-- Description: Find customers who joined after January 31, 2023.
-- Output: name, email, join_date
-- =============================================================================
SELECT 
    name,
    email,
    join_date
FROM 
    Customers
WHERE 
    join_date > '2023-01-31'
ORDER BY 
    join_date ASC;

-- =============================================================================
-- Problem 4: High-Value Orders (Easy)
-- Description: List orders with amount greater than 400.
-- Output: order_id, customer_id, amount, status
-- =============================================================================
SELECT 
    order_id,
    customer_id,
    amount,
    status
FROM 
    Orders
WHERE 
    amount > 400
ORDER BY 
    amount DESC;

-- =============================================================================
-- Problem 5: Product Categories in Orders (Normal)
-- Description: Find unique product categories in completed orders.
-- Output: category
-- =============================================================================
SELECT DISTINCT 
    p.category
FROM 
    Orders o
INNER JOIN 
    OrderDetails od ON o.order_id = od.order_id
INNER JOIN 
    Products p ON od.product_id = p.product_id
WHERE 
    o.status = 'Completed'
ORDER BY 
    p.category ASC;

-- =============================================================================
-- Problem 6: Customers with Cancelled Orders (Normal)
-- Description: List customers with cancelled orders and their cancellation count.
-- Output: name, email, cancelled_orders
-- =============================================================================
SELECT 
    c.name,
    c.email,
    COUNT(o.order_id) AS cancelled_orders
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.customer_id = o.customer_id
WHERE 
    o.status = 'Cancelled'
GROUP BY 
    c.customer_id, c.name, c.email
ORDER BY 
    cancelled_orders DESC, c.name ASC;

-- =============================================================================
-- Problem 7: Low Stock Products in Orders (Normal)
-- Description: Find ordered products with stock less than 10.
-- Output: name, category, stock
-- =============================================================================
SELECT DISTINCT 
    p.name,
    p.category,
    p.stock
FROM 
    Products p
INNER JOIN 
    OrderDetails od ON p.product_id = od.product_id
INNER JOIN 
    Orders o ON od.order_id = o.order_id
WHERE 
    p.stock < 10
ORDER BY 
    p.stock ASC;

-- =============================================================================
-- Problem 8: Average Order Amount by Customer (Normal)
-- Description: Calculate average order amount for customers with orders.
-- Output: name, email, avg_order_amount
-- =============================================================================
SELECT 
    c.name,
    c.email,
    ROUND(AVG(o.amount), 2) AS avg_order_amount
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name, c.email
ORDER BY 
    avg_order_amount DESC;

-- =============================================================================
-- Problem 9: Products Ordered in April 2023 (Normal)
-- Description: List products ordered in April 2023 with total quantity.
-- Output: name, category, total_quantity
-- =============================================================================
SELECT 
    p.name,
    p.category,
    SUM(od.quantity) AS total_quantity
FROM 
    Orders o
INNER JOIN 
    OrderDetails od ON o.order_id = od.order_id
INNER JOIN 
    Products p ON od.product_id = p.product_id
WHERE 
    o.order_date BETWEEN '2023-04-01' AND '2023-04-30'
GROUP BY 
    p.product_id, p.name, p.category
ORDER BY 
    total_quantity DESC, p.name ASC;

-- =============================================================================
-- Problem 10: Customers with Multiple Orders (Normal)
-- Description: Find customers with more than one order.
-- Output: name, email, order_count
-- =============================================================================
SELECT 
    c.name,
    c.email,
    COUNT(o.order_id) AS order_count
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name, c.email
HAVING 
    COUNT(o.order_id) > 1
ORDER BY 
    order_count DESC, c.name ASC;