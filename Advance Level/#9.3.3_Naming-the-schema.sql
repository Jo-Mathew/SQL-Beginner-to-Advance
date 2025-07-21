--to specify the schema use Sales.
CREATE VIEW Sales.Monthly_Summary AS ( 
	SELECT 
		MONTH(OrderDate) AS Month_date,
		SUM(Sales) as Total_Sales,
		COUNT(OrderID) AS Total_Orders,
		SUM(Quantity) as total_quantites
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)
--after this you need to drop the older view use DROP VIEW Schema name
--CREATE VIEW OR REPLACE - THIS CAN BE DONE IN POSTGRES BUT NOT IN SQL SERVER
--SO FOR IN THIS GO AND DROP AND THEN CREATE IT AGAIN

--OR
--USE THIS
--IF OBJECT_ID('VIEW NAME','V') ISNOT NULL
--	DROP VIEW VIEW NAME