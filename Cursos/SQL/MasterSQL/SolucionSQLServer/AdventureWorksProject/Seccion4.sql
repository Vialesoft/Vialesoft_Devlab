SELECT *
FROM Person.Person P
	LEFT JOIN Person.EmailAddress E ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.BusinessEntityID IS NULL

---

DECLARE @nombre VARCHAR(30) = NULL

SELECT *
FROM Person.Person P
WHERE P.FirstName = (CASE
	WHEN ISNULL(@nombre, '') <> ''
		THEN @nombre
		ELSE P.FirstName
	END)

-- BUSCAR ENTRE BASES DE DATOS
SELECT *
FROM Person.EmailAddress E
	INNER JOIN AdventureWorks2017_Nueva.Person.EmailAddress NE ON E.BusinessEntityID = NE.BusinessEntityID


---

SELECT *
FROM Sales.SpecialOffer

SELECT *
FROM Sales.SpecialOfferCustomer

SELECT *
FROM Sales.SpecialOfferReseller


SELECT *
FROM Sales.SpecialOfferCustomer C
	CROSS JOIN Sales.SpecialOfferReseller R