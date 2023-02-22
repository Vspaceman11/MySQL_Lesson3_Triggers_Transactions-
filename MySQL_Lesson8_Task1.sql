DROP  DATABASE myFunkDB;
CREATE DATABASE myFunkDB;

USE myFunkDB;

CREATE TABLE person
(
id int auto_increment NOT NULL PRIMARY KEY,
name varchar(60) NOT NULL,
phone varchar(12) NOT NULL
);

CREATE TABLE salary
(
id int auto_increment NOT NULL PRIMARY KEY,
person_id int NOT NULL,
salary float(10,2) NOT NULL,
position varchar(40) NOT NULL,
FOREIGN KEY(person_id) REFERENCES person(id)
);

CREATE TABLE personalData
(
id int auto_increment NOT NULL PRIMARY KEY,
person_id int NOT NULL,
familyStatus varchar(30) NOT NULL,
birthday date NOT NULL,
adress varchar(50) NOT NULL,
FOREIGN KEY(person_id) REFERENCES person(id)
);

INSERT INTO person
(name, phone)
VALUES
('Anton Pavlov','(060)7142212'),
('Mary Cure','(067)4302001'),
('Jack Sparrow','(050)6202990'),
('Dave Johns','(068)7181236'),
('Jane Ostin','(050)2133217');

INSERT INTO salary
(person_id, salary, position)
VALUES
(1, 350.20, 'worker'),
(2, 500.50, 'worker'),
(3, 690.25, 'Manager'),
(4, 800.50, 'Manager'),
(5, 2300.50, 'Director');

INSERT INTO personalData
(person_id, familyStatus, birthday, adress)
VALUES
(1, 'Single', '1994-02-13', 'Adler st, 14'),
(2, 'Divorced', '1990-12-09', 'Broken st, 56'),
(3, 'Married', '1991-03-12', 'Gray st, 101'),
(4, 'Divorced', '1986-06-23', 'Sample st, 99'),
(5, 'Married', '1984-01-29', 'Kane st, 19');

SELECT * FROM person;
SELECT * FROM salary;
SELECT * FROM personalData;

DELIMITER |
DROP PROCEDURE addPerson; |
CREATE PROCEDURE addPerson(IN addName varchar(40), IN addPhone varchar(12))

BEGIN
DECLARE Id_check int;
START TRANSACTION;
	INSERT person
    (name, phone)
    VALUES
    (addName, addPhone);
    SET Id_check = @@IDENTITY;
IF EXISTS (SELECT * FROM person Where name = addName AND phone = addPhone AND Id != Id_check)
		THEN
			ROLLBACK;
		END IF;
	COMMIT;
END;
|
DELIMITER |
-- Первое значение не добавиться, так как такой пользователь уже есть в таблице --
CALL addPerson('Dave Johns','(068)7181236'); |

CALL addPerson('James Hatfield','(068)7134166'); |


DELIMITER |
DROP TRIGGER delete_salary_personalData 
|
CREATE TRIGGER delete_salary_personalData
BEFORE DELETE ON person 
FOR EACH ROW 
  BEGIN
	DELETE FROM salary WHERE id = salary.person_id;
	DELETE FROM personalData WHERE id = personaldata.person_id;
 END;
    |
    
DELETE FROM person WHERE id = 1; |

SELECT * FROM person;

