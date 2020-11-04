﻿CREATE FUNCTION [dbo].[udf_GetResourceFromSDB]
(

)
RETURNS @returntable TABLE
(
	ResourceGroupCode varchar(100) NOT NULL, 
    ResourceGroupName varchar(100) NOT NULL, 
    ResourceCode varchar(100) NOT NULL, 
    ResourceName varchar(100) NOT NULL, 
    DepartmentCode INT NOT NULL, 
    DepartmentName VARCHAR(100) NOT NULL
)
AS
BEGIN

	INSERT @returntable
	SELECT rg.IdResourceGroup AS ResourceGroupCode
	   ,CAST(rg.Title AS varchar(50)) AS ResourceGroupName 
	   ,r.IdResource AS ResourceCode
	   ,CAST(r.Title AS varchar(50)) AS ResourceName
	   ,dep.IdDepartment AS DepartmentCode
	   ,CAST(dep.Title AS varchar(50)) AS DepartmentName
  FROM [PreactorSDB].[InputData].[Resources] AS r
  INNER JOIN [PreactorSDB].[InputData].[ResourcesInGroups] AS rig ON rig.ResourceId = r.IdResource
  INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] AS rg ON rg.IdResourceGroup = rig.GroupResourcesId
  INNER JOIN [PreactorSDB].[SupportData].[DepartComposition] AS dc ON dc.ResourcesGroupId = rg.IdResourceGroup
  INNER JOIN [PreactorSDB].[InputData].[Departments] AS dep ON dep.IdDepartment = dc.DepartmentId


	RETURN
END