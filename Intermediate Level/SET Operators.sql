SELECT *
FROM Sales.Customers;

SELECT *
FROM Sales.Employees;

SELECT 
	FirstName, --2cols selected
	LastName
FROM Sales.Customers

UNION

SELECT 
	FirstName, --2cols selected (should be same, datatype and order should be same)
	LastName
FROM Sales.Employees

--UNION SET
-- returns all distinct rows from both queries (no duplicates)
--combine the data from employees and customers into one table
SELECT 
	FirstName, --2cols selected
	LastName
FROM Sales.Customers

UNION

SELECT 
	FirstName, --2cols selected (should be same, datatype and order should be same)
	LastName
FROM Sales.Employees

--UNION ALL
--returns all rows including duplicates
SELECT 
	FirstName, --2cols selected
	LastName
FROM Sales.Customers
UNION ALL
SELECT 
	FirstName, --2cols selected (should be same, datatype and order should be same)
	LastName
FROM Sales.Employees

--EXCEPT SET - returns all distinct rows from 1st query that are not found in 2nd query
--find employees who are not customers at the same time

SELECT 
	FirstName, --2cols selected
	LastName
FROM Sales.Customers
EXCEPT
SELECT 
	FirstName, --2cols selected (should be same, datatype and order should be same)
	LastName
FROM Sales.Employees

--INTERSECT
--returns rows that are common in both
SELECT 
	FirstName, --2cols selected
	LastName
FROM Sales.Customers
INTERSECT
SELECT 
	FirstName, --2cols selected (should be same, datatype and order should be same)
	LastName
FROM Sales.Employees

--orders are store in different tables
--combine all orders into one report excluding duplicates

SELECT	
	'Orders' AS SourceTable	
	  ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT
	   'OrdersArchive' AS SourceTable	
	  ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID