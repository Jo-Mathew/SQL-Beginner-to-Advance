/* WHERE CLAUSE FILTERS
A. COMPARISON OPERATORS: = <> =! > >= < <=
B. LOGICAL OPERATORS: AD OR NOT
C. RANGE OPERATOR: BETWEEN
D. MEMBERSHIP OPERATOR: IN NOT IN
E. SEARCH OPERATOR: LIKE

*/

SELECT * FROM customers

-- retrive all customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany'

--retrive all the customers that are not from Germany
SELECT * 
FROM customers
WHERE country != 'Germany'

-- retrive all customers having score > 500
SELECT *
FROM customers
WHERE score>500

-- retrive all customers of score 500 or more
SELECT *
FROM customers
WHERE score >= 500

-- Logical Ops
-- AND -  all must be True
-- retrive all customers who are from USA and have score > 500
SELECT * 
FROM customers
WHERE (country = 'USA' AND score>500)

-- OR - atleast one condition must be True
-- retrive all customers who are from USA or have score > 500
SELECT * 
FROM customers
WHERE (country = 'USA' OR score>500)

-- NOT (reverse) excludes the matching values
-- reteive all customers with a score not less than 500
SELECT *
FROM customers
WHERE NOT score < 500

-- RANGE (Between) - checks whether a value is in a range
-- retrive all customers whose score lies in the range of 100 to 500
SELECT * 
FROM customers
WHERE score BETWEEN 100 AND 500

-- Membership ops - checks a values exists in a list
-- retrive customers from either germany or usa
SELECT * FROM customers
WHERE country IN ('Germany', 'USA')

SELECT * FROM customers
WHERE country NOT IN ('Germany', 'USA')

-- LIKE OPS - search for a pattern in text
-- % anything allowed
-- _ strictly that character only
-- find all customers whose first name starts with M
SELECT * FROM customers
WHERE first_name LIKE 'M%'

--find all customers whose name ends with N
SELECT * FROM customers
WHERE first_name LIKE '%N'

--find customers whose name contains an R
SELECT * FROM customers
WHERE first_name LIKE '%R%'

-- find all customers who has an r in the 3rd position
SELECT * FROM customers
WHERE first_name LIKE '__r%'





















