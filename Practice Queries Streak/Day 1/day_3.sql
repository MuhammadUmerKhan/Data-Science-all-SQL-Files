CREATE DATABASE IF NOT EXISTS day_3;
USE day_3;

-- Table: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    signup_date DATE
);

INSERT INTO Customers (customer_id, name, email, city, signup_date) VALUES
(1, 'Ali Khan', 'ali@gmail.com', 'Lahore', '2023-01-10'),
(2, 'Sara Ahmed', 'sara@yahoo.com', 'Karachi', '2023-02-15'),
(3, 'Zain Malik', 'zain@hotmail.com', 'Islamabad', '2023-03-01'),
(4, 'Hina Raza', 'hina@gmail.com', 'Lahore', '2023-04-20'),
(5, 'Omar Farooq', 'omar@gmail.com', 'Karachi', '2023-05-05');

-- Table: Stores
CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

INSERT INTO Stores (store_id, store_name, city) VALUES
(1, 'Main Branch', 'Lahore'),
(2, 'City Mall', 'Karachi'),
(3, 'Capital Store', 'Islamabad');

-- Table: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO Products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Smartphone', 'Electronics', 800.00),
(3, 'Headphones', 'Accessories', 100.00),
(4, 'T-Shirt', 'Clothing', 20.00);

-- Table: Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    store_id INT,
    product_id INT,
    quantity INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Transactions (transaction_id, customer_id, store_id, product_id, quantity, amount, transaction_date) VALUES
(1, 1, 1, 1, 1, 1200.00, '2023-06-01'),
(2, 1, 1, 3, 2, 200.00, '2023-06-02'),
(3, 2, 2, 2, 1, 800.00, '2023-06-05'),
(4, 3, 3, 4, 3, 60.00, '2023-06-10'),
(5, 4, 1, 1, 1, 1200.00, '2023-07-01'),
(6, 2, 2, 3, 1, 100.00, '2023-07-15'),
(7, 5, 2, 2, 1, 800.00, '2023-08-01');

-- Day 3: Easy/Normal SQL Practice Problems
	-- Below are 10 SQL problems (5 Easy, 5 Normal) to help you learn subqueries and window functions 
	-- while reinforcing Day 1/Day 2 skills (JOINs, GROUP BY, WHERE). Each problem is designed to be accessible, 
	-- with explanations to clarify how these new functions work.

-- Problem 1: Recent Customers (Easy)
	-- Problem: Your AI model needs recent customer data for onboarding analysis. 
    -- Write a SQL query to list customers who signed up after March 1, 2023. 
    -- Display the name, email, and signup_date from the Customers table. 
    -- Sort by signup_date ascending.
select * from day_3.Customers;
select name, email, signup_date from day_3.Customers where signup_date > '2023-01-01' order by signup_date asc;

-- Problem 2: Expensive Products (Easy)
	-- Problem: You’re preparing data for an AI pricing model. 
    -- Write a SQL query to list products with a price greater than 500. 
    -- Display the product_name, category, and price from the Products table. 
    -- Sort by price descending.
select * from Products;
select product_name, category, price from day_3.Products where price > 500 order by price desc;

-- Problem: Your AI system needs to identify active stores for performance analysis. Write a SQL query to list stores that have at least one transaction. Join the Stores and Transactions tables, and display the store_name and city. Sort by store_name ascending.
	-- Problem: Your AI system needs to identify active stores for performance analysis. 
    -- Write a SQL query to list stores that have at least one transaction. 
    -- Join the Stores and Transactions tables, and display the store_name and city. 
    -- Sort by store_name ascending.
select * from day_3.Stores;
select * from day_3.Transactions;

select 
	S.store_name, S.city
from day_3.Stores S 
	join day_3.Transactions T on 
		S.store_id = T.store_id 
group by S.store_name, S.store_id, S.city
having count(T.transaction_id) > 0
order by S.store_name asc;

-- Problem 4: Customer Transaction Count (Easy)
	-- Problem: You’re building an AI model to analyze customer activity. 
    -- Write a SQL query to count the number of transactions per customer, including those with no transactions. 
    -- Join the Customers and Transactions tables, and display the name, email, and transaction count. 
    -- Sort by transaction count descending, then name ascending.
select * from Customers;
select * from Transactions;

select 
	C.name, C.email, count(C.customer_id) as transaction_count
from Customers C 
	left join Transactions T on 
		C.customer_id = T.customer_id 
group by C.customer_id, C.name, C.email
order by transaction_count desc, C.name asc;

-- Problem 5: Total Sales by City (Easy)
	-- Problem: Your AI model needs to analyze sales distribution for regional targeting. 
	-- Write a SQL query to calculate the total transaction amount for each city. 
    -- Join the Stores and Transactions tables, and display the city and total amount (rounded to 2 decimal places). 
    -- Sort by total amount descending.
select * from Stores;
select * from Transactions;

select 
	S.city, round(sum(T.amount), 2) as tot_amount 
from Stores S 
	join Transactions T on 
		S.store_id = T.store_id 
group by S.city 
order by tot_amount desc;

-- Problem 6: Customers with High-Value Transactions (Normal)
	-- Problem: Your AI model needs to identify big spenders for a loyalty program. 
    -- Write a SQL query to find customers who have at least one transaction with an amount greater than 1000, using a subquery. 
    -- Join the Customers and Transactions tables, and display the name and email. Sort by name ascending.
select * from Customers;
select * from Transactions;

select 
	C.name, C.email
from Customers C 
where C.customer_id in 
	(select customer_id from Transactions where amount > 1000) 
order by C.name;


-- Problem 7: Top Spending Customer (Normal)
	-- Problem: You’re preparing data for an AI model to reward top customers. 
    -- Write a SQL query to find the customer with the highest total transaction amount, 
    -- using a subquery to determine the maximum total. 
    -- Join the Customers and Transactions tables, and display the name, email, and total amount (rounded to 2 decimal places).

select * from Customers;
select * from Transactions;

select 
	C.name, C.email, round(sum(T.amount), 2) as total_amount
from Customers C 
	join Transactions T on 
		C.customer_id = T.customer_id 
	group by C.customer_id, C.name, C.email
	having 
		sum(T.amount) = (select max(total_amount) from (select sum(amount) as total_amount from Transactions group by customer_id) sub);

-- Problem 8: Product Sales Ranking (Normal)
	-- Problem: Your AI inventory model needs to prioritize top-selling products. 
    -- Write a SQL query to rank products by total quantity sold, using a window function. 
    -- Join the Products and Transactions tables, and display the product_name, category, total_quantity, and rank. 
    -- Sort by rank ascending, then product_name ascending.

select 
	P.product_name, P.category, sum(T.quantity) as tot_quantity_sold,
    rank() over (order by sum(T.quantity)) as rank_num
from Products P 
	join Transactions T on 
		P.product_id = T.product_id 
group by P.product_name, P.category
order by rank_num asc, P.product_name asc;

-- Problem 9: Electronics Transactions (Normal)
	-- Problem: Your AI model needs data on electronics sales for trend analysis. 
    -- Write a SQL query to list transactions for products in the Electronics category, 
    -- using a subquery to identify Electronics products. 
    -- Join the Transactions, Products, and Customers tables, and display the 
			-- transaction_id, customer_name (from Customers.name), product_name, and amount. 
	-- Sort by amount descending.

select 
	T.transaction_id, C.name as Customer_name, P.product_name, T.amount, P.category
from Products P 
	join Transactions T on 
		P.product_id = T.product_id 
	join Customers C on 
		T.customer_id = C.customer_id
where P.product_id in 
	(select product_id from Products where category='Electronics')
order by T.amount desc;

-- Problem 10: Customer Transaction Rankings by City (Normal)
	-- Problem: Your AI model needs to rank customers by transaction count within each city for regional analysis. 
    -- Write a SQL query to rank customers based on their number of transactions, partitioned by city, using a window function. 
    -- Join the Customers and Transactions tables, and display the name, city, transaction_count, and rank. 
    -- Sort by city ascending, then rank ascending.
select * from Customers;
select * from Transactions;

select 
	C.name, C.city, count(T.transaction_id) as total_transactions,
    rank() over (partition by(C.city)) as rank_by_city
from Customers C 
	join Transactions T on 
		C.customer_id = T.customer_id
group by C.name, C.city
order by C.city asc, rank_by_city asc;

-- Problem 11: Customers with Multiple Transactions (Easy)
	-- Problem: Your AI model needs to identify active customers for engagement campaigns. 
    -- Write a SQL query to find customers who have more than one transaction, using a subquery. 
    -- Display the name and email from the Customers table. Sort by name ascending.
select * from Customers;
select * from Transactions;

select 
	name, email 
from Customers 
where customer_id in 
	(select 
		customer_id 
		from Transactions 
		group by customer_id 
		having(count(customer_id)>1)
    )
order by name;

-- Problem 12: Stores with High Transaction Amounts (Easy)
	-- Problem: You’re preparing data for an AI model to evaluate store performance. 
    -- Write a SQL query to find stores with at least one transaction where the amount is greater than 1000, using a subquery. 
    -- Join the Stores and Transactions tables, and display the store_name and city. 
    -- Sort by store_name ascending.
select * from Transactions;
select * from Stores;

select 
	S.store_name, S.city from Stores S
	where S.store_id in 
		(select store_id from Transactions where amount > 1000)
order by S.store_name asc;

-- Problem 13: Top Transaction by Store (Normal)
	-- Problem: Your AI model needs to highlight flagship transactions for marketing. 
    -- Write a SQL query to find the transaction with the highest amount in each store, using a window function. 
    -- Join the Stores, Transactions, and Customers tables, and display the store_name, customer_name (from Customers.name), amount, and rank. 
    -- Filter for rank 1 and sort by amount descending.
select * from Stores;
select * from Transactions;
select * from Customers;

select S.store_name, C.name, R.amount, R.rank_no from
(
select 
	T.store_id, T.customer_id, T.amount as amount,
    rank() over (partition by(T.store_id) order by T.amount desc) as rank_no
from Transactions T
) R
join Stores S on R.store_id = S.store_id
join Customers C on R.customer_id = C.customer_id
where rank_no = 1
order by R.amount desc;


-- Problem 14: Products Sold in Multiple Stores (Normal)
	-- Problem: Your AI model needs to identify widely distributed products for inventory planning. 
    -- Write a SQL query to find products sold in more than one store, using a subquery. 
    -- Join the Products, Transactions, and Stores tables, and display the product_name and category. 
    -- Sort by product_name ascending.
select * from Products;
select * from Transactions;
select * from Stores;

select 
	P.product_name, P.category 
from Products P 
where P.product_id in (
	select product_id from Transactions group by product_id having count(distinct store_id)>1)
order by P.product_name;


-- Problem 15: Customer Spending Percentiles (Normal)
	-- Problem: Your AI model needs to segment customers by spending for targeted marketing. 
    -- Write a SQL query to assign percentiles to customers based on their total transaction amount, using a window function. 
    -- Join the Customers and Transactions tables, and display the 	
			-- name, email, total_amount (rounded to 2 decimal places), and percentile rank (0 to 1 scale). 
    -- Sort by percentile_rank descending.

select 
	C.name, C.email, round(sum(T.amount), 2) as total_amount,
    percent_rank() over (order by sum(T.amount)) as percentage_rank
from Customers C 
join Transactions T on 
	C.customer_id = T.customer_id 
group by C.name, C.email
order by percentage_rank desc;


-- Problem 16: Customers with Recent Transactions (Easy)
	-- Problem: Your AI model needs to identify recently active customers for engagement campaigns. 
    -- Write a SQL query to find customers who made transactions after July 1, 2023, using a subquery. 
    -- Display the name and email from the Customers table. Sort by name ascending.
select name, email from Customers where customer_id in (
select customer_id from Transactions where transaction_date > '2023-07-01');

-- Problem 17: Products with High Quantity Sales (Easy)
	-- Problem: You’re preparing data for an AI inventory model. 
    -- Write a SQL query to find products with at least one transaction where the quantity sold is greater than 2, using a subquery. 
    -- Display the product_name and category from the Products table. Sort by product_name ascending.
select product_name, category from Products where product_id in (
select product_id from Transactions where quantity > 2
);

-- Problem 18: Top Customer by Transaction Count (Normal)
	-- Problem: Your AI model needs to reward the most active customers. 
    -- Write a SQL query to find the customer with the highest number of transactions, using a subquery to determine the maximum count. 
    -- Join the Customers and Transactions tables, and display the name, email, and transaction_count. If there’s a tie, show all top customers.

select 
	C.name, C.email, count(T.transaction_id) as trans_count 
from Customers C 
	join Transactions T on 
		C.customer_id = T.customer_id 
	
	group by C.customer_id, C.name, C.email
    having count(T.transaction_id) = (select max(tot_trans) from (select count(transaction_id) as tot_trans from Transactions group by customer_id) sub)
    order by C.name asc;
    
-- Problem 19: Store Sales Ranking (Normal)
	-- Problem: Your AI model needs to rank stores by total sales for performance analysis. 
    -- Write a SQL query to rank stores by total transaction amount, using a window function. 
    -- Join the Stores and Transactions tables, and display the store_name, city, total_amount (rounded to 2 decimal places), and rank. 
    -- Sort by rank ascending, then store_name ascending.
select * from Stores;
select * from Transactions;

select 
	s.store_name, s.city, round(sum(t.amount), 2) as total_amount,
    rank() over (order by round(sum(t.amount), 2) desc) as amount_rank
from Stores s 
	join Transactions t on 
		s.store_id = t.store_id 
group by s.store_name, s.city
order by amount_rank asc, s.store_name asc;

-- Problem 20: Customers with Above-Average Transaction Counts (Normal)
	-- Problem: Your AI model needs to identify highly active customers for segmentation. 
    -- Write a SQL query to find customers whose number of transactions exceeds the average 
    -- transaction count across all customers with transactions, using a subquery. 
    -- Join the Customers and Transactions tables, and display the name, email, and transaction_count. 
    -- Sort by transaction_count descending, then name ascending.
select * from Customers;
select * from Transactions;

select 
	c.name, c.email, count(t.transaction_id) as trans_count 
from Customers c 
	join Transactions t on 
		c.customer_id = t.customer_id 
	group by c.customer_id, c.name, c.email
	having count(t.transaction_id) > (select avg(trans_count) from (select count(transaction_id) as trans_count from Transactions group by customer_id) sub)
    order by trans_count desc, c.name asc;