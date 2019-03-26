--Возвращает время начала смены для оргюнита и смены
CREATE FUNCTION [InputData].[udf_GetStartTimeForShift]
(
	@OrgUnit int,
	@Shift int
)
RETURNS time
AS
BEGIN
DECLARE @time as time
SELECT @time = TimeStart 
FROM [SupportData].[SettingShift] as setting
INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = setting.AreaId
INNER JOIN [SupportData].[Orgunit] as orgunit ON orgunit.AreaId = areas.IdArea
WHERE orgunit.OrgUnit = @OrgUnit and setting.ShiftId = @Shift
	RETURN @time
END
