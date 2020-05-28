--Возвращает время начала смены для оргюнита и смены
CREATE FUNCTION [InputData].[udf_GetStartTimeForShift]
(
	@OrgUnit int,
	@Shift int,
	@WorkDay date
)
RETURNS time
AS
BEGIN
DECLARE @time as time
SELECT TOP(1) @time = TimeStart 
FROM [SupportData].[SettingShift]				AS setting
INNER JOIN [InputData].[Areas]					AS areas		ON areas.IdArea = setting.AreaId
INNER JOIN [SupportData].[OrgUnit]				AS OrgUnit		ON OrgUnit.AreaId = areas.IdArea
INNER JOIN [SupportData].[SettingShiftUseFrom]	AS SettStart	ON SettStart.SettingShiftId = setting.IdSettingShift
WHERE OrgUnit.OrgUnit = @OrgUnit 
AND setting.ShiftId = @Shift 
AND [StartUseFrom] <= @WorkDay
ORDER BY [StartUseFrom] DESC
	RETURN @time
END
