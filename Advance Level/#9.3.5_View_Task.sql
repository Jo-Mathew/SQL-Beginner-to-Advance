--VIEW TASKS
--PROVIDE A VIEW THAT COMBINES DETAILS FROM ORDERS, PRODUCTS, CUSTOMERS AND EMPLOYEES
CREATE VIEW Sales.ALL_EMP_DETAILS AS
(
SELECT 
	ISNULL(c.CustomerID, o.CustomerID) AS CustomerID,
	ISNULL(c.FirstName, '') + ' ' + ISNULL(c.LastName, '') AS Full_Name,
	c.Country,
	c.Score,
	o.OrderID,
	o.OrderDate,
	o.Sales,
	p.ProductID,
	p.Product,
	p.Category,
	p.Price,
	e.EmployeeID,
	e.Department,
	e.Salary
FROM Sales.Customers AS c
FULL JOIN Sales.Orders AS o
	ON o.CustomerID = c.CustomerID
FULL JOIN Sales.Products AS p
	ON p.ProductID = o.ProductID
FULL JOIN Sales.Employees AS e
	ON e.EmployeeID = c.CustomerID
)

SELECT * FROM Sales.ALL_EMP_DETAILS