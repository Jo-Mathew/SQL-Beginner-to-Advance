--Execution Plan
/*
SELECT *
INTO FactResellerSales_HP
FROM FactResellerSales
*/

SELECT *
FROM FactResellerSales

SELECT *
FROM FactResellerSales_HP
--Go to properties and check the no of rows scanned, logical operation, strorage, costs

SELECT *
FROM FactResellerSales
ORDER BY SalesOrderNumber

SELECT *
FROM FactResellerSales_HP
ORDER BY SalesOrderNumber

--check the estimated operator cost
--its high for HP as it has 2 steps


SELECT *
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98'
--GO TO OBJECT IN PROPERTIES AND CHECN WHICH INDEX IT USES

CREATE NONCLUSTERED INDEX idx_FactResellerSales_CTN
ON FactResellerSales (CarrierTrackingNumber)

--here check the rows scaned = 12

SELECT *
FROM FactResellerSales_HP
WHERE CarrierTrackingNumber = '4911-403C-98'
--here check the rows scaned = ALL ROWS

SELECT 
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales s
JOIN DimProduct p 
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

SELECT 
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p 
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSales_HP
ON FactResellerSales_HP


SELECT 
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellerSales_HP s
JOIN DimProduct p 
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

--to save a exceution plan go to execution plan tab and right click to save it
--and then compare it using compare showplan


--SQL HINTS - YOU CAN SPECUFY WHICH JOIN, SCAN, INDEX TO USE

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Customers
SELECT Sales, Country
FROM Sales.Orders as o
LEFT JOIN
Sales.Customers as c --WITH (FORCESEEK)
WITH (INDEX([PK_customers]))
ON o.CustomerID = c.CustomerID
--OPTION(HASH JOIN)