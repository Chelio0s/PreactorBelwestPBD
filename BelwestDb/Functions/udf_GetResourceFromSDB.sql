CREATE FUNCTION [dbo].[udf_GetResourceFromSDB]
(

)
RETURNS @returntable TABLE
(
	ILOT varchar(100), 
    LIBILOT varchar(100), 
    MACHINE varchar(100), 
    LIBMACH varchar(100), 
    CODESECTI INT, 
    LIBSECTI VARCHAR(100)
)
AS
BEGIN

	INSERT @returntable
	SELECT rg.IdResourceGroup AS ILOT
	   ,CAST(rg.Title AS varchar(50)) AS LIBILOT 
	   ,r.IdResource AS MACHINE
	   ,CAST(r.Title AS varchar(50)) AS LIBMACH
	   ,dep.IdDepartment AS CODESECTI
	   ,CAST(dep.Title AS varchar(50)) AS LIBSECTI
  FROM [PreactorSDB].[InputData].[Resources] AS r
  INNER JOIN [PreactorSDB].[InputData].[ResourcesInGroups] AS rig ON rig.ResourceId = r.IdResource
  INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] AS rg ON rg.IdResourceGroup = rig.GroupResourcesId
  INNER JOIN [PreactorSDB].[SupportData].[DepartComposition] AS dc ON dc.ResourcesGroupId = rg.IdResourceGroup
  INNER JOIN [PreactorSDB].[InputData].[Departments] AS dep ON dep.IdDepartment = dc.DepartmentId


	RETURN
END
