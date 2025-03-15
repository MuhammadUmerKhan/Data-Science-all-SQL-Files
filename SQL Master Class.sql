-- ---------------------- SELECT CLAUSE ----------------------
select 
	first_name, last_name, points,
	(points + 10) * 100  as discount_factor
from customers;

select distinct(state) from customers;

-- Exercise
-- Return all the products name, unit price, new price (unit price * 1.1)
select * from products;
select name as 'Product Name', unit_price as 'Unit Price', (unit_price * 1.1) as 'New Price' from products;

-- ---------------------- WHERE CLAUSE ----------------------
select * from customers where points >= 3000;
select * from customers where points <= 3000;
select * from customers where state = 'VA';
select * from customers where state <> 'VA';
-- OR
select * from customers where state != 'VA';

-- Exercise: Get the orders placed this year
select * from orders where shipped_date >= '2025-01-01'; 

-- ---------------------- The END, OR and NOT operators ----------------------
select * from customers where birth_date >= '1990-01-01' and points > 1000; 
select * from customers where birth_date >= '1990-01-01' or points > 1000 or state = 'VA'; 
select * from customers where not(birth_date >= '1990-01-01' or points > 1000); 

-- Exercise: From the order_item table, get the items for order #6 where total price is greater than 30
select * from order_items where order_id = 6 and unit_price * quantity > 30;

-- ---------------------- The IN Operator -- ----------------------
select * from customers where state in ('VA', 'GA', 'FL');
select * from customers where state not in ('VA', 'GA', 'FL');

-- Exercise: Return the products with quantity in stock equal to 49, 38, 72
select * from products where quantity_in_stock in (49, 38, 72);

-- ---------------------- The Between Operator -- ----------------------
select * from customers where points between 1000 and 3000;

-- Exercise Return Customer born between 1/1/1900 and 1/1/2000
select * from customers where birth_date between '1900-01-01' and '2000-01-01';

-- ---------------------- The LIKE Operator -- ----------------------
select * from customers where last_name like 'b%'; -- last name start with "b"
select * from customers where last_name like '%b%';
select * from customers where last_name like '_____y'; -- name should be six characters long and should be end with 'y'

-- Exercise: Get the customers whose address contain TRAIL or AVENUE phone numbers end with 9
select * from customers;
select * from customers where (address like '%trail%' or address like '%avenue%');
select * from customers where phone like '%9';

-- ---------------------- The REGEXP Operator -- ----------------------
select * from customers where last_name regexp 'field'; -- or select * from customers where last_name like '%field%';
select * from customers where last_name regexp 'field|mac'; -- | logical or
select * from customers where last_name regexp '^field'; -- ^ beginning with 'feild'
select * from customers where last_name regexp 'field$'; -- $ end with 'feild'
select * from customers where last_name regexp 'field';
select * from customers where last_name regexp '[gfi]e'; -- ge, fe, ie

-- Exercise: Get the customers whose:
			-- first name are ELIKA or AMBUR
            -- last name ends with EY or ON
            -- last name start with MY or contain SE
            -- last name contain B followed by R or U
select * from customers where first_name regexp 'elka|ambur';
select * from customers where last_name regexp 'ey$|on$';
select * from customers where last_name regexp '^my|se';
select * from customers where last_name regexp 'b[ru]';

-- ---------------------- The IS NULL Operator -- ----------------------
select * from customers where phone is not null;

-- Exercise: Get the orders that are not shipped
select * from orders where shipper_id is null;

-- ---------------------- The ORDER BY Clause -- ----------------------
select * from customers order by first_name;
select * from customers order by first_name desc;
select first_name, last_name, 10 as points from customers order by points, first_name;

-- Exercise: Database(sql_store) find query by seing at result
select * from order_items where order_id = 2 order by quantity * unit_price desc; 
select *, quantity * unit_price as total_price from order_items where order_id = 2 order by total_price desc; 

-- ---------------------- The LIMIT Clause -- ----------------------
select * from customers limit 3;
select * from customers limit 6, 3; -- skip first 6 records and fetch 3 after that skipping records

-- Ecercise: Get the Top three loyal customers
select * from customers order by points desc limit 3;

-- ---------------------- JOINS -- ----------------------
-- -------------------- INNER JOIN ----------------------
select order_id, od.customer_id, first_name, last_name from orders as od
	join customers as ct on od.customer_id = ct.customer_id;

-- Exercise:
select * from order_items as o join products p on o.product_id = p.product_id;

-- -------------------- JOINS ACCROSS MULTIPLE TABLES
select * from sql_store.order_items as o join sql_inventory.products as sp on o.product_id = sp.product_id;

-- -------------------- SELF JOINS -- --------------------
select * from employees e join employees m on e.reports_to = m.employee_id;
select e.employee_id as 'Employee ID', 
		e.first_name as 'First Name', m.first_name as 'Manager Name' 
        from employees e 
        join employees m on e.reports_to = m.employee_id;

-- -- -------------------- Join Multiple Tables -- --------------------
select order_id, c.first_name, c.last_name, os.name as status
	from orders as o 
    join customers c on o.customer_id = c.customer_id 
    join order_statuses os on o.status = os.order_status_id;

-- Exercise: 
select 
	p.date, p.invoice_id, p.amount, pm.name as payment_method, c.name
    from payments p 
    join clients c on p.client_id = c.client_id  
    join payment_methods pm on p.payment_method = pm.payment_method_id;

-- -- -------------------- Compund Join Condition -- --------------------
select * from order_items oi 
	join order_item_notes oin
    on oi.order_id = oin.order_Id
    and oi.product_id = oin.product_id;
-- -- -------------------- Outer Join -- -- --------------------
select c.customer_id, c.first_name, o.order_id from customers c left join orders o on c.customer_id = o.customer_id;
select c.customer_id, c.first_name, o.order_id from orders o right join customers c on c.customer_id = o.customer_id;

-- Exercise:
select p.product_id, p.name, o.quantity from products p left join order_items o on p.product_id = o.product_id;

-- -- -------------------- Outer Join Between Multiple Tables-- --------------------
select c.customer_id, c.first_name, o.order_id, sh.name
from customers c 
left join orders o on c.customer_id = o.customer_id
left join shippers sh on o.shipper_id = sh.shipper_id;

-- Exercise:
select o.order_date, o.order_id, c.first_name, sh.name as shipper, os.name as status 
from customers c 
	join orders o on 
		c.customer_id = o.customer_id
	left join shippers sh on 
		o.shipper_id = sh.shipper_id 
	join order_statuses os on 
		o.status = os.order_status_id;

-- -- -------------------- Self Outer Joins -- --------------------
select e.employee_id, e.first_name, m.first_name as manager  from employees e
left join employees m on e.reports_to = m.employee_id;

-- -- -------------------- The USING Clause -- --------------------
select o.order_id, o.order_date, c.first_name, sh.name as status from orders o
join customers c 
	using (customer_id)
left join shippers sh
	using (shipper_id)
join order_statuses os on
	o.status = os.order_status_id;

-- Exercise:
select p.date, c.name, p.amount, pm.name as payment_method from payments p
	join clients c
		using (client_id)
	left join payment_methods pm on
		p.payment_method = pm.payment_method_id;

-- -- -------------------- Natural Joins -- --------------------
select o.order_id, c.first_name from orders o
natural join customers c;
-- -- -------------------- Cross Joins -- --------------------
select c.first_name, p.name from customers c
cross join products p order by c.first_name;

-- Exercise:
select s.name as shipper, p.name
 from shippers s
cross join products p;
-- OR
select s.name as shipper, p.name from shippers s, products p;

-- -- -------------------- UNIONS -- --------------------
select order_id, order_date, 'Active' as status from orders where order_date >= '2019-01-01'
union
select order_id, order_date, 'Archeived' as status from orders where order_date < '2019-01-01';

-- Exercise:
select customer_id, first_name, points, 'BRONZE' as type from customers where points < 2000
union
select customer_id, first_name, points, 'BRONZE' as type from customers where points > 3000
union
select customer_id, first_name, points, 'SILVER' as type from customers where points between 2000 and 3000 order by first_name;

-- -- -------------------- COLUMN ATTRIBUTES -- -------------------- 
-- SINGLE INSERTION
insert into customers (last_name, first_name, birth_date, address, city, state) value ('Smith', 'John', '1990-01-01', 'address', 'FA', 'VA');

-- MULTIPLE INSERTION
select * from shippers;
insert into shippers (name) values ('Shipper1'), ('Shipper2'), ('Shipper3');

-- Exercise:
select * from products;
insert into products (name, quantity_in_stock, unit_price) values ('Brush', 3, 9), ('Shirt', 2, 10), ('Pant',10, 2);

-- Creating Copy of a table
create table order_archeived as select * from orders; 
-- After Truncate table (order_archeived)
select * from order_archeived;
insert into order_archeived
select * from orders where order_date < '2019-01-01';

-- Exercise:
create table invoice_archeived as
select
	i.invoice_id, c.name as client_name, i.number, i.invoice_total, i.payment_total, i.invoice_date, i.payment_date, i.due_date
    from invoices i 
    join clients c using(client_id) 
    where i.payment_date is not null;
select * from invoice_archeived;

-- Update Data
update invoices set payment_total = 10, payment_date = '2019-03-01' where invoice_id = 1;
update invoices set payment_total = invoice_total * 0.5, payment_date = due_date where invoice_id = 3;

-- Exercise: Write a SQL query to give any customers born before 1990 50 extra points
select * from customers;
update customers set points = points + 50 where birth_date < '1990-01-01';

-- Update using sub queries
update invoices
	set payment_total = invoice_total * 0.5, 
    payment_date = due_date 
    where invoice_id = (
			select client_id 
				from clients 
				where name = 'Myworks'
					);

update invoices
	set payment_total = invoice_total * 0.5, 
    payment_date = due_date 
    where invoice_id in (
			select client_id 
				from clients 
				where state in ('CA', 'NY')
					);
-- Exercise
update orders set comments = "Gold Customer"  where customer_id in
(select customer_id from customers where points > 3000);

-- Deleting Rows
delete from invoices where invoice_id = 1;
delete from invoices where client_id = (
select client_id from clients where name = 'Myworks'
);