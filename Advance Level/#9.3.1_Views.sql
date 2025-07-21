--Find the running total of sales for each month
WITH CTE_TOTAL AS (
	SELECT 
		MONTH(OrderDate) AS Month_date,
		SUM(Sales) as Total_Sales,
		COUNT(OrderID) AS Total_Orders,
		SUM(Quantity) as total_quantites
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)

SELECT
	Month_date,
	Total_Sales,
	SUM(Total_Sales) OVER(ORDER BY Month_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Running_total
FROM CTE_TOTAL


--Let's create a VIEW for this that can be accessed in other queries as well
