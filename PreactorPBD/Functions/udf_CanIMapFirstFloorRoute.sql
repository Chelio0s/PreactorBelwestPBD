-- Can I map operations from first floor to 9/1  only this route
-- If there are operations  203,293 and other 
-- I can't map this

CREATE FUNCTION [InputData].[udf_CanIMapFirstFloorRoute]
(
	@IdRoute int
)

RETURNS BIT
AS
BEGIN
	DECLARE @Result1		BIT 
    DECLARE @Result2		BIT

	SET @Result1 = ( SELECT	CASE WHEN COUNT(KTOPN) = 0  THEN CONVERT(bit, 'false') ELSE CONVERT(bit, 'true') END CanIMap
					FROM	[InputData].[VI_GetOperationsForMappingFirstFloor]
					WHERE	IdRout = @IdRoute )
	SET @Result2 = ( SELECT TOP(1) CASE WHEN [InputData].[udf_CanIMapFirstFloor](Article) = 0 THEN CONVERT(bit, 'false') ELSE CONVERT(bit, 'true') END CanIMap
					FROM	[InputData].[VI_GetOperationsForMappingFirstFloor]
					WHERE	IdRout = @IdRoute)
 
IF @Result1 = 1 AND @Result2 = 1
BEGIN 
	RETURN 1 
END

RETURN 0

END