CREATE VIEW Monthly_Summary AS ( -- here the schema is not written so by defualt it would be dbo
	SELECT 
		MONTH(OrderDate) AS Month_date,
		SUM(Sales) as Total_Sales,
		COUNT(OrderID) AS Total_Orders,
		SUM(Quantity) as total_quantites
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)

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
--calling the view
--SELECT * FROM Monthly_Summary