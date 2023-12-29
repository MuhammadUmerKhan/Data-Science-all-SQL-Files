-- ------------------------------------------------------------ Easy -------------------------------------------------------------------------------

-- Who is the senior most employee based on job title?

-- SELECT * FROM employee ORDER BY levels desc limit 1



-- Which country have the most invoices?

-- SELECT COUNT(*) as MOST_INVOICES_COUNTRY, billing_country FROM invoice GROUP BY billing_country ORDER BY MOST_INVOICES_COUNTRY DESC



--  What are top 3 values of total invoices?

-- SELECT total FROM invoice ORDER BY total desc limit 3



--  Which city has the bect customer? We would like to thorw a  promotional Music festival in the city we made the most money. -->
--  Write a query that returns one city that has the highest  sum of invoices. Retun both city name & sum of all invoices.

-- SELECT SUM(total) as HIGHEST_CITY_INVOICE, billing_city FROM invoice GROUP BY billing_city order by HIGHEST_CITY_INVOICE desc limit 1



-- Who is the bect customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.

-- SELECT customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) as CUSTOMER_SPEND_MOST_MONEY
-- from customer 
-- JOIN invoice ON customer.customer_id = invoice.customer_id
-- GROUP BY customer.customer_id
-- ORDER BY CUSTOMER_SPEND_MOST_MONEY DESC
-- LIMIT 1	


-- --------------------------------------------------------- Moderate ---------------------------------------------------------------------

-- Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A

-- SELECT DISTINCT email,first_name,last_name FROM customer
-- JOIN invoice ON customer.customer_id = invoice.customer_id
-- JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
-- WHERE track_id IN(
-- 	SELECT track_id FROM track 
-- 	JOIN genre ON track.genre_id = genre.genre_id
-- 	WHERE genre.name LIKE 'Rock'
-- )
-- ORDER BY emaiL;

-- select distinct email,first_name,last_name from customer
-- join invoice on customer.customer_id = invoice.customer_id
-- join invoice_line on invoice.invoice_id = invoice_line.invoice_id
-- where track_id in (
-- 	select track_id from track
-- 	join genre on track.genre_id = genre.genre_id
-- 	where genre.name like 'Rock'
-- )order by email;

-- Q2: Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

-- SELECT artist.artist_id,artist.name,COUNT(artist.artist_id) AS number_of_songs FROM track	 
-- JOIN album ON album.album_id = track.album_id
-- JOIN artist ON artist.artist_id = album.artist_id
-- JOIN genre ON genre.genre_id = track.genre_id
-- WHERE genre.name LIKE 'Rock'
-- group by artist.artist_id
-- ORDER BY number_of_songs DESC
-- LIMIT 10;

-- select artist.artist_id,artist.artist_name, count(artist.artist_id) as number_of_songs from track
-- join album on album.album_id = track.album_id
-- join artist on artist.artist_id = 	album.artist_id
-- join genre on genre.genre_id = track.genre_id
-- where genre.name like 'Rock'
-- order by number_of_songs desc
-- limit 10;

-- Q3: Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

-- SELECT name,milliseconds FROM track
-- WHERE milliseconds > (
-- 	SELECT AVG(milliseconds) AS avg_track_length
-- 	FROM track )
-- ORDER BY milliseconds DESC;

-- select name,milliseconds from track where milliseconds >(
-- select avg(milliseconds) as avg_track from track
-- )order by milliseconds desc;
-- --------------------------------------------------------- Advance ---------------------------------------------------------------------

--Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

-- WITH best_selling_artist AS (
-- 	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
-- 	FROM invoice_line
-- 	JOIN track ON track.track_id = invoice_line.track_id
-- 	JOIN album ON album.album_id = track.album_id
-- 	JOIN artist ON artist.artist_id = album.artist_id
-- 	GROUP BY 1
-- 	ORDER BY 3 DESC
-- 	LIMIT 1
-- )
-- SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
-- FROM invoice i
-- JOIN customer c ON c.customer_id = i.customer_id
-- JOIN invoice_line il ON il.invoice_id = i.invoice_id
-- JOIN track t ON t.track_id = il.track_id
-- JOIN album alb ON alb.album_id = t.album_id
-- JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
-- GROUP BY 1,2,3,4
-- ORDER BY 5 DESC;

-- Q2 We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.


-- create view myView as
-- select employee_id,last_name,first_name,title,city,state from employee;
-- drop view myView;
-- select * from myView


