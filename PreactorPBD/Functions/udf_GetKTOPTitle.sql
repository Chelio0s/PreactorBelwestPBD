--Возвращает имя операции по номеру
CREATE FUNCTION [InputData].[udf_GetKTOPTitle]
(
	@KTOP int
)
RETURNS NVARCHAR(99)
AS
BEGIN
DECLARE @operation NVARCHAR(99)
SELECT TOP(1) @operation = RTRIM(LTRIM([NTOP]))  FROM [$(RKV)].[$(PLANT)].[dbo].[s_top2] WHERE KTOP = @KTOP
	RETURN @operation
END
GO