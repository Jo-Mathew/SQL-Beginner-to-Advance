USE AdventureWorksDW2022

--HEAP STUCTURE
SELECT * FROM [dbo].[FactInternetSales]

SELECT * 
INTO FactInternetSalesHP
FROM [dbo].[FactInternetSales]

--ROWSTORE
SELECT * 
INTO FactInternetSalesRS
FROM [dbo].[FactInternetSales]

CREATE CLUSTERED INDEX idx_FactInternetSalesRS_PK
ON FactInternetSalesRS (SalesOrderNumber, SalesOrderLineNumber)

--COLUMNSTORE
SELECT * 
INTO FactInternetSalesCS
FROM [dbo].[FactInternetSales]

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSalesCS_PK
ON FactInternetSalesCS 

--now go to each table properties and check the storage
--Storage capabalities
--1. COLUMNSTORE
--2. HEAP STRUCTURE
--3. ROWSTORE