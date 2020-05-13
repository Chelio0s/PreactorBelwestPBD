CREATE VIEW [InputData].[VI_ResourcesInGroups]
	AS
    SELECT DISTINCT [IdResource]
      ,res.[Title]                              AS ResTitle
      ,[TitleWorkPlace]
      ,res.[DepartmentId]
      ,res.[KOB]
	  ,Rg.Title									AS ResGrTitle
	  ,Rg.IdResourceGroup
  FROM [InputData].[Resources]					AS Res
  INNER JOIN [SupportData].[DepartComposition]	AS Dc	ON Dc.DepartmentId = res.DepartmentId
  INNER JOIN [InputData].[ResourcesGroup]		AS Rg   ON rg.IdResourceGroup = Dc.ResourcesGroupId
  INNER JOIN [SupportData].[GroupKOB]			AS Gr	ON Gr.GroupId = Rg.IdResourceGroup 
														AND Gr.KOB = res.KOB
														