--Переводим БД в простой режим восстановления
--Шринк
--Перевод в полное восстановление
CREATE PROCEDURE [System].[sp_SrinkDb]
AS
ALTER DATABASE [PreactorSDB] SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKDATABASE(N'PreactorSDB' )
ALTER DATABASE [PreactorSDB] SET RECOVERY FULL WITH NO_WAIT
RETURN 0
