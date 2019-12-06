CREATE PROCEDURE [InputData].[sp_InsertRoutes]

AS

DELETE FROM [InputData].[Rout]

--Инсерт ТМ с правилами для заготовки цех 2
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)

SELECT DISTINCT
       'ТМ с набором операций '+CONVERT(NVARCHAR(10), [CombineRulesId]) + ' цех 2' AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,4
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = [SemiProductId]
  WHERE sp.SimpleProductId in (18,19)

  --Инсерт ТМ всех остальных для 2 цеха
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 2'
  , IdSemiProduct
  ,10
  ,NULL
  ,4
  FROM [InputData].[SemiProducts]
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) and SimpleProductId in (18, 19)


  --Инсерт ТМ с правилами для кроя цех 1
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)

SELECT DISTINCT
       'ТМ с набором операций '+CONVERT(NVARCHAR(10), [CombineRulesId]) + ' цех 1' AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,3
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = [SemiProductId]
  WHERE sp.SimpleProductId in (1)

  --Инсерт ТМ для кроя для 1 цеха для остальных артикулов, у которых нет ТМ с правилами
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 1'
  , IdSemiProduct
  ,10
  ,NULL
  ,3
  FROM [InputData].[SemiProducts]
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) and SimpleProductId in (1)



   --Инсерт ТМ всех остальных для других цехов
   --Инсерт ТМ с правилами
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 1'
  , IdSemiProduct
  ,10
  ,NULL
  ,3
  FROM [InputData].[SemiProducts]
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) and SimpleProductId in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,17)

  -- Стандартный ТМ для 9/1 - тот что есть в РКВ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT DISTINCT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 9/1'
  , IdSemiProduct
  ,10
  ,NULL
  ,8
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi 
  INNER JOIN [InputData].[Areas] as area ON area.Code = vi.Code COLLATE Cyrillic_General_BIN
  WHERE vi.Code in ('OP09') AND vi.SimpleProductId in (1,2,3,4,5,6,7,8,9,10,11,12,13,15,17) AND IdArea > 8

  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 3'
  , IdSemiProduct
  ,10
  ,NULL
  ,5
  FROM [InputData].[SemiProducts]
  WHERE  SimpleProductId in (20)

    INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 4'
  , IdSemiProduct
  ,10
  ,NULL
  ,6
  FROM [InputData].[SemiProducts]
  WHERE SimpleProductId in (20)

      INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)+ ' цех 5'
  , IdSemiProduct
  ,10
  ,NULL
  ,7
  FROM [InputData].[SemiProducts]
  WHERE SimpleProductId in (19)

  -- создание ТМ для 6 7 8 9 цехов (стандартные ТМ) т.е. такие ТМ есть в РКВ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
  SELECT DISTINCT 
  'Cтандартный маршрут для цеха ' + area.Title+ ' для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
     ,IdSemiProduct
     ,10
	 ,NULL
	 ,area.IdArea
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi 
  INNER JOIN [InputData].[Areas] as area ON area.Code = vi.Code COLLATE Cyrillic_General_BIN
  WHERE vi.Code in ('OP61', 'OP71', 'OP81', 'OP09') AND vi.SimpleProductId = 18 AND IdArea > 8

print 'Создание авто переходящих маршрутов'
----Маппинг маршрутов для других цехов

 -- АВТО ТМ для 9/1  - МАППИНГ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId
		   ,IsAutoGenerated
		   ,ParentRouteId)
  SELECT DISTINCT 'Автоматический ТМ для ПФ '+ CONVERT(NVARCHAR(10), SemiProductId)+ ' цех 9/1'
  ,SemiProductId 
  ,10
  ,NULL
  ,8
  ,1
  ,R.IdRout
  FROM [InputData].[Rout]					AS R  
  INNER JOIN [InputData].[SemiProducts]		AS SP ON SP.IdSemiProduct = R.SemiProductId
  INNER JOIN [InputData].[Nomenclature]		AS N  ON N.IdNomenclature = SP.NomenclatureID
  WHERE R.AreaId = 3 
  AND  SimpleProductId in (1,2,3,4,5,6,7,8,9,10,11,12,13,15) 
  AND (SemiProductId NOT IN (SELECT ROUT.SemiProductId FROM [InputData].[Rout] AS ROUT WHERE ROUT.AreaId = 8))
  AND [InputData].[udf_CanIMapFirstFloorRoute](R.IdRout) = CONVERT(bit, 'true')
 

  --Создаем маршруты для 6/1 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' +  CONVERT(nvarchar(15), IdRout) +  ' для цеха 6/1 для ПФ: '+ CONVERT(nvarchar(15), SemiProductId)
, SemiProductId
, 10
, NULL
, 9
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 9)	AS ICan 
		  FROM  [InputData].[Rout] as R
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP61')
		  AND AreaId = 4
) as t
WHERE  ICan = 1

--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' +  CONVERT(nvarchar(15), IdRout) +  ' для цеха 7/1 для ПФ: '+ CONVERT(nvarchar(15), SemiProductId)
, SemiProductId
, 10
, NULL
, 13
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 13)	AS ICan 
		  FROM  [InputData].[Rout] as R
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP71')
		  AND AreaId = 4
) as t
WHERE  ICan = 1


--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' +  CONVERT(nvarchar(15), IdRout) +  ' для цеха 8/1 для ПФ: '+ CONVERT(nvarchar(15), SemiProductId)
, SemiProductId
, 10
, NULL
, 14
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 14)	AS ICan 
		  FROM  [InputData].[Rout] as R
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP81')
		  AND AreaId = 4
) as t
WHERE  ICan = 1


--Создаем маршруты для 9/2 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' +  CONVERT(nvarchar(15), IdRout) +  ' для цеха 9/2 для ПФ: '+ CONVERT(nvarchar(15), SemiProductId)
, SemiProductId
, 10
, NULL
, 20
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 20)	AS ICan 
		  FROM  [InputData].[Rout] as R
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP09')
		  AND AreaId = 4
) as t
WHERE  ICan = 1

RETURN 0