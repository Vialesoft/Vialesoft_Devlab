CREATE OR ALTER PROCEDURE SEL_ProductosOUTPUT(
	@orden char(1),
	@out VARCHAR(MAX) OUTPUT
)
AS
	DECLARE @script NVARCHAR(MAX);
	DECLARE @orderBy NVARCHAR(500);

	SET @script = '	SELECT P.ProductID, P.Name, P.ListPrice
					FROM Production.Product P';
	SET @orderBy = (CASE
					WHEN @orden = 'N' THEN ' ORDER BY P.Name'
					WHEN @orden = 'I' THEN ' ORDER BY P.ProductID'
					ELSE ' ORDER BY P.ListPrice'
					END);

	--SET @script = @script + @orderBy;
	SET @out = @script + @orderBy;

	--SELECT @script;
	--EXEC SP_EXECUTESQL @script;

GO

DECLARE @out NVARCHAR(MAX)

EXEC SEL_ProductosOUTPUT 'I', @out;
EXEC SP_EXECUTESQL @out;

EXEC SEL_ProductosOUTPUT 'I', @out;
EXEC SEL_ProductosOUTPUT NULL, @out;
