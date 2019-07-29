CREATE FUNCTION [InputData].[udf_GetMaxCountEquipmentInAreaForOperation]
(
	@KTOP int,
	@AreaId int
)
RETURNS INT
AS
BEGIN
DECLARE @Ret int 
		SELECT TOP(1) @Ret =  COUNT(KOBChild) FROM [InputData].[VI_MappingRules] as vi
		INNER JOIN [InputData].[Resources] as res on res.KOB = KOBChild 
		INNER JOIN [InputData].[Departments] as dep ON dep.IdDepartment = res.DepartmentId
		INNER JOIN [InputData].[Areas] as area ON area.IdArea = dep.AreaId
		WHERE KTOPChild = @KTOP and vi.AreaId = @AreaId and area.IdArea = @AreaId
		GROUP BY KOBChild
		ORDER BY  COUNT(KOBChild) DESC
	RETURN @Ret
END
