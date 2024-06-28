USE AdventureWorks2017
GO
CREATE TABLE sales.SpecialOfferReseller(
	SpecialOfferID int not null,
	[Description] nvarchar(255) not null, 
	DiscountPct smallmoney not null
)
GO
CREATE TABLE sales.SpecialOfferCustomer(
	SpecialOfferID int not null,
	[Description] nvarchar(255) not null, 
	DiscountPct smallmoney not null
)
INSERT INTO sales.SpecialOfferReseller
SELECT SpecialOfferID, [Description], DiscountPct FROM sales.SpecialOffer WHERE Category='Reseller'
GO
INSERT INTO sales.SpecialOfferCustomer
SELECT SpecialOfferID, [Description], DiscountPct FROM sales.SpecialOffer WHERE Category='Customer'