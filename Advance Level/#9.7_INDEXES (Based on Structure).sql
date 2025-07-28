--INDEXES
--BASED ON STRUCTURE - A. CLUSTERED AND B. NONCLUTERED
--LETS CREATE A CUSTOMERS TABLE FROM ALREADY EXISTING CUSTOMERS
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID -- ONLY ONE CLUSTERED INDEX IS POSSIBLE FOR A TABLE
ON Sales.DBCustomers (CustomerID)

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown'

CREATE INDEX idx_DBCustomers_LastName 
ON Sales.DBCustomers (LastName)

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown'

CREATE INDEX idx_DBCustomers_FirstName 
ON Sales.DBCustomers (FirstName)

--COMPOSITE INDEX - USING MULTIPLE COLS FOR INDEX
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score>200

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score) --Country should come first becos in the where clause country is specified first

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score>200

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA'

SELECT *
FROM Sales.DBCustomers
WHERE Score>200 --- this will not use index and index is only used on left column
