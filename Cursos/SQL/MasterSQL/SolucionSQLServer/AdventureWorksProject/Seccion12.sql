-- Activar Distributed Queries

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

--Conectar a un server remoto
SELECT *
FROM OPENROWSET('SQLNCLI', 'Server=192.168.0.14;UID=usuario;PWD=pass', cuarentacero.dbo.udemycurso);

--Leer archivo JSON
DECLARE @JSON VARCHAR(MAX);
SELECT *
FROM OPENROWSET (
	BULK 'C:\sqldata\archivo.json', SINGLE_CLOB) IMPORT;
-- SINGLE_CLOB funciona con VARCHAR

---

DECLARE @JSONCol VARCHAR(MAX);
SELECT @JSONCol = BulkColumn
FROM OPENROWSET(BULK 'C:\sqldata\archivo.json', SINGLE_CLOB) IMPORT

SELECT *
FROM OPENJSON (@JSONCol)