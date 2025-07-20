--INFORMATION SCHEMA  -- META DATA
SELECT *
FROM INFORMATION_SCHEMA.TABLES

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS

--SUBQUERY
--RESULT TYPE
--1. SCALAR TYPE SUBQUERY--RETURNS A SINGLE ROW AND COL
--2. ROW TYPE SUBQUERY--RETURNS MULTIPLE ROWS AND SINGLE COL
--3. TABLE TYPE SUBQUERY--RETURNS MULTIPLE ROWS AND COLS

--LOCATION
--FROM --USED AS A TEMP TABLE IN THE MAIN QUERY
--FIND THE PRODUCTS THAT HAVE A PRICE HIGHER THAN THE AVERAGE PRICE OF ALL PRODUCTS
SELECT * FROM Sales.Products
SELECT *
FROM(
	SELECT
		ProductID,
		Price,
		AVG(Price) OVER() AS avg_price
	FROM Sales.Products
)t
WHERE Price > avg_price

--RANK CUSTOMERS BASED ON TOTAL AMOUNT OF SALES
SELECT * FROM Sales.Orders

SELECT
	*,
	RANK() OVER(ORDER BY sum_sales DESC) as rank_cust
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) as sum_sales
	FROM Sales.Orders
	GROUP BY CustomerID
)t

--SELECT CLAUSE
--SHOW THE PRODUCT IDS, NAMES, PRICES, AND TOTAL NUMBER OF ORDERS
SELECT * FROM Sales.Products
SELECT * FROM Sales.Orders
SELECT
	ProductID,
	Product,
	Price,
	(SELECT COUNT(OrderID) FROM Sales.Orders) AS total_orders
FROM Sales.Products


--JOIN SUBQUERY
--SHOW DETAILS OF ALL CUSTOMERS, AND FIND TOTAL ORDERS FOR EACH CUSTOMER
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT *
FROM Sales.Customers AS c
FULL JOIN (
    SELECT 
        CustomerID, 
        OrderID, 
        COUNT(CustomerID) OVER(PARTITION BY CustomerID) AS total_orders
    FROM Sales.Orders
) AS o
ON c.CustomerID = o.CustomerID
ORDER BY o.CustomerID;

--WHERE
--find the products that have a price higher than the average price of all products
SELECT * FROM Sales.Products

SELECT 
	ProductID,
	Price
FROM Sales.Products
WHERE Price > (SELECT 
					AVG(Price) as avg_price
				FROM Sales.Products)

-- LOGICAL OPS
--IN
--SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN GERMANY
SELECT * FROM Sales.Orders
SELECT * FROM Sales.Customers

SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
	SELECT 
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany'
	)

SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (
	SELECT 
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany'
	)

--ANY
--FIND FEMALE EMPLOYEES WHOSE SALARIES ARE GREATER THAN SALARIES OF ANY MALE EMPLOYEES
SELECT * FROM Sales.Employees
SELECT
	*
FROM Sales.Employees
WHERE Gender = 'F' AND SALARY > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

--ALL
----FIND FEMALE EMPLOYEES WHOSE SALARIES ARE GREATER THAN SALARIES OF ANY MALE EMPLOYEES
SELECT
	*
FROM Sales.Employees
WHERE Gender = 'F' AND SALARY > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')


--DEPENDENCY
--SHOW ALL CUSTOMER DETAILS AND FIND THE TOTAL ORDERS OF EACH CUSTOMER
SELECT *
FROM Sales.Customers AS C
FULL JOIN (
	SELECT
		CustomerID,
		COUNT(OrderID) AS total_orders
		FROM Sales.Orders
		GROUP BY CustomerID) AS O
ON C.CustomerID = O.CustomerID

SELECT *,
	(SELECT COUNT(OrderID) FROM Sales.Orders AS o WHERE o.CustomerID = c.CustomerID) AS total_sales
FROM Sales.Customers AS c




--EXISTS
--CHECKS IF SUBQUERY RETURNS ANY RESULTS
SELECT * FROM Sales.Products

SELECT ProductID, Price
FROM Sales.Products
WHERE Price > (
    SELECT AVG(Price) FROM Sales.Products
);

SELECT 
	p1.ProductID, 
	p1.Price
FROM Sales.Products p1
WHERE Price > (

    SELECT 
	AVG(p2.Price)
	FROM Sales.Products p2
    WHERE p2.Category = p1.Category
);


--SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN GERMANY
SELECT * FROM Sales.Customers
SELECT 
	*
FROM Sales.Orders as o
WHERE EXISTS (SELECT 1
	FROM Sales.Customers as c
	WHERE Country = 'Germany'
	AND c.CustomerID = o.CustomerID)

--Find all products whose price is lower than the maximum price in their category.

SELECT * FROM Sales.Products
SELECT 
	*
FROM Sales.Products as p1
WHERE Price < (SELECT MAX(Price) as price
				FROM Sales.Products as p2
				WHERE p2.Category = p1.Category)

--Find the most expensive product(s) in each category using a correlated subquery.
SELECT *,
	(SELECT MAX(Price)
				FROM Sales.Products AS P2
				WHERE P2.Category = P1.Category)
FROM Sales.Products as P1

SELECT *
FROM Sales.Products as P1
WHERE Price = (SELECT MAX(Price)
				FROM Sales.Products AS P2
				WHERE P2.Category = P1.Category)