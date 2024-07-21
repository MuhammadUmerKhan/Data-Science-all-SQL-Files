use sales;
SELECT * FROM sales.customers;
SELECT count(*) FROM sales.customers;
select * from sales.transactions where market_code = "Mark001";
select distinct sales.transactions.product_code from sales.transactions where sales.transactions.market_code = "Mark001";
select * from sales.transactions where sales.transactions.currency = "USD";
select transactions.*, date.* from transactions inner join date on transactions.order_date = date.date where date.year = 2020;
select sum(transactions.sales_amount) from transactions inner join date on transactions.order_date = date.date where date.year = 2020 and 
date.month_name = 'January' and transactions.currency="INR\r" or transactions.currency="USD\r";
select sum(transactions.sales_amount) from transactions inner join date on transactions.order_date = date.date where date.year = 2020;	