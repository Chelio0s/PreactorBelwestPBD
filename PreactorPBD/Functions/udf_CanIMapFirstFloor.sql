-- Can I map operations from first floor to 9/1 
-- If there are operations  203,293 and other 
-- I can't map this

CREATE FUNCTION [InputData].[udf_CanIMapFirstFloor]
(
	@Article nvarchar(99)
)
RETURNS BIT
AS
BEGIN

DECLARE @Result BIT 
SET @Result = ( SELECT  CASE WHEN COUNT(KTOPN) = 0 THEN CONVERT(bit, 'true') ELSE CONVERT(bit, 'false') END CanIMap
				FROM [SupportData].[TempOperations]
				WHERE Article = @Article AND KTOPN IN (203,293,118,264,269,155,236,263,280,278,295,196,255,281,283,161,211,178,165,167,243))
RETURN @Result
END
