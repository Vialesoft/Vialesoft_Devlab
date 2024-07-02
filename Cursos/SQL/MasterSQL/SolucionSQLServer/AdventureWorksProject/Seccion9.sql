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

--RAISERROR

BEGIN TRY

INSERT INTO Sales.SalesPerson
VALUES(270,20,100,200,0,25000,200000, NEWID(), GETDATE());

END TRY
BEGIN CATCH

RAISERROR('Error al insertar la venta person', 16, 1);
--16: Severity, del 0 al 24
--1: State

END CATCH

--ERRORES PERSONALIZADOS
--IDERROR > 50000
--SEVERITY 1 A 25

/*
	IDError, Severity (16 normal), mensaje
*/
EXEC sp_addmessage 50001, 16, 'Ocurrió un error en la tabla venta person'

BEGIN TRY

INSERT INTO Sales.SalesPerson
VALUES(270,20,100,200,0,25000,200000, NEWID(), GETDATE());

END TRY
BEGIN CATCH

RAISERROR(50001, -1, 4);

END CATCH