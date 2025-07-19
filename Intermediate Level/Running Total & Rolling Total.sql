--Find duplicates based on one column
SELECT Sales FROM Sales.Orders
SELECT Sales, COUNT(*)
FROM Sales.Orders
GROUP BY Sales
HAVING COUNT(*) > 1


--calculate the moving average of sales for each product over time
--over time analysis means sorting date in asc order
USE SalesDB

SELECT 
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS NormalAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingAvg
FROM Sales.Orders

--calculate the moving average of sales for each product over time, including only the next order
SELECT 
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS NormalAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAvg
FROM Sales.Orders

--RANK WINDOW FUNCTIONS (INTEGER BASED)
--ROW_NUMBER() --ASSIGNS A UNIQUE ROW VALUE
--RANK THE ORDERS BASED ON THEIR SALES FROM HIGH TO LOW
--doesnt handle ties, rows having same number gives unique number only even of same number
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as roworders
FROM Sales.Orders

--RANK() --Handle ties and give same rank to same numbers
--but can skip certain ranks (1,2,2,4)

SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as roworders,
	RANK() OVER(ORDER BY Sales DESC) as rankorders
FROM Sales.Orders

--DENSE_RANK()
--SAME AS RANK() BUT IT HANDLES GAPS (1,2,3,4)
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) as roworders,
	RANK() OVER(ORDER BY Sales DESC) as rankorders,
	DENSE_RANK() OVER(ORDER BY Sales DESC) as rankdenseorders
FROM Sales.Orders

--TOP N ANALYSIS
--FIND THE TOP HIGHEST SALES FOR EACH PRODUCT

SELECT 
	Sales,
	ProductID,
	highest
FROM(
SELECT
	Sales,
	ProductID,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) as highest
FROM Sales.Orders
)t
WHERE highest = 1

--FIND THE LOWEST 2 CUSTOMERS BASED ON THEIR SCORES

SELECT 
	FirstName, LastName,
	Score, lowest
FROM(
SELECT 
	FirstName, LastName,
	Score,
	ROW_NUMBER() OVER(ORDER BY Score ASC) as lowest
FROM Sales.Customers
)t
WHERE lowest BETWEEN 1 AND 2


--FIND THE LOWEST 2 CUSTOMERS BASED ON THEIR SALES
SELECT * FROM Sales.Orders

SELECT
	CustomerID,
	sumsales, rowno
FROM(
SELECT
	CustomerID,
	SUM(Sales) sumsales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS rowno
FROM Sales.Orders
GROUP BY CustomerID
)t
WHERE rowno <= 2

--ASSING UNIQUE IDS TO THE ROWS OF ORDER ARCHIVE TABLE
SELECT 
	*,
	ROW_NUMBER() OVER(ORDER BY OrderID) Unique_IDs
FROM Sales.OrdersArchive

--IDENTIFY DUPLICATE ROWS IN ORDERS ARCHIVE AND RETURN A CLEAN RESULT WITHOUT DUPLICATES

SELECT * FROM (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
        *
    FROM Sales.OrdersArchive
) t WHERE rn > 1
  

--NTILE()
SELECT
	Sales,
	NTILE(1) OVER(ORDER BY OrderID) onebucket,
	NTILE(2) OVER(ORDER BY OrderID) twobucket,
	NTILE(3) OVER(ORDER BY OrderID) threebucket,
	NTILE(4) OVER(ORDER BY OrderID) fourbucket,
	NTILE(5) OVER(ORDER BY OrderID) fivebucket
FROM Sales.Orders

--DATA SEGMENTATION
--SEGMENT ALL ORDERS INTO 3 CATEGORIES: HIGH, MEDUIM, LOW SALES

SELECT
	*,
	CASE 
		WHEN buckets = 1 THEN 'HIGH'
		WHEN buckets = 2 THEN 'MEDIUM'
		ELSE 'LOW'
	END AS sales_categories
FROM(
SELECT 
	Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) as buckets
FROM Sales.Orders
)t

--EQUALIZING LOAD
--in order to load the data divide orders into 2
SELECT 
	*,
	NTILE(2) OVER(ORDER BY OrderID) AS buckets
FROM Sales.Orders


--PERCENTAGE BASED RANK FUNCTIONS
--CUME_DIST()

--FIND THE PRODUCTS THAT FALL IN THE HIGHEST 40% OF SALES - Keep only rows where CUME_DIST ≤ 0.4 (because that's the highest 40%)
SELECT * FROM Sales.Products

SELECT 
	*
FROM(
SELECT
	ProductID,
	Product,
	Price,
	CUME_DIST() OVER (ORDER BY Price) AS cume
FROM Sales.Products
)t
WHERE cume<=0.4


--NOTE:
/* If you use ORDER BY Price ASC, then:
Cheapest product (Bottle) has lowest Price, gets lowest CUME_DIST() = 0.2
Most expensive gets 1.0

If you use ORDER BY Price DESC, then:
Most expensive gets lowest CUME_DIST = 0.2
Cheapest gets 1.0
*/
-- Ascending
SELECT Product, Price, 
       CUME_DIST() OVER (ORDER BY Price ASC) AS cume_asc
FROM Sales.Products;

-- Descending
SELECT Product, Price, 
       CUME_DIST() OVER (ORDER BY Price DESC) AS cume_desc
FROM Sales.Products;


--PERCENT_RANK()
/*
| Function         | Means...                                          | Starts at |
| ---------------- | ------------------------------------------------- | --------- |
| `CUME_DIST()`    | "How many rows are **less than or equal** to me?" | > 0       |
| `PERCENT_RANK()` | "How many rows are **less than** me?"             | 0         |

*/
SELECT 
	*
FROM(
SELECT
	ProductID,
	Product,
	Price,
	PERCENT_RANK() OVER (ORDER BY Price DESC) AS cume
FROM Sales.Products
)t
WHERE cume<=0.4


--WINDOW_VALUE FUNCTION
--LEAD() & LAG()
--Analyse the month over month (mom) performance by finding the percentage change in sales
--between current and previous month
SELECT *,
  CurrentSales - PreviousSales AS MoM_Change,
  ROUND(
    CAST((CurrentSales - PreviousSales) AS FLOAT) 
    / PreviousSales * 100, 1
  ) AS MoM_Perc
FROM (SELECT 
	MONTH(OrderDate) AS Months,
	SUM(Sales) AS CurrentSales,
	LAG(SUM(Sales), 1, NULL) OVER(ORDER BY MONTH(OrderDate)) AS PreviousSales
FROM Sales.Orders 
GROUP BY MONTH(OrderDate) 
)t

--Analyse customer loyalty by ranking customers based on average number of days between orders

SELECT * FROM Sales.Orders

SELECT
    *,
    DATEDIFF(DAY, diff_days, OrderDate) AS diff,             -- Difference in days between two orders
    AVG(DATEDIFF(DAY, diff_days, OrderDate)) OVER(PARTITION BY CustomerID) AS avg_diff  -- Average difference (over all customers)
FROM (
    SELECT
        CustomerID,
        OrderDate,
        SUM(Sales) OVER(PARTITION BY CustomerID) AS total_sales,
        LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS diff_days
    FROM Sales.Orders
) t;

--Find the highest and lowest sales for each product
SELECT 
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS highest,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest
FROM Sales.Orders

