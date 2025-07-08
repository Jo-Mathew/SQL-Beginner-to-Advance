-- CASE STATEMENTS

--Generate a report showing the total sales for each category:
-- HIGH: Sale>50
--Medium: Sale (20 and 50)
--Low: Sale-=<20
--Sort the results from lowest to highest

SELECT * FROM Sales.Orders
SELECT 
	SUM(Sales) AS Sales,
	sales_category
FROM(
SELECT 
	Sales,
	CASE
		WHEN Sales>50 THEN 'HIGH'
		WHEN Sales BETWEEN 20 AND 50 THEN 'MEDIUM'
		WHEN Sales<=20 THEN 'LOW'
	ELSE 'NOT IN RANGE'
	END AS sales_category
FROM Sales.Orders
)t
GROUP BY sales_category
ORDER BY Sales ASC

--Retrive employee details with gender displayed as fulltext
SELECT *,
	CASE 
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Female'
	END AS GENDER_FULL_TEXT
FROM Sales.Employees

--retrive customer details with abbreviated country code
SELECT *,
	CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
	ELSE 'N/A'
	END AS abb_country
FROM Sales.Customers

--QUICK FORM
SELECT *,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
	ELSE 'N/A'
	END AS abb_country
FROM Sales.Customers

--find the avg socres of all customers and treat nulls as 0
--and provide details such as customerid & lastname


SELECT 
	CustomerID,
	LastName,
	Score,
	AVG(ISNULL(Score, 0)) OVER() AS Average_Score_without_null
FROM Sales.Customers

--Count how many times each customer has made an order with sales greater than 30

SELECT
	Sales,
	CustomerID,
	COUNT(CustomerID) AS COUNT_OF_ORDERS
FROM Sales.Orders
WHERE Sales>30
GROUP BY CustomerID

SELECT
    CustomerID,
    COUNT(*) AS Count_Of_Orders,
    SUM(Sales) AS Total_Sales
FROM Sales.Orders
WHERE Sales > 30
GROUP BY CustomerID;

