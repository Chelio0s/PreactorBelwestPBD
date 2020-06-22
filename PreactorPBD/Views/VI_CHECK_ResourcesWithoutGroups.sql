CREATE VIEW [InputData].[VI_CHECK_ResourcesWithoutGroups]
	AS SELECT r.IdResource
  , Title
  , KOB 
  , DepartmentId
  , R.TitleWorkPlace
  FROM [InputData].[Resources]  AS R 
  LEFT JOIN [InputData].[ResourcesInGroups] RG on R.IdResource=RG.ResourceId
  WHERE RG.ResourceId is NULL