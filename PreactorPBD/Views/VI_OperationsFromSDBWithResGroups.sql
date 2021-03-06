﻿--Операции из ПБД с группами оборудования, на котором эти операции делаются

CREATE VIEW [InputData].[VI_OperationsFromSDBWithResGroups]
	AS 
SELECT [IdOperation]
      ,oper.[Title]
      ,[NumberOp]
      ,[RoutId]
	  ,rout.Title															AS RoutTitle
	  ,sp.IdSemiProduct
	  ,sp.Title																AS SPtitle
      ,[ProfessionId]
      ,[TypeTimeId]
	  ,typetime.TitleRus													AS TypetypeTitleRus
      ,oper.[CategoryOperation]
      ,oper.[Code]
	  ,[InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId) AS KTOP
	  ,groupkob.GroupId
	  ,resgr.Title															AS ResGrTitle
	  ,groupkob.AreaId
	  ,groupkob.KOB
	  ,vifast.NORMATIME 
	  ,res.IdResource
	  ,res.Title												AS ResTitle
  FROM [InputData].[Operations]									AS oper 
  INNER JOIN [InputData].[Areas]								AS area		ON area.Code = oper.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [InputData].[OperationWithKTOP]					AS operktop ON oper.IdOperation = operktop.[OperationId]
  INNER JOIN [InputData].[Rout]									AS rout		ON rout.IdRout = oper.RoutId
  INNER JOIN [InputData].[SemiProducts]							AS sp		ON sp.IdSemiProduct = rout.SemiProductId
  INNER JOIN [SupportData].[GroupKOB]							AS groupkob ON groupkob.KTOPN = [InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId)
																			AND area.IdArea = groupkob.AreaId
  INNER JOIN [InputData].[ResourcesGroup]						AS resgr	ON resgr.IdResourceGroup = groupkob.GroupId
  INNER JOIN [InputData].[ResourcesInGroups]					AS resingr	ON resingr.GroupResourcesId = resgr.IdResourceGroup
  INNER JOIN [InputData].[Resources]							AS res		ON res.IdResource = resingr.ResourceId AND groupkob.KOB = res.KOB
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.IdSemiProduct = rout.SemiProductId
																			AND vifast.KTOPN = operktop.KTOP
  INNER JOIN [InputData].TypeTimes								AS typetime ON typetime.IdTypeTime = TypeTimeId

  --Для автоматических ТМ 9/1
  UNION
  SELECT DISTINCT [IdOperation]
      ,oper.[Title]
      ,[NumberOp]
      ,[RoutId]
	  ,rout.Title															AS RoutTitle
	  ,sp.IdSemiProduct
	  ,sp.Title																AS SPtitle
      ,[ProfessionId]
      ,[TypeTimeId]
	  ,typetime.TitleRus													AS TypetypeTitleRus
      ,oper.[CategoryOperation]
      ,oper.[Code]
	  ,[InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId) AS KTOP
	  ,groupkob.GroupId
	  ,resgr.Title															AS ResGrTitle
	  ,groupkob.AreaId
	  ,groupkob.KOB
	  ,fn.NormaTimeNew 
	  ,res.IdResource
	  ,res.Title													AS ResTitle
  FROM [InputData].[Operations]										AS oper 
  INNER JOIN [InputData].[Areas]									AS area		ON area.Code = oper.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [InputData].[OperationWithKTOP]						AS operktop ON oper.IdOperation = operktop.[OperationId]
  INNER JOIN [InputData].[Rout]										AS rout		ON rout.IdRout = oper.RoutId
  INNER JOIN [InputData].[SemiProducts]								AS sp		ON sp.IdSemiProduct = rout.SemiProductId
  INNER JOIN [SupportData].[GroupKOB]								AS groupkob ON groupkob.KTOPN = [InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId)
																			    AND area.IdArea = groupkob.AreaId
  INNER JOIN [InputData].[ResourcesGroup]							AS resgr	ON resgr.IdResourceGroup = groupkob.GroupId
  INNER JOIN [InputData].[ResourcesInGroups]						AS resingr	ON resingr.GroupResourcesId = resgr.IdResourceGroup
  INNER JOIN [InputData].[Resources]								AS res		ON res.IdResource = resingr.ResourceId AND groupkob.KOB = res.KOB
  CROSS APPLY [InputData].[ctvf_GetAltRouteForFirstFloor]([RoutId]) AS fn       
  INNER JOIN [InputData].TypeTimes									AS typetime ON typetime.IdTypeTime = TypeTimeId
  WHERE (KTOP = KTOPChild AND KOBChild = groupkob.KOB) 
  AND oper.IsMappingRule = 1 
  AND oper.[Code] = 'OP09' and rout.AreaId = 8
  AND rout.IsAutoGenerated = 1 -- флаг, что ТМ автоматический
  -- Для переходящих ТМ 6/1 7/1 8/1 9/2
  UNION 
  SELECT DISTINCT [IdOperation]
      ,oper.[Title]
      ,[NumberOp]
      ,[RoutId]
	  ,rout.Title															AS RoutTitle
	  ,sp.IdSemiProduct
	  ,sp.Title																AS SPtitle
      ,[ProfessionId]
      ,[TypeTimeId]
	  ,typetime.TitleRus													AS TypetypeTitleRus
      ,oper.[CategoryOperation]
      ,oper.[Code]
	  ,[InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId) AS KTOP
	  ,groupkob.GroupId
	  ,resgr.Title															AS ResGrTitle
	  ,groupkob.AreaId
	  ,groupkob.KOB
	  ,tempMap.NORMATIME 
	  ,res.IdResource
	  ,res.Title													AS ResTitle
  FROM [InputData].[Operations]										AS oper 
  INNER JOIN [InputData].[Areas]									AS area		ON area.Code = oper.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [InputData].[OperationWithKTOP]						AS operktop ON oper.IdOperation = operktop.[OperationId]
  INNER JOIN [InputData].[Rout]										AS rout		ON rout.IdRout = oper.RoutId
  INNER JOIN [InputData].[SemiProducts]								AS sp		ON sp.IdSemiProduct = rout.SemiProductId
  INNER JOIN [SupportData].[GroupKOB]								AS groupkob ON groupkob.KTOPN = [InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId)
																			    AND area.IdArea = groupkob.AreaId
  INNER JOIN [InputData].[ResourcesGroup]							AS resgr	ON resgr.IdResourceGroup = groupkob.GroupId
  INNER JOIN [InputData].[ResourcesInGroups]						AS resingr	ON resingr.GroupResourcesId = resgr.IdResourceGroup
  INNER JOIN [InputData].[Resources]								AS res		ON res.IdResource = resingr.ResourceId AND groupkob.KOB = res.KOB
  INNER JOIN [SupportData].[TempOperationForMapping]				AS tempMap	ON tempMap.IdRoute = rout.IdRout 
																	AND tempMap.KTOPN = operktop.KTOP
  INNER JOIN [InputData].TypeTimes									AS typetime ON typetime.IdTypeTime = TypeTimeId
  WHERE oper.IsMappingRule = 1 
  AND oper.[Code] in ('OP61','OP71','OP81','OP92') and rout.AreaId in (9,13,14,20)