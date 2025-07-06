-- Joins - If you want join columns side by side
-- SET - if you want to join rows one below the other

-- No join - return data from 2 tables without combining them
-- retrive all data from customers and orders as 2 separate tables

SELECT * 
FROM customers

SELECT * 
FROM orders

-- Inners Joins - return only the matching rows (default types)
--get all customers along with their orders, but only for customers who have placed an order
SELECT 
	c.id,    -- this is column disambiquity (to avoid confusion if two tables have same column names)
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c  -- alias - use when the column name is long
INNER JOIN orders AS o
ON c.id = o.customer_id


--LEFT JOIN - return all rows from left but only matching from right table
-- get all customers along with their orders, including those without orders
SELECT c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

--RIGHT JOIN - return all rows from right table but only matching from left table
-- get all customers along with their orders, including orders without matching customers
SELECT c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

-- get all customers along with their orders, including orders without matching customers
--(USING LEFT Join)
SELECT c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
LEFT JOIN customers AS c
ON c.id = o.customer_id

--FULL JOIN - everything from both tables
SELECT c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
FULL JOIN customers AS c
ON c.id = o.customer_id

--ADVANCE JOINS
--LEFT ANTI JOINS
-- Returns rows from left table that has no match from the right table
-- get all customers who haven't placed any orders
SELECT *
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--right anti join
-- return rows from right table that has no match from the left table
-- get all orders without matching customers
SELECT *
FROM customers as c
RIGHT join orders as o
ON o.customer_id = c.id
WHERE c.id IS NULL

--FULL ANTI JOIN - return rows that don't match in either tables
--find customers without orders and orders without customers
SELECT *
FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

--get all customers along with their orders, but only for customers who have placed an order
--(without using INNER Join)
SELECT *
FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL

--CROSS JOIN
--combines every row from left with every row from right
--cartesian join
--generate all possible combinations of customers and orders
SELECT *
FROM customers 
CROSS Join orders
