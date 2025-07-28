--UNIQUE INDEX - NO DUPLICATES
USE SalesDB

SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Category
ON Sales.Products (Category)

-- this query will no work as it already has duplicates, and this makes sure that no duplicates are added

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)


--now if insert a duplicate it will not accept
INSERT INTO Sales.Products(ProductID, Product)
VALUES (106, 'Tire')

--FILTERED INDEX
SELECT * FROM Sales.Customers

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'

SELECT * FROM Sales.Customers WHERE Country = 'USA' --THIS IS GOING TO USE THAT INDEX
