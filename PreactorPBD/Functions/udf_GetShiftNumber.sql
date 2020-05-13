-- Возвращает номер смены ShiftId (утро, вечер) в зависимости от четности/нечетности недели
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
CASE WHEN (@OrgUnit = 50033716 or @OrgUnit = 50033718 or @OrgUnit = 50000478) and DATEPART(WEEK, @DateWork) % 2 = 1 THEN 1 
     WHEN (@OrgUnit = 50033716 or @OrgUnit = 50033718 or @OrgUnit = 50000478) and DATEPART(WEEK, @DateWork) % 2 = 0 THEN 2
	 WHEN (@OrgUnit = 50033722 or @OrgUnit = 50033723 or @OrgUnit = 50000479) and DATEPART(WEEK, @DateWork) % 2 = 1 THEN 2
     WHEN (@OrgUnit = 50033722 or @OrgUnit = 50033723 or @OrgUnit = 50000479) and DATEPART(WEEK, @DateWork) % 2 = 0 THEN 1 
	 END 
	RETURN @Shift
END
