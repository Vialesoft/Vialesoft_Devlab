DECLARE @pageNumber AS INT,
		@pageSize	AS INT,
		@totalPages	AS INT

SET @pageNumber = 0;
SET @pageSize = 10;
SET @totalPages = (SELECT COUNT(*) FROM Sales.SalesOrderHeader S) / @pageSize


SELECT RowNumber,
		@totalPages AS TotalPages,
		SalesOrderNumber,
		PurchaseOrderNumber,
		AccountNumber,
		CustomerID
FROM (
	SELECT *, ROW_NUMBER() OVER (ORDER BY SalesOrderID) AS RowNumber
	FROM Sales.SalesOrderHeader S) AS Sales
WHERE RowNumber BETWEEN @pageSize * @pageNumber + 1
	AND @pageSize * (@pageNumber + 1)