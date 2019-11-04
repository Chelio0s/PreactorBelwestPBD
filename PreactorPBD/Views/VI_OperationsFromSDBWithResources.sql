CREATE VIEW [InputData].[VI_OperationsFromSDBWithResources]
	AS SELECT TOP 100 PERCENT [IdOperation]
      ,[ArtTitle]
      ,[Size]
      ,[Nomenclature]
      ,[OperTitle]
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTimeId]
      ,[CategoryOperation]
      ,[Code]
      ,[IdSemiProduct]
      ,[SimpleProductId]
	  ,res.KOB
	  ,res.DepartmentId
	  ,dep.Title
	  ,count (res.KOB) AS CountRes 
  FROM  [InputData].[VI_OperationsFromSDB]							AS vi
  LEFT JOIN [InputData].[OperationInResource]						AS operinres	ON operinres.OperationId = vi.IdOperation
  LEFT JOIN [InputData].[Resources]									AS res			ON res.IdResource = operinres.ResourceId
  LEFT JOIN [InputData].[Departments]								AS dep			ON dep.IdDepartment = res.DepartmentId

  group by [IdOperation]
      ,[ArtTitle]
      ,[Size]
      ,[Nomenclature]
      ,[OperTitle]
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTimeId]
      ,[CategoryOperation]
      ,[Code]
      ,[IdSemiProduct]
      ,[SimpleProductId]
	  ,res.KOB
	  ,res.DepartmentId
	  ,dep.Title
  ORDER BY ArtTitle,  Size, Code
