USE AdventureWorksLT2014
GO

SELECT * FROM SalesLT.Product

SELECT Name, ListPrice, StandardCost FROM SalesLT.Product

SELECT ProductID, Name, ListPrice-StandardCost AS Verschil FROM SalesLT.Product

SELECT ProductID, Name, Color, Size FROM SalesLT.Product

SELECT TOP 60 ProductID, Name, Color, Size, Color + ' ' + Size AS Style FROM SalesLT.Product
ORDER BY Name, Size

--functions

/*OMZETTINGEN*/

--CAST
SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName FROM SalesLT.Product

--CONVERT
SELECT CONVERT(varchar(5),ProductId) + ': ' + Name As ProductName FROM SalesLT.Product

--CONVERT DATUMS
SELECT SellStartDate, CONVERT(nvarchar(30), SellStartDate) AS ConvertDate, 
CONVERT (nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate FROM SalesLT.Product

-- TRY CAST
SELECT Name, TRY_CAST(Size AS Intege²r) AS NumericSize FROM SalesLT.Product