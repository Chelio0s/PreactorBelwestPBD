--Возвращает имя операции по номеру
CREATE FUNCTION [InputData].[udf_GetKTOPTitle]
(
	@KTOP int
	
)
RETURNS INT
AS
BEGIN
DECLARE @operation NVARCHAR(99)
SELECT TOP(1) @operation = [RKV].[PLANT].[dbo].[s_top2] WHERE KTOP = @KTOP
	RETURN @operation
END
