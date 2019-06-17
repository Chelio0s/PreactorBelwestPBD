--Полный бэкап БД

CREATE PROCEDURE [System].[sp_BackUp_Full]
AS
--Формируем имя бэкапа дата/время
	DECLARE @FileName as varchar(max) 
SET @FileName = N'C:\DBBackup\PreactorSDB_backup'
SET @FileName = @Filename + REPLACE(CONVERT(nvarchar(max), getdate(),104), '.', '_') + '.trn'

--Сам бэкап
BACKUP DATABASE [PreactorSDB] TO  DISK =  @FileName
WITH NOFORMAT, NOINIT,  NAME = N'PreactorSDB-Полная База данных Резервное копирование', 
SKIP, 
NOREWIND, 
NOUNLOAD,
STATS = 10

RETURN 0
