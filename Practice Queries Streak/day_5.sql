-- Create the database
CREATE DATABASE IF NOT EXISTS day_5;
USE day_5;

-- Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    registration_date DATE
);

-- Create Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price DECIMAL(10,2)
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert into Customers
INSERT INTO Customers (customer_id, first_name, last_name, registration_date) VALUES
(1, 'John', 'Doe', '2022-01-15'),
(2, 'Jane', 'Smith', '2022-03-22'),
(3, 'Mike', 'Brown', '2023-02-10'),
(4, 'Emily', 'Davis', '2023-06-05');

-- Insert into Products
INSERT INTO Products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Phone', 'Electronics', 800.00),
(3, 'Desk Chair', 'Furniture', 150.00),
(4, 'Notebook', 'Stationery', 5.00),
(5, 'Pen', 'Stationery', 2.00);

-- Insert into Orders
INSERT INTO Orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-01-10'),
(2, 2, '2023-02-15'),
(3, 1, '2023-04-20'),
(4, 3, '2023-05-10');

-- Insert into Order_Items
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1),
(2, 1, 4, 5),
(3, 2, 2, 1),
(4, 2, 5, 10),
(5, 3, 3, 1),
(6, 4, 1, 1),
(7, 4, 5, 3);

-- ----------------------------------------------------------------------------------------------------------------------
-- 🧩 Problem 1: Categorize Customers by Registration Year (CASE)
	-- Question:
		-- Use CASE to classify customers as "Old" if registered before 2023, otherwise "New".
select first_name, last_name,
	case
		when registration_date < '2023-01-01' then 'Old Customer'
        else 'New Customer'
	end as customer_status
from Customers;

-- 🧩 Problem 2: Find Customers with Total Orders and Classify (CASE + GROUP BY)
	-- Question:
		-- List customers, count their total orders, and classify them:
			-- "Loyal" if more than 1 order / "New" if 1 or less orders
select c.first_name, c.last_name, 
		count(o.order_id) as total_order,
        case 
			when count(o.order_id) > 1 then 'Loyal'
			else 'New'
        end as customer_order_analysis
from Customers c 
	left join Orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name;

-- 🧩 Problem 3: Average Quantity Ordered Per Customer Using CTE
	-- Question:
		-- Use a CTE to first calculate the total quantity per customer, then find average quantity across all customers.
with CustomerQuantities as (
	select c.first_name, c.last_name, sum(oi.quantity) as order_quantity
	from Customers c 
		join Orders o on c.customer_id = o.customer_id
		join Order_Items oi on o.order_id = oi.order_id
	group by c.customer_id, c.first_name, c.last_name
)
select avg(order_quantity) as average_quantity from CustomerQuantities;

-- 🧩 Problem 4: Show Each Product Sale Status (CASE)
	-- Question:
		-- Show all products with status:
		-- "Sold" if it appears in any order/"Not Sold" otherwise
select p.product_name,
	case
		when oi.order_item_id is not null then "Sold"
        else "Not Sold"
	end as sale_status
from Products p
	left join Order_Items oi on p.product_id = oi.product_id;

-- 🧩 Problem 5: Top-Selling Products using CTE + RANK()
	-- Question:
	-- Use a CTE to calculate total quantity sold per product, then rank them.
with ProductSales as (
	select p.product_name, sum(oi.quantity) as total_quantity
	from Products p 
		join Order_Items oi on p.product_id = oi.product_id
	group by p.product_id, p.product_name
)
select product_name, total_quantity,
		rank() over (order by total_quantity desc) as sales_rank
from ProductSales
order by sales_rank asc;

-- 🧩 Problem 6: Customers With Total Spend Using CTE
	-- Question:
	-- Calculate each customer's total spend across all orders.
with CustomerSpend as (
	select c.customer_id, c.first_name, c.last_name, 
			sum(oi.quantity * p.price) as total_spends
	from Customers c
		join Orders o on c.customer_id = o.customer_id
		join Order_Items oi on o.order_id = oi.order_id
		join Products p on p.product_id = oi.product_id
	group by c.customer_id, c.first_name, c.last_name
)
select first_name, last_name, total_spends from CustomerSpend order by total_spends desc;

-- 🧩 Problem 7: Customers with Multiple Orders (Using CTE + HAVING)
	-- Question:
	-- Find customers who have placed more than 2 orders. Use CTE and HAVING.
select * from Orders;
	with CustomerOrders as (
	select customer_id, count(order_id) as order_count
	from Orders
	group by customer_id
)
select c.first_name, c.last_name, co.order_count
from Customers c 
	join CustomerOrders co on c.customer_id = co.customer_id
where co.order_count >= 2;

-- 🧩 Problem 8: Products That Have Never Been Sold (LEFT JOIN + IS NULL)
	-- Question:
	-- Find all products that were never sold (never ordered).
select p.product_name from Products p left join Order_Items oi on p.product_id = oi.product_id
where oi.order_id is null;

-- 🧩 Problem 9: Total Revenue per Customer Using CTE + CASE
-- Question:
	-- Calculate each customer's total revenue. Also, classify them:
		-- "High Value" if total revenue > 500/"Low Value" otherwise
with CustomerRevenue as (
	select c.customer_id, c.first_name, c.last_name,
			sum(oi.quantity * p.price) as total_spends
	from Customers c 
		join Orders o on c.customer_id = o.customer_id
		join Order_Items oi on o.order_id = oi.order_id
		join Products p on oi.product_id = p.product_id
	group by c.customer_id, c.first_name, c.last_name
	order by total_spends desc
)
select first_name, last_name, total_spends, 
		case
			when total_spends > 500 then 'High Value'
            else 'Low Value'
		end as revenue_classification
from CustomerRevenue;

-- 🧩 Bonus Problem 11: Customers Who Ordered More Than 5 Products in Total (Using CTE + CASE)
	-- Question:
		-- Find customers who ordered more than 5 products (total quantity across all orders).
		-- Also show whether they are "Bulk Buyer" (if quantity > 5) or "Regular Buyer" (otherwise).
with CustomerProductQuantity as (
	select c.customer_id, c.first_name, c.last_name,
			sum(oi.quantity) as order_quantity
	from Customers c 
		join Orders o on c.customer_id = o.customer_id
		join Order_Items oi on o.order_id = oi.order_id
	group by c.customer_id, c.first_name, c.last_name
	order by order_quantity desc
)
select first_name, last_name, order_quantity,
		case 
			when order_quantity > 5 then 'Bulk Buyer'
            else 'Regular Buyer'
		end as buyer_type
from CustomerProductQuantity;

-- Find the top 2 most ordered products by total quantity sold.
with ProductSales as (
	select 
		p.product_name, sum(oi.quantity) as quantity_sold
	from Products p 
		join Order_Items oi on p.product_id = oi.product_id
	group by p.product_id, p.product_name
	order by quantity_sold desc
)
select 
	product_name, quantity_sold
    from
    (select *, rank() over (order by quantity_sold desc) as solds_rank from ProductSales)
ranked
where solds_rank <= 2;

-- List customers who placed more than 3 orders. Show their name and order count.
select 
	c.first_name, count(o.order_id) as OrderCount 
from Customers c 
	join Orders o on 
		c.customer_id = o.customer_id
group by c.first_name
having count(o.order_id) > 3;

-- Find the total revenue (price × quantity) generated per product.
select 
	p.product_name, sum(oi.quantity * p.price) as production_revenue
from Products p 
	join Order_Items oi on 
		p.product_id = oi.product_id
group by p.product_name
order by production_revenue desc;

-- Find the customer who generated the highest revenue.
with CustomerRevenue as (
	select c.customer_id, c.first_name, c.last_name, sum(p.price * oi.quantity) as total_revenue
		from Customers c 
			join Orders o on c.customer_id = o.customer_id
			join Order_Items oi on o.order_id = oi.order_id
			join Products p on oi.product_id = p.product_id
		group by c.customer_id, c.first_name, c.last_name
)
select first_name, last_name, total_revenue
from CustomerRevenue
order by total_revenue desc;

-- List each product with its percentage share of total quantity sold.
with ProductsSolds as (
	select p.product_name, sum(oi.quantity) as total_quantity
	from Products p 
		join Order_Items oi on p.product_id = oi.product_id
	group by p.product_name
	order by total_quantity desc
)
select 
	product_name, total_quantity, 
    round((total_quantity / (select sum(quantity) from Order_Items) * 100.0), 2) as percentage_share
from ProductsSolds
order by total_quantity desc, percentage_share desc;

-- List customers and their first order date.
select 
	c.first_name, c.last_name, min(o.order_date) as first_order_date
from Customers c 
	join Orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name,c.last_name;

-- Show products along with number of customers who have bought them.

select p.product_name, count(distinct o.customer_id) as num_customer_buy
from Products p 
	join Order_Items oi on p.product_id = oi.product_id
    join Orders o on oi.order_id = o.order_id
group by p.product_name
order by num_customer_buy desc;

-- Find the most recent order placed by each customer.
with RankedOrders as (
	select 
		order_id, customer_id, order_date,
		row_number() over (partition by customer_id order by order_date desc) as rnk
	from Orders
)
select c.first_name, order_id, order_date
from Customers c 
	join RankedOrders r on c.customer_id = r.customer_id
where rnk = 1;

-- Find the second most ordered product by quantity.
with ProductSales as (
	select p.product_name, sum(oi.quantity) as total_solds
	from Products p 
		join Order_Items oi on p.product_id = oi.product_id
	group by p.product_name
	order by total_solds desc
)
select 
	product_name, total_solds
    from (select *, dense_rank() over (order by total_solds desc) as rnk from ProductSales) ranked
where rnk=2;