CREATE FUNCTION [dbo].[udf_GetFullOperation]
(
)
RETURNS @returntable TABLE
(
	RoutCode varchar(30),
	RoutName varchar(100),
	OperationCode varchar(100),
	OperationName varchar(100),
	ResourceGroupCode varchar(100),
	ResourceCode varchar(100),
	Unit varchar(10),
	Performance Numeric (10,3),
    RUC int,
	TPZ Numeric (4,3),
	PriorityOnResource varchar(10)
)
AS
BEGIN
	INSERT @returntable
	SELECT 
r.IdRout AS RoutCode
,r.Title AS RoutName
,KTOP AS OperationCode  
,op.Title AS OperationName
,rg.IdResourceGroup AS ResourceGroupCode
,res.IdResource AS ResourceCode
,'ЧАС' AS Unit
,CAST(ROUND((1 / (opinres.OperateTime / 60)), 2) AS Numeric(10,3)) AS Performance
,10 AS RUC
,NULL AS TPZ
,5 AS PriorityOnResource
FROM 
[PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON r.IdRout = op.RoutId
INNER JOIN [PreactorSDB].[InputData].[OperationInResource] AS opinres  ON opinres.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Resources] AS res ON res.IdResource = opinres.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesInGroups] AS rig ON res.IdResource = rig.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] AS rg ON rg.IdResourceGroup = rig.GroupResourcesId
INNER JOIN [PreactorSDB].[InputData].[OperationWithKTOP] AS owk ON owk.OperationId = op.IdOperation
	RETURN
END
