USE AdventureWorks2017

--SELECT *
--FROM Person.Person

--CREATE TABLE PersonEjemplo(
--	FirstName VARCHAR(50),
--	LastName VARCHAR(50),
--);

-- INSERT INTO SELECT

INSERT INTO PersonEjemplo
SELECT P.FirstName, P.LastName
FROM Person.Person P

SELECT *
FROM PersonEjemplo

-- UPDATE INNER JOIN

UPDATE Person.Person
SET Suffix = E.NationalIDNumber
FROM HumanResources.Employee E
	INNER JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.JobTitle = 'Sales Representative'

-- DELETE INNER JOIN

DELETE E
FROM Person.EmailAddress E
	INNER JOIN Person.BusinessEntity B ON B.BusinessEntityID = E.BusinessEntityID
	INNER JOIN HumanResources.Employee EM ON EM.BusinessEntityID = B.BusinessEntityID
WHERE EM.JobTitle = 'Tool Designer';

--SELECT INTO
--Creando tabla vacía, replicando estructura

SELECT *
INTO EmailBackup
FROM Person.EmailAddress
WHERE 1=0

--Replicando estructura y datos (No PK, ni FK)
SELECT *
INTO Person.PersonCopia
FROM Person.Person

-- Copiar tabla en otra BD

SELECT *
INTO AdventureBak..PersonAddr
FROM Person.Address

-- Copiar tabla con campo Identity
SELECT IDENTITY(INT, 1, 1) as ID, *
INTO AdventureBak..PersonPhone
FROM Person.PersonPhone


-- Cloned Database
DBCC CLONEDATABASE(AdventureWorks2017, AdventureBak)