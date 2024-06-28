USE AdventureWorks2017
--FullTextSearch

--CONTAINS

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'avenue')


SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, '"first avenue"')

-- AND, AND NOT, OR

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'avenue AND port')

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'avenue OR port')

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, '36 AND avenue OR port')

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, '36 AND (avenue OR port)')

--CONTAINS NEAR

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, '"5415 san" NEAR dr')

--Hasta 6 palabras entre 21 y centrale
SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'NEAR((21, centrale), 6)')

SELECT *
FROM Person.Address A
ORDER BY LEN(AddressLine1) DESC

--Hilton Head Factory Outlets No. 25
SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'NEAR((hilton, 25), 5)')

--CONTAINS FORMSOF -SUSTANTIVOS
SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'FORMSOF(INFLECTIONAL, "avenues")')

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'FORMSOF(INFLECTIONAL, "streets")')

--CONTAINS FORMSOF -VERBOS
UPDATE Person.Address
SET AddressLine1 = '6387 Scenic Avenue hacer'
WHERE AddressID = 8

SELECT *
FROM Person.Address A
WHERE CONTAINS(A.AddressLine1, 'FORMSOF(INFLECTIONAL, "hagamos")', LANGUAGE 3082)

SELECT *
FROM SYS.dm_fts_parser('FORMSOF(INFLECTIONAL, trabajo)', 3082, 0, 0)

--FREETEXT
SELECT *
FROM Person.Address A
WHERE FREETEXT(A.AddressLine1, 'street')

SELECT *
FROM Person.Address A
WHERE FREETEXT(A.AddressLine1, '"Routh street"')


-- Actualizar catálogo


