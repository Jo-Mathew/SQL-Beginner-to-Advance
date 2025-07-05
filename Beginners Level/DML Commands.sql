-- Data Manipulation Language
-- INSERT, UPDATE, DELETE

--1. manual method
SELECT * FROM customers
INSERT INTO customers(id, first_name, country, score) -- columns and values must have same order
VALUES (6, 'James', 'India', NULL),
	(7, 'Alice', NULL, 100)

-- 2. using another table (source table to target)
-- copy data from customers to persons

CREATE TABLE persons(
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
);

INSERT INTO persons(id, person_name, birth_date, phone)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers

SELECT * FROM persons

--UPDATE - -change the data of already existing  row

-- change the score of customer with ID 6 to 0
SELECT * FROM customers
UPDATE customers
SET score = 0
WHERE id=6

-- change the score of customer with ID 7 to 0 and update the country to 'UK'
UPDATE customers
SET score = 0, country = 'UK'
WHERE id = 7 

-- DELETE - deletes the contains where DROP removes the entire table
--delete customers with ID greater than 5

DELETE FROM customers
WHERE id>5

-- delete all data from persons
SELECT * FROM persons

-- TRUNCATE - same as DELETE FROM but without any condition (faster than delete)
TRUNCATE TABLE persons


