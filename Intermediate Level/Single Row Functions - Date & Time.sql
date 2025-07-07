USE SalesDB

--GETDATE()
SELECT 
	OrderID,
	CreationTime,
	'2025-03-21' Hardcoded,
	GETDATE() Today
FROM Sales.Orders

-- DATE AND TIME FUNCTIONS
-- DAY() - returns a day from a date
-- Month() - returns month from a date
-- Year() - returns a year from a date
SELECT 
	OrderID,
	CreationTime,
	DAY(CreationTime) Day_extracted,
	MONTH(CreationTime) Month_extracted,
	YEAR(CreationTime) Year_extracted
FROM Sales.Orders

--DATEPART() - returns a specific part of a date as a number
SELECT 
	OrderID,
	CreationTime,
	DATEPART(mm, CreationTime) month_dp,
	DATEPART(year, CreationTime) year_dp,
	DATEPART(DAY, CreationTime) day_dp,
	DATEPART(hour, CreationTime) hour_dp,
	DATEPART(MINUTE, CreationTime) minute_dp,
	DATEPART(SECOND, CreationTime) seconds_dp,
	DAY(CreationTime) Day_extracted,
	MONTH(CreationTime) Month_extracted,
	YEAR(CreationTime) Year_extracted
FROM Sales.Orders

--DATENAME() - RETURNS THE NAME OF THE SPECIFIC PART OF THE DATE
SELECT 
	OrderID,
	CreationTime,
	DATENAME(MONTH,CreationTime) AS Month_Name,
	DATENAME(WEEKDAY,CreationTime) AS weekday_Name,
	DATENAME(DAY,CreationTime) AS day_Name -- returns a string date
FROM Sales.Orders

--DATETRUNC() - truncates the date to a specific part - rest would be reset to 0 for time and for date & month - 01
SELECT 
	OrderID,
	CreationTime,
	DATETRUNC(DAY, CreationTime) AS data_trunc,
	DATETRUNC(MINUTE, CreationTime) AS secs_trunc,
	DATENAME(MONTH,CreationTime) AS Month_Name,
	DATENAME(WEEKDAY,CreationTime) AS weekday_Name,
	DATENAME(DAY,CreationTime) AS day_Name 
FROM Sales.Orders

SELECT 
	DATETRUNC(mm, CreationTime) as Months,
	COUNT(*) AS Total_Orders_BY_Month
FROM Sales.Orders
GROUP BY DATETRUNC(mm, CreationTime)

--EOMONTH - returns the last day of the month
SELECT 
	CreationTime,
	EOMONTH(CreationTime) AS end_of_month
FROM Sales.Orders

SELECT 
	CreationTime,
	EOMONTH(CreationTime) AS end_of_month,
	CAST(DATETRUNC(MM, CreationTime) AS DATE) AS start_of_month --used cast to remove the time and to keep only the date
FROM Sales.Orders


------

--How many orders where placed each year
SELECT 
	DATETRUNC(YEAR, CreationTime),
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR, CreationTime)

SELECT 
	YEAR(OrderDate) AS Year_of_sale,
	COUNT(*) AS Count_by_sale
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

SELECT 
	DATENAME(MM, OrderDate) AS Month_of_sale,
	COUNT(*) AS Count_by_sale
FROM Sales.Orders
GROUP BY DATENAME(MM, OrderDate)
ORDER BY DATENAME(MM, OrderDate) ASC

--SHOW ALL THE ORDERS THAT WERE PLACED IN THE MONTH OF FEBRUARY
SELECT
	DATENAME(MM, OrderDate) AS MONTH_NAME,
	COUNT(*) AS TOTAL_ORDERS
FROM Sales.Orders
GROUP BY DATENAME(MM, OrderDate)
HAVING DATENAME(MM, OrderDate) = 'February'

--TO SHOW THE DETAILS NO JUST THE COUNT

SELECT 
	*,
	DATENAME(MM, OrderDate) AS MONTH_NAME
FROM Sales.Orders
WHERE DATENAME(MM, OrderDate) = 'February'

--THIS WORKS BUT SLOW AS COMPARED TO INTEGER
SELECT 
	*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2


--FORMATTING
--FORMAT() - CHANGE HOW A DATA LOOKS LIKE
SELECT 
	OrderID,
	CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_FORMAT,
	FORMAT(CreationTime, 'dd-MM-yyyy') AS EURO_FORMAT,
	FORMAT(CreationTime, 'dd') AS Date_dd,
	FORMAT(CreationTime, 'ddd') AS Date_name,
	FORMAT(CreationTime, 'dddd') AS Date_full_name,
	FORMAT(CreationTime, 'MM') AS month_mm,
	FORMAT(CreationTime, 'MMM') AS month_name,
	FORMAT(CreationTime, 'MMMM') AS month_full_name
FROM Sales.Orders


-- Show CreationTime using the following format:
-- DAY WED JAN Q1 2025 12:34:56 PM
SELECT
	CreationTime,
	FORMAT(CreationTime, 'dd') AS day_dd,
	FORMAT(CreationTime, 'ddd') AS day_name,
	FORMAT(CreationTime, 'MMM') AS month_name,
	'Q' + DATENAME(QUARTER, CreationTime) AS q1_name,
	FORMAT(CreationTime, 'yyyy') AS year_name,
	FORMAT(CreationTime, 'HH:mm:ss tt') AS hour_name
FROM Sales.Orders

SELECT
	CreationTime,
	FORMAT(CreationTime, 'dd') +' '+ FORMAT(CreationTime, 'ddd') 
	+' '+ FORMAT(CreationTime, 'MMM') 
	+' '+ 'Q' + DATENAME(QUARTER, CreationTime) 
	+' '+ FORMAT(CreationTime, 'yyyy') 
	+' '+ FORMAT(CreationTime, 'HH:mm:ss tt') AS CUSTOM_FORMAT
FROM Sales.Orders


--CONVERT() - CHANGE & FORMAT THE DATATYPE
SELECT 
	CONVERT(INT, '123') AS [CHANGE TO INTEGER], --USE [] TO INCLUDE SPACES IN COL NAME
	CONVERT(DATE, CreationTime) AS [DATETIME TO DATE]
FROM Sales.Orders

--CAST()
SELECT 
	CAST('123' AS INT),
	CAST(123 AS VARCHAR),
	CAST('2025-09-21' AS DATE),
	CAST('2025-09-21' AS DATETIME),
	CAST(CreationTime AS DATE)
FROM Sales.Orders


--DATEADD() - add or substract a specific time interval to/from a date
SELECT
	OrderID,
	OrderDate,
	DATEADD(day, -15, OrderDate),
	DATEADD(month, 3, OrderDate),
	DATEADD(year, 2, OrderDate)
FROM Sales.Orders

--DATEDIFF() - difference between 2 dates
SELECT
	OrderID,
	OrderDate,
	DATEADD(day, -15, OrderDate),
	DATEADD(month, 3, OrderDate),
	DATEADD(year, 2, OrderDate),
	DATEDIFF(year, OrderDate, DATEADD(year, 2, OrderDate))
FROM Sales.Orders


--Calculate the age of employees
SELECT * FROM Sales.Employees;
SELECT 
	DATEDIFF(YEAR, BirthDate, GETDATE()) AS AGE_EMPLOYEES
FROM Sales.Employees;

-- FIND AVG SHIPPING DURATION IN DAYS FOR EACH MONTH
SELECT * FROM SALES.Orders;
SELECT 
	DATENAME(MONTH,OrderDate) AS Month_Name,
	AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS Average_Days
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate)
ORDER BY Month_Name DESC

--TIME GAP ANALYSIS
--Find the number of days between each order and previous order
SELECT
	OrderID,
	OrderDate AS CURRENT_DATE_CD,
	LAG(OrderDate) OVER (ORDER BY OrderDate ASC) AS PREVIOUS,
	DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate ASC),OrderDate) AS [NUMBER OF DAYS] 
FROM Sales.Orders

--ISDATE() - checks if value is a date - returns 1 if date is valid
SELECT
	ISDATE('2020-02-23') AS CHECKS
UNION ALL
SELECT
	ISDATE('2020')