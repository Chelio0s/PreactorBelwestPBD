--Операции из ПБД с группами оборудования, на котором эти операции делаются

CREATE VIEW [InputData].[VI_OperationsSDBWithResGroups]
	AS 
	SELECT DISTINCT [IdOperation]
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
	  ,vifast.REL

  FROM		 [InputData].[VI_OperationsFromSDB]					AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND vifast.Code = opersdb.Code
  INNER JOIN [InputData].[Areas]								AS area		ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup ON  resgroup.IdResourceGroup = groupkob.GroupId
  --Присоеденяем операции цеха 6/1 которые мы сами делали
  UNION
    SELECT DISTINCT 
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
	  ,vifast.REL
  FROM		 [InputData].[VI_OperationsFromSDB]					AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND  opersdb.Code = 'OP61'
  INNER JOIN [InputData].[Areas]								AS area		ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup ON  resgroup.IdResourceGroup = groupkob.GroupId
  WHERE Article not in (SELECT DISTINCT Article					
						  FROM		[InputData].[VI_OperationsWithSemiProducts_FAST] 				AS opersdb
						  WHERE code = 'OP61') 
   --Присоеденяем операции цеха 7/1 которые мы сами делали
   UNION
    SELECT DISTINCT 
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
	  ,vifast.REL

  FROM		 [InputData].[VI_OperationsFromSDB]					AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND  opersdb.Code = 'OP71'
  INNER JOIN [InputData].[Areas]								AS area		ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup ON  resgroup.IdResourceGroup = groupkob.[GroupId]
  WHERE Article not in (SELECT DISTINCT Article					
						  FROM		[InputData].[VI_OperationsWithSemiProducts_FAST] 				AS opersdb
						  WHERE code = 'OP71') 
   --Присоеденяем операции цеха 8/1 которые мы сами делали
   UNION
    SELECT DISTINCT 
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
	  ,vifast.REL

  FROM		 [InputData].[VI_OperationsFromSDB]					AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND  opersdb.Code = 'OP81'
  INNER JOIN [InputData].[Areas]								AS area		ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup ON  resgroup.IdResourceGroup = groupkob.[GroupId]
  WHERE Article not in (SELECT DISTINCT Article					
						  FROM		[InputData].[VI_OperationsWithSemiProducts_FAST] 				AS opersdb
						  WHERE code = 'OP81') 
   --Присоеденяем операции цеха 9/2 которые мы сами делали
   UNION
    SELECT DISTINCT 
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
	  ,vifast.REL

  FROM		 [InputData].[VI_OperationsFromSDB]					AS opersdb
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast	ON vifast.TitlePreactorOper = opersdb.OperTitle 
																		AND vifast.IdSemiProduct = opersdb.IdSemiProduct
																		AND  opersdb.Code = 'OP09'
  INNER JOIN [InputData].[Areas]								AS area		ON  area.Code = opersdb.Code COLLATE Cyrillic_General_BIN
  LEFT JOIN  [SupportData].[GroupKOB]							AS groupkob ON  groupkob.KTOPN = vifast.KTOPN 
																		AND groupkob.AreaId = area.IdArea -- По идее это мы выбираем группу для цеха для которого маршрут
  LEFT JOIN  [InputData].[ResourcesGroup]						AS resgroup ON  resgroup.IdResourceGroup = groupkob.[GroupId]
  
  WHERE Article not in (SELECT DISTINCT Article					
						  FROM		[InputData].[VI_OperationsWithSemiProducts_FAST] 				AS opersdb
						  WHERE code = 'OP09') 