--MULTI-TABLE JOIN
--using salesdb retrive a list of all orders, along with related customer, product and employee details
-- for each order display - Order ID, Customer's Name, Product Name, Sales amount, product price, salesperson's name
USE SalesDB

SELECT *
FROM Sales.Orders

SELECT *
FROM Sales.Customers

SELECT *
FROM Sales.Employees

SELECT *
FROM Sales.Products

SELECT 
	o.OrderID,
	c.FirstName AS 'CustomerFN',
	c.LastName AS 'CustomerLN',
	p.Product AS 'ProductName',
	o.Sales,
	p.Price,
	e.FirstName AS 'SalesFN',
	e.LastName AS 'SalesLN'
FROM Sales.Orders AS o
JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
JOIN Sales.Employees AS e
ON e.EmployeeID = o.SalesPersonID
JOIN Sales.Products AS p
ON p.ProductID = o.ProductID


