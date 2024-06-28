WITH Employee AS (
	SELECT E.BusinessEntityID, E.NationalIDNumber
	FROM HumanResources.Employee E
	WHERE JobTitle = 'Sales Representative'
)
UPDATE Person.Person
SET Suffix = E.NationalIDNumber
FROM Person.Person P
	INNER JOIN Employee E ON P.BusinessEntityID = E.BusinessEntityID

--WAITFOR

WAITFOR DELAY '00:00:07';