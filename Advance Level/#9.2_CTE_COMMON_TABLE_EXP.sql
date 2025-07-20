--CTE
--VIRTUAL TABLE (LIKE A FUNCTION IN PROGRAMMING) - USED FOR REDUCING REDUNDNACY
--TYPE - 1. NON RECURSIVE CTE
-- SUBTYPE A. STANDALONE CTE

-- STEP 1: FIND THE TOTAL SALES PER CUSTOMER
-- STEP 2: FIND THE LAST ORDER DATE FOR EACH CUSTOMER
-- STEP 3: RANK CUSTOMERS BASED ON TOTAL SALES PER CUSTOMER
-- STEP 4: SEGMENT THE CUSTOMERS BASED ON THEIR TOTAL SALES
WITH CTE_Total_Sales AS 
(
SELECT
	CustomerID,
	SUM(Sales) as total_sales
FROM SALES.Orders
GROUP BY CustomerID
)
, CTE_LAST_ORDER AS
(
SELECT 
	CustomerID,
	MAX(OrderDate) AS max_date
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_RANK_CUST AS
(
SELECT
	CustomerID,
	total_sales,
	RANK() OVER(ORDER BY total_sales DESC) AS rank_cust
FROM CTE_Total_Sales
)

, CTE_SEGMENT_CUST AS (
    SELECT *,
           CASE 
               WHEN buckets = 1 THEN 'High'
               WHEN buckets = 2 THEN 'Medium'
               ELSE 'Low'
           END AS segment
    FROM (
        SELECT 
            CustomerID,
            total_sales,
            NTILE(3) OVER (ORDER BY total_sales DESC) AS buckets
        FROM CTE_Total_Sales
    ) AS sub
)


--MAIN QUERY
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.total_sales,
	max_date,
	rank_cust,
	segment
FROM Sales.Customers as c
FULL JOIN
CTE_Total_Sales AS cts
ON c.CustomerID = cts.CustomerID
FULL JOIN
CTE_LAST_ORDER AS cto
ON c.CustomerID = cto.CustomerID
FULL JOIN
CTE_RANK_CUST AS crc
ON c.CustomerID = crc.CustomerID
FULL JOIN
CTE_SEGMENT_CUST AS csc
ON c.CustomerID = csc.CustomerID



/*
--Get the average price per category, 
--and then find only those categories where the average price is more than 20.

WITH CTE_AVG_PRICE AS
(
SELECT
	Category,
	AVG(Price) as avg_price
FROM Sales.Products
GROUP BY Category
)
SELECT
	*,
	avg_price
FROM CTE_AVG_PRICE
WHERE avg_price>20

*/

--RECURSIVE CTE
--GENERATIVE A SEQUENCE OF NUMBERS FROM 1 TO 20
WITH cte_seq AS
(
SELECT 1 AS mynumber

UNION ALL

SELECT mynumber + 1
FROM cte_seq
WHERE mynumber<200
)

SELECT
*
FROM cte_seq
OPTION(MAXRECURSION 1000) --DEFAULT IS 100 SO IF WE ADD THIS IT COULD GO MORE


WITH CTE_Emp_Hierarchy AS (
    -- 🧱 Base case: Start with top-level employees (no manager)
    SELECT 
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- 🔁 Recursive case: Find direct reports
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees e
    INNER JOIN CTE_Emp_Hierarchy ceh
        ON e.ManagerID = ceh.EmployeeID
)

-- ✅ Final output: show all employees with their level in the hierarchy
SELECT * 
FROM CTE_Emp_Hierarchy;
