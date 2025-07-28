--INDEX MANAGEMENT
--1. TO MONITOR INDEX USAGE
--LIST ALL THE THE INDEXES
sp_helpindex 'Sales.DBCustomers'

SELECT * FROM sys.indexes

SELECT
    object_id,
    name AS IndexName,
    type_desc AS IndexType,
    is_primary_key AS IsPrimaryKey,
    is_unique AS IsUnique,
    is_disabled AS IsDisabled
FROM sys.indexes

SELECT 
    o.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_primary_key AS IsPrimaryKey,
    i.is_unique AS IsUnique,
    i.is_disabled AS IsDisabled
FROM sys.indexes i
JOIN sys.tables o 
ON i.object_id = o.object_id

SELECT * FROM sys.dm_db_index_usage_stats

SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    idx.is_primary_key AS IsPrimaryKey,
    idx.is_unique AS IsUnique,
    idx.is_disabled AS IsDisabled,
    s.user_seeks AS UserSeeks,
    s.user_scans AS UserScans,
    s.user_lookups AS UserLookups,
    s.user_updates AS UserUpdates,
    COALESCE(s.last_user_seek, s.last_user_scan) AS LastUsed
FROM sys.indexes idx
JOIN sys.tables tbl 
    ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s 
    ON s.object_id = idx.object_id 
    AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;


SELECT CustomerID FROM Sales.DBCustomers WHERE CustomerID = 2

--MONITOR MISSING INDEXES

USE [AdventureWorksDW2022]
SELECT 
    fs.SalesOrderNumber,
    dp.EnglishProductName,
    dp.Color
FROM FactInternetSales fs
JOIN DimProduct dp ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
  AND fs.OrderDateKey BETWEEN 20101229 AND 20120101;

SELECT * FROM sys.dm_db_missing_index_details;

--3. Monitor Duplicate Indexes
SELECT 
    tbl.name AS TableName,
    col.name AS IndexColumn,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    COUNT(*) OVER (PARTITION BY tbl.name, col.name) AS ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl 
    ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic 
    ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col 
    ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC;

ORDER BY tbl.name, col.name;


--4. UPDATE THE STATISTICS - SO THAT DBMS ENGINE COULD CHECK THE STATISTICS OF THE TABLE AND DECIDE ON WHICH EXECUTION PLAN TO MAKE

SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

--TO UPDATE STATISTICS

UPDATE STATISTICS TABLE_NAME STATISTIC_NAME

--TO UPDATE ALL STATISTICS
UPDATE STATISTICS Sales.Products

--5. MONTIOR FRAGEMENTATIONS - UNUSED PAGES

SELECT
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- Reorganize index
ALTER INDEX idx_DBCsutomers_CID ON Sales.DBCustomers REORGANIZE;

-- Rebuild index
ALTER INDEX [IndexName] ON [TableName] REBUILD;
