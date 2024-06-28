CREATE OR ALTER PROCEDURE SEL_Productos(
	@orden char(1) = ''
)
AS
BEGIN
	DECLARE @script NVARCHAR(MAX);
	DECLARE @orderBy NVARCHAR(500);

	SET @script = '	SELECT P.ProductID, P.Name, P.ListPrice
					FROM Production.Product P';
	SET @orderBy = (CASE
					WHEN @orden = 'N' THEN ' ORDER BY P.Name'
					WHEN @orden = 'I' THEN ' ORDER BY P.ProductID'
					ELSE ' ORDER BY P.ListPrice'
					END);

	SET @script = @script + @orderBy;

	--SELECT @script;
	EXEC SP_EXECUTESQL @script;
END


EXEC SEL_Productos 'N';
EXEC SEL_Productos 'I';
EXEC SEL_Productos;