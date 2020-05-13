CREATE FUNCTION [InputData].[udf_GetAviableequipmentForMappingOperation]
(
	@KTOP int,
	@AreaId int
)
RETURNS @returntable TABLE
(
	KOB int
)
AS
BEGIN
	  INSERT @returntable
	  SELECT 
		rc.KOB as KOBChild
	  FROM [SupportData].[MappingRules] as mr
	  INNER JOIN [SupportData].[MappingOperationComposition] as oc ON oc.MappingComposeOperationId = [OperationMappingChildId]
	  INNER JOIN [SupportData].[MappingResourceComposition] as rc ON rc.MappingComposeResourceId = [MappingComposeResourceChildId] 
	  WHERE oc.KTOP = @KTOP and AreaId = @AreaId
	RETURN
END
