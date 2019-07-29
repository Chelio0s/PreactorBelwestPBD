
--Выбираем кол-во оборудования в цеху
CREATE FUNCTION [InputData].[udf_GetCountEquipmentInArea]
(
	@KOB int,
	@AreaId int
)
RETURNS INT
AS
BEGIN
DECLARE @retval INT

  SELECT @retval = COUNT([KOB])
  FROM [InputData].[Resources] as res
  INNER JOIN [InputData].[Departments] as dep ON res.DepartmentId = dep.IdDepartment
  INNER JOIN [InputData].[Areas] as area ON area.IdArea = dep.AreaId
  WHERE KOB = @KOB and AreaId = @AreaId

RETURN @retval
END
