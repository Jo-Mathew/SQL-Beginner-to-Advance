--PERFORMANCE OPTIMIZATIONS
--FETCHING DATA
-- TIP 1: SELECT ONLY WHAT YOU NEED
-- TIP 2: AVOID UN-NECESSARY DISTINCT & ORDER BY
-- TIP 3: FOR EXPLORATION, LIMIT THE ROWS -- USE TOP 10/TOP 5

--FILTERING DATA
-- TIP 1: CREATE NON CLUSTERED INDEX ON FREQUENTLY USED COLS IN WHERE CLAUSE
-- TIP 2: AVOID APPLYING FUNCTIONS TO COLS IN WHERE CLAUSE
--(FUNCTIONS ON COLS WILL NOT USE INDEX)
-- TIP 3: AVOID LEADING WILDCARDS AS THEY PREVENT INDEX USAGE
-- TIP 4: USE IN OPERATOR INSTEAD OF MULTIPLE OR


-- TIP 5: UNDERSTAND THE SPEED OF JOIN & USE INNER JOIN WHERE POSSIBLE
--Best Performance
SELECT c.FirstName, o.OrderID FROM Sales. Customers c INNER JOIN Sales. Orders o ON c.CustomerID = o. CustomerID
-- Slightly Slower Performance
SELECT c.FirstName, o.OrderID FROM Sales. Customers c RIGHT JOIN Sales. Orders o ON c. CustomerID = o. CustomerID SELECT c.FirstName, o.Order ID FROM Sales. Customers c LEFT JOIN Sales. Orders o ON c.Customer ID o. CustomerID
--Worst Performance
SELECT c.FirstName, o.OrderID FROM Sales. Customers c OUTER JOIN Sales. Orders o ON c.CustomerID = o. CustomerID


-- Tip 6: Make sure to Index the columns used in the ON clause
SELECT c.FirstName, o.OrderID
FROM Sales. Orders o
INNER JOIN Sales. Customers c
ON c.CustomerID = o. CustomerID

--Tip 7: Filter Before Joining (Big Tables)
--Filter After Join (WHERE) 
SELECT c.FirstName, o.OrderID FROM Sales. Customers c
INNER JOIN Sales. Orders o
ON c.CustomerID = o. CustomerID WHERE o.OrderStatus = 'Delivered'

--Filter During Join (ON) 
SELECT c.FirstName, o.OrderID FROM Sales. Customers c
INNER JOIN Sales. Orders o
ON c.CustomerID= o. CustomerID
AND o.OrderStatus = 'Delivered'

--Filter Before Join (SUBQUERY)
SELECT c.FirstName, o.OrderID
FROM Sales. Customers c
INNER JOIN (SELECT OrderID, CustomerID FROM Sales. Orders WHERE OrderStatus = 'Delivered') o
ON c.CustomerID = o.CustomerID


-- Tip 8: Aggregate Before Joining (Big Tables)
--Best practice for small/medium tables
-- Grouping and Joining
SELECT c.CustomerID, c.FirstName, COUNT (o.OrderID) AS OrderCount
FROM Sales. Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o. CustomerID
GROUP BY c.CustomerID, c.FirstName

--Best practice for big tables
--Pre-aggregated Subquery
SELECT c.CustomerID, c.FirstName, o.OrderCount 
FROM Sales. Customers c
INNER JOIN (
SELECT CustomerID, COUNT (OrderID) AS OrderCount 
FROM Sales. Orders
GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID

--Bad Practices
-- Correlated Subquery
SELECT
c. CustomerID,
c. FirstName,
(SELECT COUNT(o.OrderID)
FROM Sales.Orders o
WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c

-- Tip 9: Use Union Instead of OR in Joins

--Bad practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OR c.CustomerID = o.SalesPersonID

--Good practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
UNION ALL
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.SalesPersonID

-- Tip 10: Check for Nested Loops and Use SQL HINTS
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

--GOOD PRACTICE
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN)

--AGGREGIATING THE DATA

-- Tip 1: Use Columnstore Index for Aggregations on Large Table
SELECT CustomerID, COUNT(OrderID) AS OrderCount
INTO Sales.Orders_S
FROM Sales.Orders
GROUP BY CustomerID
CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Order_S

--Tip 2: Pre-Aggregate Data and store it in new Table for Reporting
SELECT MONTH(OrderDate) OrderYear, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

--SUBQUERIES
-- JOIN (BEST PRACTICE IF THE PERFORMANCE EQUALS EXISTS)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- EXISTS (USE IT FOR LARGE TABLES)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
SELECT 1
FROM Sales.Customers c
WHERE c.CustomerID = o.CustomerID
AND c.Country = 'USA'
)

-- IN (BAD PRACTICE LARGE DATASETS)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE o.CustomerID IN (
SELECT CustomerID
FROM Sales.Customers
WHERE Country = 'USA'
)


--CREATING TABLES(DDL)

CREATE TABLE CustomersInfo (
    CustomerID INT PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    TotalPurchases FLOAT,
    Score INT,
    BirthDate DATE,
    EmployeeID INT,
    CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
    REFERENCES Sales.Employees(EmployeeID)
)

--CREATE NONCLUSTERED INDEX FOR FREQUENTLY USED FOREIGN KEYS
CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID
ON CustomersInfo(EmployeeID)


--INDEXING
/*
#1 TIP: Avoid Over Indexing

#2 TIP: Drop unused Indexes

#3 TIP: Update Statistics (Weekly)

#4 TIP: Reorganize & Rebuild Indexes (Weekly)
*/