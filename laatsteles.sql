use AdventureWorksLT2014
go
-- 1 --
select UPPER(Name) as productname, ROUND(weight,0) as approxweight
FROM SalesLT.Product
--2 --
SELECT UPPER(Name) as productname, ROUND(weight,0) as approxweight,
YEAR(SellStartDate) as SellStartYear, DATENAME(m,SellStartDate) as SellStartMonth
FROM SalesLT.Product
-- 3 --
SELECT UPPER(Name) as productname, ROUND(weight,0) as approxweight,
YEAR(SellStartDate) as SellStartYear, DATENAME(m,SellStartDate) as SellStartMonth,
LEFT(ProductNumber, 2) as producttype, productnumber
FROM SalesLT.Product
-- 4 --
SELECT UPPER(Name) as productname, ROUND(weight,0) as approxweight,
YEAR(SellStartDate) as SellStartYear, DATENAME(m,SellStartDate) as SellStartMonth,
LEFT(ProductNumber, 2) as producttype, productnumber
FROM SalesLT.Product
WHERE ISNUMERIC(Size)=1
-- 5 --
SELECT Name, SUM(LineTotal) TotalRevenue
FROM SALESLT.SalesOrderDetail sod
JOIN SalesLT.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC
-- 6 --
SELECT Name, SUM(LineTotal) TotalRevenue
FROM SALESLT.SalesOrderDetail sod
JOIN SalesLT.Product p ON sod.ProductID = p.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC

-- GENESTE SELECTS --
-- Geef een lijst van producten waarvan de lijst groter is dan de hoogste
-- eenheidsprijs van verkochte items
SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail

SELECT * FROM SalesLT.PRODUCT WHERE ListPrice > 1466.01

SELECT * FROM SALESLT.PRODUCT
WHERE ListPrice > (SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail)

-- oplijsten van producten die een bestelhoeveelheid hadden van meer dan
-- 20
SELECT Name, p.ProductID
FROM SALESLT.Product p
JOIN SalesLT.SalesOrderDetail sod
on p.productid= sod.ProductID
WHERE OrderQty >20

SELECT Name, ProductID
FROM SALESLT.Product p
WHERE ProductID IN (SELECT ProductID from SalesLT.SalesOrderDetail
WHERE OrderQty > 20)


-- EIGEN FUNCTIES --
CREATE FUNCTION SalesLT.udfCustomersByCity
(@City as VARCHAR(20))
RETURNS TABLE
AS
RETURN
(
SELECT c.CustomerID, FirstName, LastName, AddressLine1, city, StateProvince
FROM SalesLT.Customer c
JOIN SalesLT.CustomerAddress ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address a
ON ca.AddressID = a.AddressID
WHERE City = @City
);

-- GEBRUIK MAKEN VAN DE FUNCTIE --
SELECT * FROM SalesLT.udfCustomersByCity('Bellevue')

-- oplijsten van alle verkopen op de laatste verkoopdag voor elke klant --
-- lijst customerid, salesorderid en orderdate op en sorteer volgens customerid
-- en orderdate.

SELECT customerid, SalesOrderID,OrderDate
FROM SALESLT.SalesOrderHeader so1
order by CustomerID, OrderDate

SELECT customerid, SalesOrderID,OrderDate
FROM SALESLT.SalesOrderHeader so1
WHERE OrderDate=(SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader)
order by CustomerID, OrderDate

SELECT customerid, SalesOrderID,OrderDate
FROM SALESLT.SalesOrderHeader so1
WHERE OrderDate=(SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader so2
WHERE so2.CustomerID = so1.CustomerID)
order by CustomerID, OrderDate

-- GEEF alle producten van wie de listprice hoger is dan de gemiddelde unit price
-- geef productid, name en listprice
SELECT productid, name, listprice from saleslt.product where
listprice > (select avg(unitprice) from saleslt.SalesOrderDetail)
Order by productid

--geef alle producten terug die hoger of gelijk geprijsd staan aan 100
-- geef productid, name en listprice

SELECT productid, name, listprice from saleslt.Product
WHERE productid IN (SELECT productid from SalesLT.SalesOrderDetail
WHERE Unitprice < 100.00) AND Listprice >= 100.00
ORDER by ProductID

--geef het productid, naam, standaardcost, listprice en gemiddelde verkoopsprijs
-- voor ieder product
select productid, name, standardcost, listprice,
(select avg(Unitprice)
FROM saleslt.SalesOrderDetail as sod
WHERE p.productid = sod.ProductID) as avgsellingprice
FROM SalesLT.product p
ORDER BY p.ProductID
--vind de producten waar de gemiddelde verkoopsprijs minder is dan de kost
select productid, name, standardcost, listprice,
(select avg(Unitprice)
FROM saleslt.SalesOrderDetail as sod
WHERE p.productid = sod.ProductID) as avgsellingprice
FROM SalesLT.product p
where StandardCost > (SELECT avg(UnitPrice) from saleslt.SalesOrderDetail sod
WHERE p.Productid = sod.ProductID)
ORDER BY p.ProductID
