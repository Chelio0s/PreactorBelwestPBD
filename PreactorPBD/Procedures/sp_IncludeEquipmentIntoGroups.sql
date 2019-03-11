CREATE PROCEDURE [InputData].[sp_IncludeEquipmentIntoGroups]

AS

TRUNCATE TABLE [InputData].[ResourcesInGroups]
INSERT INTO [InputData].[ResourcesInGroups]
           ([GroupResourcesId]
           ,[ResourceId])
SELECT distinct

 gr.GroupId
 ,res.IdResource

  FROM [PreactorSDB].[SupportData].[DepartComposition] as depcom 
  INNER JOIN [PreactorSDB].[SupportData].[GroupKOB] as gr ON gr.GroupId = depcom.ResourcesGroupId
  INNER JOIN [PreactorSDB].[InputData].[Resources] as res ON res.KOB = gr.KOB and res.DepartmentId = depcom.DepartmentId
  INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] as resgr ON resgr.IdResourceGroup = gr.GroupId

  ORDER BY gr.GroupId

RETURN 0
