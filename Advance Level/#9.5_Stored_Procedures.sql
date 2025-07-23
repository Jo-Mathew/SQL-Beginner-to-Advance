--STORED PROCEDURES
--STEP 1: WRITE A QUERY
--FOR US CUSTOMERS FIND THE TOTAL NUMBER OF CUSTOMERS AND THE AVERAGE SCORE
SELECT * FROM Sales.Customers

SELECT
  COUNT(CustomerID) as total_customers_usa,
  COUNT(Score) as customers_with_scores,
  AVG(Score) as avg_score
FROM Sales.Customers
WHERE Country = 'USA';

--STEP 2: TURN THE QUERY INTO STORED PROCEDURE
CREATE PROCEDURE get_customer_summary AS
BEGIN
	SELECT
	  COUNT(CustomerID) as total_customers_usa,
	  COUNT(Score) as customers_with_scores,
	  AVG(Score) as avg_score
	FROM Sales.Customers
	WHERE Country = 'USA';
END

--STEP 3: Call the procedure
EXEC get_customer_summary


--USING PARAMETERS

ALTER PROCEDURE get_customer_summary @Country NVARCHAR(20) = 'USA' -- default value
AS
BEGIN
    BEGIN TRY
        DECLARE @total_cust INT, @avg_score FLOAT;

        -- IF ELSE FOR CHECKING NULLS
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('UPDATING THE SCORES OF NULLS:');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('NO NULLS');
        END;

        -- REPORTS
        SELECT
            @total_cust = COUNT(CustomerID),
            @avg_score = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT 'Total Customers in ' + @Country + ' is: ' + CAST(@total_cust AS NVARCHAR(100));
        PRINT 'Average Score of Customers in ' + @Country + ' is: ' + CAST(@avg_score AS NVARCHAR(100));

        -- FIND THE TOTAL ORDERS AND TOTAL SALES BASED ON COUNTRY
        SELECT 
            COUNT(o.OrderID) AS TotalOrders,
            SUM(o.Sales) AS TotalSales,
            1/0 -- Force error to test CATCH block (remove later)
        FROM Sales.Orders AS o
        FULL JOIN Sales.Customers AS c
        ON o.CustomerID = c.CustomerID
        WHERE c.Country = @Country;

    END TRY
    BEGIN CATCH
        PRINT('An error occurred:');
        PRINT('ERROR: ' + ERROR_MESSAGE());
        PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR(100)));
        PRINT('ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR(100)));
        PRINT('ERROR PROCEDURE: ' + ERROR_PROCEDURE());
    END CATCH
END
GO




EXEC get_customer_summary @Country = 'USA'

EXEC get_customer_summary @Country = 'GERMANY'

EXEC get_customer_summary

--FOR DROPPING
--DROP PROCEDURE PROCEDURE NAME

