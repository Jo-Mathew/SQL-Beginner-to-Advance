--TRIGGERS
--STEP 1: CREATE A LOG TABLE
CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
)

--STEP 2: CREATE A TRIGGER ON EMPLOYEES TABLE
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee added = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

--STEP 3: INSERT NEW DATA INTO EMPLOYEES
SELECT * FROM Sales.Employees
INSERT INTO Sales.Employees
VALUES(6, 'Mathew', 'White', 'IT', '1989-02-21', 'M', 40000, 4)


--CHECK THE LOGS
SELECT * FROM Sales.EmployeeLogs
