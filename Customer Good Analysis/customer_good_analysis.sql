use gdb023;
-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates it business in the APAC region.
-- select * from dim_customer;
select distinct(market) from dim_customer where region = 'APAC' and customer = 'Atliq Exclusive';

-- 2. What is the  percentage of unique product increase in 2021 vs. 2020? The
-- final output contains these fields,
-- unique_products_2020
-- unique_products_2021
-- percentage_chg
-- Calculate the count of unique products for each year and the percentage change between 2020 and 2021
SELECT 
    SUM(
        CASE WHEN fiscal_year = 2020 THEN 1
        ELSE 0 END
    ) as unique_products_2020,
    SUM(
        CASE WHEN fiscal_year = 2021 THEN 1
        ELSE 0 END
    ) as unique_products_2021, 
    ROUND(
        (SUM(CASE WHEN fiscal_year = 2021 THEN 1 ELSE 0 END) /
        SUM(CASE WHEN fiscal_year = 2020 THEN 1 ELSE 0 END)) - 1, 2
    ) * 100 as percentage_chg 
FROM 
    (SELECT DISTINCT product_code, fiscal_year FROM fact_sales_monthly) as subq;

-- Provide a report with all the unique product counts for each segment and
-- sort them in descending order of product counts. The final output contains
-- 2 fields,
-- segment
-- product_count
select segment, count(product) as product_count from dim_product group by segment order by product_count desc;

-- 4. Follow-up: Which segment had the most increase in unique products in
-- 2021 vs 2020? The final output contains these fields,
-- segment
-- product_count_2020
-- product_count_2021
-- difference
WITH ProductCounts AS (
    SELECT 
        dp.segment AS Segment, 
        COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2020 THEN dp.product_code END) AS product_count_2020,
        COUNT(DISTINCT CASE WHEN fs.fiscal_year = 2021 THEN dp.product_code END) AS product_count_2021
    FROM 
        dim_product dp
    JOIN 
        fact_sales_monthly fs ON dp.product_code = fs.product_code 
    WHERE 
        fs.fiscal_year IN (2020, 2021)
    GROUP BY 
        dp.segment 
)
SELECT 
    Segment, 
    product_count_2020, 
    product_count_2021, 
    (product_count_2021 - product_count_2020) AS difference
FROM 
    ProductCounts
ORDER BY 
    difference DESC;

SELECT * FROM fact_sales_monthly;
SELECT * FROM dim_product;
-- 5. Get the products that have the highest and lowest manufacturing costs.
-- The final output should contain these fields,
-- product_code
-- product
-- manufacturing_cost
select p.product_code, p.product, round(fact_manufacturing_cost.manufacturing_cost, 2) from dim_product p 
join 
fact_manufacturing_cost on p.product_code = fact_manufacturing_cost.product_code
where fact_manufacturing_cost.manufacturing_cost = (select min(manufacturing_cost) from fact_manufacturing_cost) or 
fact_manufacturing_cost.manufacturing_cost = (select max(manufacturing_cost) from fact_manufacturing_cost)
order by manufacturing_cost desc;
-- 6. Generate a report which contains the top 5 customers who received an
-- average high pre_invoice_discount_pct for the fiscal year 2021 and in the
-- Indian market. The final output contains these fields,
-- customer_code
-- customer
-- average_discount_percentage
select dp.customer, round(avg(id.pre_invoice_discount_pct)*100, 2) as average_discount_percentage, id.customer_code
from dim_customer dp 
join fact_pre_invoice_deductions id on dp.customer_code = id.customer_code
where dp.market = 'India' and id.fiscal_year = '2021' GROUP BY dp.customer, id.customer_code ORDER BY average_discount_percentage DESC LIMIT 5;

-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and
-- high-performing months and take strategic decisions.
-- The final report contains these columns:
-- Month
-- Year
-- Gross sales Amount
SELECT MONTHNAME(fs.date) as Month, YEAR(fs.date) as Year, ROUND(SUM(gp.gross_price * fs.sold_quantity )/1000000,2) as Gross_sales_Amount
FROM fact_sales_monthly fs 
JOIN fact_gross_price gp on gp.fiscal_year = fs.fiscal_year AND fs.product_code = gp.product_code 
JOIN dim_customer d ON d.customer_code = fs.customer_code WHERE d.customer = "Atliq Exclusive" GROUP BY MONTH, YEAR;

-- 8. In which quarter of 2020, got the maximum total_sold_quantity? The final
-- output contains these fields sorted by the total_sold_quantity,
-- Quarter
-- total_sold_quantity
SELECT
    CASE 
        WHEN fs.date BETWEEN '2019-09-01' AND '2019-11-01' THEN 'Q1'
        WHEN fs.date BETWEEN '2019-12-01' AND '2020-02-01' THEN 'Q2'
        WHEN fs.date BETWEEN '2020-03-01' AND '2020-05-01' THEN 'Q3'
        WHEN fs.date BETWEEN '2020-06-01' AND '2020-08-01' THEN 'Q4'
    END as quarter,
    SUM(fs.sold_quantity) as total_sold_quantity 
FROM 
    fact_sales_monthly fs
WHERE 
    fs.fiscal_year = '2020' 
GROUP BY 
    quarter 
ORDER BY 
    quarter;
-- 9. Which channel helped to bring more gross sales in the fiscal year 2021
-- and the percentage of contribution? The final output contains these fields,
-- channel
-- gross_sales_mln
-- percentage
WITH CTE1 AS(
    SELECT dc.channel, ROUND(SUM(gp.gross_price*fs.sold_quantity)/1000000,2) as gross_sales_mln FROM fact_sales_monthly fs
    JOIN fact_gross_price gp ON gp.fiscal_year = fs.fiscal_year AND gp.product_code = fs.product_code
    JOIN dim_customer dc ON dc.customer_code = fs.customer_code WHERE fs.fiscal_year = '2021' GROUP BY dc.channel ORDER BY gross_sales_mln    
    ), CTE2 AS
    (
        SELECT SUM(gross_sales_mln) as total_gross_sales_mln FROM CTE1
    )
SELECT CTE1.*, ROUND((gross_sales_mln*100 / total_gross_sales_mln), 2) as percentage FROM CTE1 JOIN CTE2;

-- 10. Get the Top 3 products in each division that have a high
-- total_sold_quantity in the fiscal_year 2021? The final output contains these
-- fields,
-- division
-- product_code
-- product
-- total_sold_quantity
-- rank_order
WITH CIT1 AS(
    SELECT dp.division AS division, dp.product_code, dp.product,
    SUM(fs.sold_quantity) as total_sold_quantity FROM dim_product dp
    JOIN fact_sales_monthly fs on dp.product_code = fs.product_code WHERE fs.fiscal_year = '2021' 
    GROUP BY dp.division, dp.product_code, dp.product ORDER BY total_sold_quantity DESC LIMIT 1000000
),
CIT2 AS(
    SELECT *, DENSE_RANK() OVER(PARTITION BY Division ORDER BY total_sold_quantity DESC) as rank_order FROM CIT1
)
SELECT * FROM CIT2 WHERE rank_order <=3;
