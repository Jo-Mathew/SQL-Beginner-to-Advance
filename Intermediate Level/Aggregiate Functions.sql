--AGGREGIATE FUNCTIONS
--Total number of customers
SELECT
	COUNT(id) AS [COUNT OF CUSTOMERS]
FROM Customers

--FIND THE TOTAL NUMBER OF ORDERS
SELECT
	COUNT(*) AS [COUNT OF ORDERS]
FROM Orders

--FIND THE TOTAL SALES OF ALL ORDERS
SELECT
	SUM(Sales) AS TOTAL_SALES
FROM Orders

--find average sales of all orders
SELECT
	AVG(Sales) AS AVG_SALES
FROM Orders

--highest scores among all customers
SELECT
	customer_id,
	MAX(Sales) AS Highest_Sales,
	MIN(Sales) AS Lowest_Sales
FROM Orders
GROUP BY customer_id