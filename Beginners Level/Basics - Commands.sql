USE MyDatabase
-- This is a inline comment
/* This
is a 
multiline comment*/

-- Retrive all customer data
SELECT * 
FROM dbo.customers

-- retrive each customers name, country and score
SELECT
	score,
	first_name, 
	country
FROM customers -- order of the columns you need can be changed by writing it in the order you need

-- WHERE CLAUSE is used when you need to filter your data based on a condition

-- retrive customers with a score not equal to 0
SELECT *
FROM customers
WHERE score!=0

-- retrive customers from germany
select * -- works with case sensitive data as well
FROM customers
WHERE country = 'Germany'

-- ORDER BY CLAUSE - Sort your data - asc (lowest to highest) or desc
-- default is ASC

-- retrive all customers and sort the results by the highest score first
SELECT *
FROM customers
ORDER BY score DESC

-- NESTED SORTING
-- retrive all the customers, and sort the results by the country and then by the highest score
SELECT *
FROM customers
ORDER BY country ASC, score DESC
-- important thing to note: here the 1st priority woudd be to country as it is written first then score
-- so it matters which you write first

-- GROUP BY CLAUSE - combines rows with same value, aggregiate your data
-- find the total score for each country
SELECT country, 
	SUM(score) AS Total_score
FROM customers
GROUP BY country
-- note here what ever columns you select to show should either be part of aggregiate or group by
SELECT first_name, country, 
	SUM(score) AS Total_score
FROM customers
GROUP BY country, first_name

-- find the total score and total number of customers for each country
SELECT SUM(score) AS Total_Score,
	COUNT(first_name) AS Total_Customers,
	country
FROM customers
GROUP BY country

-- HAVING CLAUSE - filter data after aggregiated data
-- can be used only with group by
-- Difference between WHERE and HAVING
-- WHERE is executed before HAVING 
-- so where is applied on the original data and having is applied after aggregiating the data

-- Find the average score for each country considering only customers with a score not equal to 0,
-- and return only those countries with an average score greater than 430

SELECT AVG(score) AS Avg_Score,
	country
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score)>430

-- DISTINCT CLAUSE - remove duplicates
SELECT DISTINCT country
FROM customers

-- TOP rows - limit your data - restrict the number of rows returned in result
SELECT TOP 3 first_name, score
FROM customers
ORDER BY score DESC

-- retrive the lowest 2 customers with lowest scores
SELECT TOP 2 *
FROM customers
ORDER BY score ASC

-- get the 2 most recent orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC

--Multiple Queries

SELECT *
FROM customers;

SELECT * 
FROM orders;

--static(fixed) value
SELECT 123 AS Static_int;
SELECT 'ABC' AS Static_string;

SELECT id, first_name, 
	'New Customer' AS Type_Customer
FROM customers