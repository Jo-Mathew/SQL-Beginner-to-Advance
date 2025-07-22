--PERMANENT TABLES:
---CTAS - CREATE TABLE AS SELECT
SELECT 
	DATETRUNC(MONTH, OrderDate) AS month_part,
	COUNT(OrderID) as total_orders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, OrderDate)

SELECT * FROM Sales.MonthlyOrders
DROP TABLE Sales.MonthlyOrders

--To refresh the CTAS
--USE
IF OBJECT_ID Sales.MonthlyOrders IS NOT NULL
	DROP TABLE Sales.MonthlyOrders
GO


--TEMPORARY TABLES
/*
STEP 1: CREATE A TEMP TABLE
STEP 2: MAKE CHANGES
STEP 3: SAVE TO A REAL TABLE USING CTAS
*/
SELECT *
INTO #TEMP_ORDERS
FROM Sales.Orders

SELECT *
INTO Sales.Shipped_Orders
FROM #TEMP_ORDERS
WHERE OrderStatus = 'Shipped'

SELECT *
FROM Sales.Shipped_Orders