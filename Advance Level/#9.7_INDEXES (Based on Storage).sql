--ROWSTORE AND COLUMNSTORE INDEX 
DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCsutomers_CID 
ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCsutomers_FirstName 
ON Sales.DBCustomers (FirstName)

--Note: Multiple columnstore indexes are not supported.

