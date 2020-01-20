CREATE FUNCTION [InputData].[udf_GetModelForArticle]
(
	@Article nvarchar(99)
)
RETURNS nvarchar(99)
AS
BEGIN
DECLARE @ret nvarchar(99)
	SET @ret = (SELECT TOP(1) MOD 
				FROM [$(RKV)].[$(RKV_SCAL)].[dbo].[F160013]
				WHERE ART = @Article)
	RETURN @ret
END
