--NULL HANDLING
--ISNULL() - replaces the null value with a specific value
-- Find the average score for customers
SELECT * FROM Sales.Customers;

SELECT
	AVG(Score) AS [average with null],
	AVG(ISNULL(Score, 0)) AS [average without null]
FROM Sales.Customers


--DISPLAY THE FULL NAME OF CUSTOMERS IN A SINGLE FIELD,
--AND ADD 10 BONUS POINTS TO EACH CUSTOMER'S SCORE
SELECT * FROM Sales.Customers;
SELECT 
	FirstName + ' ' + COALESCE(LastName, ' ') AS New_name,
	COALESCE(Score, 0) + 10 AS New_score
FROM Sales.Customers;


--SORT THE CUSTOMERS FROM LOWEST TO HIGHEST SCORES, WITH NULL APPEARING AT LAST
SELECT 
	Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END

--NULLIF() - returns NULL if same, ot else returns the first value
--Find the sales price for each order by dividing the sales by the quantity

SELECT 
	Sales, Quantity,
	Sales/Quantity AS Sales_Price
FROM Sales.Orders  --ERROR: DIVIDED BY ZERO - SOLUTION DOWN

SELECT 
	Sales, Quantity,
	Sales/NULLIF(Quantity, 0) AS Sales_Price
FROM Sales.Orders

--IS NULL | IS NOT NULL
--identify the customers who have no score
SELECT *
FROM Sales.Customers
WHERE Score IS NULL

--identify the customers who have score
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

--list all customers who have not places any orders
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT 
	c.*, o.OrderID
FROM Sales.Customers AS c
LEFT JOIN
Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
