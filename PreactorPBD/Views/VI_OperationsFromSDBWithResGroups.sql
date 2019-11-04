--Операции из ПБД с группами оборудования, на котором эти операции делаются

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
	  ,operktop.[TimeMultiply]
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
 
  