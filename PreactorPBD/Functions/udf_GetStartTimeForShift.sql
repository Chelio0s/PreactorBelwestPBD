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
INNER JOIN [SupportData].[OrgUnit] as OrgUnit ON OrgUnit.AreaId = areas.IdArea
WHERE OrgUnit.OrgUnit = @OrgUnit and setting.ShiftId = @Shift
	RETURN @time
END
