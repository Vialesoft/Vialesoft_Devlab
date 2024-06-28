SELECT *
FROM Sales.SalesOrderHeader --SalesOrderID, OrderDate

SELECT *
FROM Sales.SalesOrderDetail --SalesOrderID, ProductID

SELECT *
FROM Production.Product --ProductID, ProductSubcategoryID

SELECT *
FROM Production.ProductSubcategory --ProductSubcategoryID, ProductCategoryID

SELECT *
FROM Production.ProductCategory --ProductCategoryID, Name

WITH VentasPorCategoria AS (
SELECT	DISTINCT
		DATEPART(YEAR, SOH.OrderDate)	AS Ano,
		PC.[Name]						AS Categoria,
		P.ProductID
FROM Sales.SalesOrderHeader SOH
	INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN Production.Product P ON P.ProductID = SOD.ProductID
	INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
	INNER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
)

SELECT *
FROM VentasPorCategoria
PIVOT(COUNT(ProductID) FOR Ano IN([2014], [2013], [2011])) AS PivoteTable
UNPIVOT (ProductID FOR Ano IN([2014], [2013], [2011])) AS UnpivotTable