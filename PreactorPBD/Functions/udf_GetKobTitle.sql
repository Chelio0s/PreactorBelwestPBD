CREATE FUNCTION [InputData].[udf_GetKobTitle]
(
	@KOB int
)
RETURNS nvarchar(99)
AS
BEGIN
DECLARE @MOB varchar(99)
	SET @MOB = (SELECT DISTINCT
      [MOB]
  FROM [$(RKV)].[$(PLANT)].[dbo].[plant3]
  WHERE KOB = @KOB)
  RETURN @MOB
END
