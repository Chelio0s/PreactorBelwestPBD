-- Операции ПБД с конкретными рессурсами
-- Сырая выборка, то как оно выбирается из множетства таблиц 
-- Перед инсертов в OperationsInResources
CREATE VIEW [InputData].[VI_OperationsSDBWithConcreetResources]
	AS SELECT DISTINCT 
	  [IdOperation]
      ,[ArtTitle]
      ,opersdb.[Size]
      ,opersdb.[Nomenclature]	
	  ,opersdb.RoutId									
	  ,opersdb.Code
      ,[OperTitle]
      ,[NumberOp]
      ,[ProfessionId]
      ,[TypeTime]
      ,opersdb.[CategoryOperation]
      ,opersdb.[IdSemiProduct]
      ,opersdb.[SimpleProductId]
	  ,vifast.KTOPN
	  ,vifast.KOB
	  ,resgroup.IdResourceGroup
	  ,resgroup.Title											AS ResourceGroupTitle
	  ,res.IdResource
	  ,res.Title
	  ,vifast.NORMATIME
  FROM [InputData].[VI_OperationsFromSDB]						AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast		ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND vifast.Code = opersdb.Code
  INNER JOIN [InputData].[Areas]								AS area			ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob		ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup		ON  resgroup.IdResourceGroup = groupkob.[GroupId]
  INNER JOIN [InputData].[Departments]							AS dep			ON  dep.AreaId = area.IdArea
  INNER JOIN [SupportData].[DepartComposition]					AS depCompose	ON 	depCompose.ResourcesGroupId = resgroup.IdResourceGroup
  INNER JOIN [InputData].[Resources]							AS res			ON  res.DepartmentId = depCompose.DepartmentId
																		AND res.KOB = vifast.KOB
