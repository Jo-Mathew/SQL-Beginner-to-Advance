-- Data Definition Language (DDL)
-- CREATE, ALTER, DROP

CREATE TABLE persons(
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
);

SELECT * 
FROM persons;

-- ALTER - add new column, datatype change
-- add a new column email
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

SELECT * FROM persons

-- remove phone columns
ALTER TABLE persons
DROP COLUMN phone

SELECT * FROM persons

-- DROP - remove the table and entire thing inside it
DROP TABLE persons