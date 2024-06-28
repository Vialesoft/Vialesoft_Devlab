/*
SELECT *
FROM HumanResources.Employee E

UPDATE HumanResources.Employee
SET CurrentFlag = 1

CREATE TABLE HumanResources.EmployeeList(
	NationalIDNumber VARCHAR(10),
	JobTitle VARCHAR(100)
);

SELECT *
FROM HumanResources.EmployeeList E

DELETE
FROM HumanResources.EmployeeList
*/

DECLARE @NationalIDNumber VARCHAR(10);
DECLARE @JobTitle VARCHAR(100);

-- FAST_FORWARD es una propiedad de Solo Lectura
DECLARE miCursor CURSOR FOR
SELECT NationalIDNumber, JobTitle
FROM HumanResources.Employee E
WHERE E.Gender = 'M';

OPEN miCursor
FETCH NEXT FROM miCursor
INTO @NationalIDNumber, @JobTitle

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO HumanResources.EmployeeList
	VALUES(@NationalIDNumber, @JobTitle);

	UPDATE HumanResources.Employee
	SET CurrentFlag = 0
	WHERE CURRENT OF miCursor
	--WHERE NationalIDNumber = @NationalIDNumber

	FETCH NEXT FROM miCursor
	INTO @NationalIDNumber, @JobTitle
END

CLOSE miCursor
DEALLOCATE miCursor