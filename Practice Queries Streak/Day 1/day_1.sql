-- ----------------------------------------------- SQL Practice -- Day 1 ------------------------------------------------------

-- Create Database (Day_1)
create database day_1;
use day_1;
-- --------------------------------------------------------

-- 🛍️ Customers. 
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    join_date DATE
);

INSERT INTO Customers VALUES
(1, 'Ali', 'ali@gmail.com', 'Lahore', '2023-01-05'),
(2, 'Sara', 'sara@yahoo.com', 'Karachi', '2023-03-15'),
(3, 'Zara', 'zara@hotmail.com', 'Lahore', '2023-02-10'),
(4, 'Usman', 'usman@gmail.com', 'Islamabad', '2023-04-01');
-- -----------------------------------------------------------

-- 📦 Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(101, 1, 500.00, 'Completed', '2023-04-12'),
(102, 1, 120.00, 'Pending', '2023-04-15'),
(103, 2, 800.00, 'Completed', '2023-04-10'),
(104, 3, 450.00, 'Cancelled', '2023-04-08'),
(105, 4, 700.00, 'Completed', '2023-04-17');
-- -----------------------------------------------------------

-- 📦 Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1200.00, 10),
(2, 'Phone', 'Electronics', 700.00, 5),
(3, 'Shoes', 'Fashion', 50.00, 100),
(4, 'Watch', 'Accessories', 150.00, 20);
-- -----------------------------------------------------------

-- 📦 OrderDetails
CREATE TABLE OrderDetails (
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderDetails VALUES
(1, 101, 1, 1),
(2, 101, 3, 2),
(3, 102, 4, 1),
(4, 103, 2, 1),
(5, 104, 3, 1),
(6, 105, 1, 1);

-- ----------------------------------------------------------------------------Problem Statements------------------------------------------------------------
-- Problem 1: Customer Order Summary (Easy)
-- Problem: You’re an AI engineer building a customer analytics dashboard. 
	-- 	Write a SQL query to retrieve a list of customers from the Customers table, 
	-- 	along with the total number of orders they’ve placed (from the Orders table). 
	-- 	Include all customers, even those with no orders. Display the customer’s name, 
	-- 	email, and the total number of orders, sorted alphabetically by name.

select * from Customers;
select * from Orders;

select c.name, c.email, count(c.name) 
from Customers c 
left join Orders o on 
	c.customer_id = o.customer_id
group by c.name, c.email
order by c.name;

-- Problem 2: Completed Orders by City (Normal)
	-- Problem: Your AI system needs to analyze order patterns for a logistics model. 
	-- Write a SQL query to find the total amount of completed orders for each city in the Customers table. 
	-- Join the Customers and Orders tables, and display the city and the total amount (sum of amount from Orders where status = 'Completed'). 
	-- Only include cities with completed orders, and sort by total amount in descending order.
select * from Customers;
select * from Orders;

select c.city, sum(o.amount) as total_amount 
from Customers c 
inner join Orders o on 
	c.customer_id = o.customer_id 
where o.status = 'Completed' 
group by c.city, o.amount 
order by total_amount 
asc;

-- Problem 3: Recent Customers (Easy)
-- Problem: You’re preparing data for an AI model to predict customer retention. 
-- Write a SQL query to find all customers who joined after January 31, 2023, from the Customers table. 
-- Display their name, email, and join_date, sorted by join_date in ascending order.
select * from day_1.Customers;
select name, email, join_date from day_1.Customers where join_date > '2023-01-31' order by join_date desc;

-- Problem 4: High-Value Orders (Easy)
-- Problem: Your AI system needs to identify high-value customers for a recommendation model. 
-- Write a SQL query to list all orders from the Orders table with an amount greater than 400. 
-- Display order_id, customer_id, amount, and status, sorted by amount in descending order.
select * from day_1.Orders;
select order_id, customer_id, amount, status from day_1.Orders order by amount desc;

-- Problem 5: Product Categories in Orders (Normal) 
-- Problem: You’re building a dataset for an AI model to analyze product popularity. 
-- Write a SQL query to find all product categories that appear in completed orders. 
-- Join the Orders, OrderDetails, and Products tables, and display each unique category 
-- from Products where the order status is “Completed”. 
-- Sort alphabetically by category.
select * from day_1.Orders;
select * from day_1.OrderDetails;
select * from day_1.Products;

select distinct P.category
from day_1.Orders O 
	inner join day_1.OrderDetails OD on 
		O.order_id = OD.order_id 
	inner join day_1.Products P on 
		OD.product_id = P.product_id
where 
	O.status = 'Completed' 
order by P.category asc;

-- Problem 6: Customers with Cancelled Orders (Normal) 
-- Problem: Your AI model needs to identify customers at risk of churn based on order cancellations. 
-- Write a SQL query to list customers who have at least one cancelled order. 
-- Join the Customers and Orders tables, and display name, email, and the number of cancelled orders per customer. 
-- Sort by the number of cancelled orders descending, then by name ascending.
select * from day_1.Customers;
select * from day_1.Orders;

select C.name, C.email, count(C.customer_id) as Cancelled_Order 
from day_1.Orders O 
join day_1.Customers C on 
	O.customer_id = C.customer_id 
where O.status='Cancelled' 
group by C.name, C.email, C.customer_id
order by Cancelled_Order desc, C.name asc;

-- Problem 7: Low Stock Products in Orders (Normal)
-- Problem: You’re preparing data for an AI inventory management system. 
-- Write a SQL query to find products that were ordered (in any order status) 
-- and have low stock (less than 10 units). Join the Products, OrderDetails, 
-- and Orders tables, and display name (product name), category, and stock. 
-- Return unique products, sorted by stock ascending.
select * from day_1.Orders;
select * from day_1.Products;
select * from day_1.OrderDetails;

select P.name, P.category, P.stock 
from day_1.Orders O 
join day_1.OrderDetails OD on 
	O.order_id = OD.order_id 
join day_1.Products P on 
	OD.product_id = P.product_id 
where P.stock < 10
group by P.name, P.category, P.stock
order by P.stock asc;

-- Problem 8: Average Order Amount by Customer
-- Problem: You’re building a customer segmentation model for an AI system. 
-- Write a SQL query to calculate the average order amount for each customer who has placed at least one order. 
-- Join the Customers and Orders tables, and display the customer’s name, email, and their average order amount (rounded to 2 decimal places). 
-- Sort by average amount in descending order.
select * from day_1.Customers;
select * from day_1.Orders;

select C.name, C.email, round((O.amount), 2) as avg_amount 
from day_1.Customers C 
inner join day_1.Orders O on 
	C.customer_id = O.customer_id 
group by C.name, C.email, O.amount 
order by avg_amount desc;

-- Problem 9: Products Ordered in April 2023
-- Problem: Your AI inventory model needs data on recent orders. 
-- Write a SQL query to list all products ordered in April 2023 (based on order_date in Orders). 
-- Join the Orders, OrderDetails, and Products tables, and display the product name, category, and the 
-- total quantity ordered. Sort by total quantity descending, then by product name ascending.
select * from day_1.Orders;
select * from day_1.OrderDetails;
select * from day_1.Products;

select P.name, P.category, sum(OD.quantity) as tot_quantity from day_1.OrderDetails OD 
join day_1.Orders O on 
	OD.order_id = O.order_id 
join day_1.Products P on 
	OD.product_id = P.product_id 
where O.order_date between '2023-04-01' and '2023-04-30'
group by P.name, P.category, OD.quantity
order by tot_quantity desc, P.name;

-- Problem 10: Customers with Multiple Orders
-- Problem: You’re preparing data for an AI model to identify loyal customers. 
-- Write a SQL query to find customers who have placed more than one order. 
-- Join the Customers and Orders tables, and display the customer’s name, email, 
-- and the number of orders. Sort by the number of orders descending, then by name ascending.
select * from day_1.Customers;
select * from day_1.Orders;

select C.customer_id, C.name, C.email, count(C.customer_id) as order_count 
from day_1.Customers C 
join day_1.Orders O on 
	C.customer_id = O.customer_id 
group by C.customer_id, C.customer_id, C.name, C.email
having count(O.order_id) > 1 
order by order_count;