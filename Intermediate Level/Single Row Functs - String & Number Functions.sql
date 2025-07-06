--Manipulation Functions
--CONCAT - combine multiple string value into one

--concat first name and country into one column
USE MyDatabase
SELECT 
	first_name,
	country,
	CONCAT(first_name,' ', country) AS name_country
FROM customers

--UPPER AND LOWER
--convert first name to lowercase
SELECT 
	LOWER(first_name) AS lower_name
FROM customers;

SELECT 
	UPPER(first_name) AS upper_name
FROM customers;

--TRIM - removes trailing and leading spaces
--find customers who has spaces 
SELECT
	first_name,
	LEN(first_name) AS length_name,
	LEN(TRIM(first_name)) AS length_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) flag 
FROM customers
--WHERE first_name != TRIM(first_name)

--replace - replace specific character with a new
--remove dashes from a phone number
SELECT 
	'123-345-678' AS phone_temp,
	REPLACE ('123-345-678', '-', '|') AS replaced_phone_temp
--replace .txt to .csv
SELECT 
	'file.txt' AS file_txt,
	REPLACE ('file.txt', '.txt', '.csv') AS replaced_file_txt

-- LEN
SELECT
	'  HEY ! ' AS Sample_Text,
	LEN('  HEY ! ') AS Sample_Text_Len

--LEFT & RIGHT
--retrive first 2 chars from first name and last 2 
SELECT 
	first_name,
	LEFT(first_name, 2) AS First_2,
	RIGHT(first_name, 2) AS last_2
FROM customers

--substring
--retrive a list of customers, first names removing the first character
SELECT 
	first_name,
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS Result --Here 2 is from what position you want to start 
FROM customers

--NUMBER FUNCTIONS
-- ROUND

SELECT
	(3.521),
	ROUND(3.521, 2) AS round_2,
	ROUND(3.521, 1) AS round_1,
	ROUND(3.521, 0) AS round_0

--ABS
SELECT
	(-100),
	ABS(-100)


