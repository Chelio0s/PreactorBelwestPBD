CREATE FUNCTION [InputData].[udf_GetShiftNumber]
(
	@OrgUnit int,
	@DateWork datetime
)
RETURNS INT
AS
BEGIN
DECLARE @Shift as int
SELECT @Shift = 
CASE WHEN (@OrgUnit = 50033716 or @OrgUnit = 50033718) and DATEPART(WEEK, @DateWork) % 2 = 1 THEN 1 
     WHEN (@OrgUnit = 50033716 or @OrgUnit = 50033718) and DATEPART(WEEK, @DateWork) % 2 = 0 THEN 2
	 WHEN (@OrgUnit = 50033722 or @OrgUnit = 50033723) and DATEPART(WEEK, @DateWork) % 2 = 1 THEN 2
     WHEN (@OrgUnit = 50033722 or @OrgUnit = 50033723) and DATEPART(WEEK, @DateWork) % 2 = 0 THEN 1 END 
	
	
	RETURN @Shift
END
