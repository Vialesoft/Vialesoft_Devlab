--CREO LA BD
create database OLTPRETAIL;

-- CREO DISTINTOS ESQUEMAS
create schema oltp;
create schema olap;
create schema olappython;

-- CREO LA TABLA OLTP
create table oltp.ONLINE_RETAIL(
	"InvoiceNo" 		VARCHAR(12),
	"StockCode"			VARCHAR(12),
	"Description"		VARCHAR(100),
	"Quantity"			INTEGER,
	"InvoiceDate"		DATE,
	"UnitPrice"			DECIMAL,
	"CustomerID"		INTEGER,
	"Country"			VARCHAR(50)
);

------------------------------------------------------

-- CREO LAS TABLAS OLAP
create table olap.HECHOS_VENTAS(
	"InvoiceNo"			VARCHAR(12) primary key references olap.DIMENSION_FACTURA("InvoiceNo"),
	"StockCode"			VARCHAR(12) references olap.DIMENSION_PRODUCTO("StockCode"),
	"Quantity"			INTEGER,
	"UnitPrice"			DECIMAL(10,2),
	"TotalPrice"		DECIMAL(10,2),
	"MovementType"		VARCHAR(20),
	"Comment"			VARCHAR(30)
);

create table olap.DIMENSION_FACTURA(
	"InvoiceNo" 		VARCHAR(12) PRIMARY KEY,
	"InvoiceDate"		DATE,
	"CustomerID"		INTEGER,
	"CountryID"			INTEGER
);

create table olap.DIMENSION_PRODUCTO(
	"StockCode"			VARCHAR(12) PRIMARY KEY,
	"Description"		VARCHAR(100)
);

create table olap.DIMENSION_PAIS(
	"CountryID"			INTEGER PRIMARY KEY,
	"CountryName"		VARCHAR(50)
);

create table olap.DIMENSION_TIEMPO(
    "DateID"      DATE PRIMARY KEY,
    "Year"        INTEGER,
    "Month"       INTEGER,
    "MonthName"   VARCHAR(20),
    "Quarter"     INTEGER,
    "Week"        INTEGER,
    "Day"         INTEGER,
    "DayName"     VARCHAR(20)
);

------------------------------------------------------
-- CARGO LAS TABLAS OLAP

insert into olap.DIMENSION_PRODUCTO("StockCode", "Description")
select DISTINCT O."StockCode", O."Description"
from oltp.ONLINE_RETAIL O
where O."Description" is not null and O."Description" not in('check', 'damaged', 'wet/r', 'found', 'Found', 'Adjustment', 'dotcom', 'adjustment', '?', 'lost in space')
group by O."StockCode", O."Description"
order by O."StockCode"




