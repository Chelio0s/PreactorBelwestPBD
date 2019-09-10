CREATE PROCEDURE [InputData].[sp_InsertRoutes]

AS

DELETE FROM [InputData].[Rout]

--Инсерт ТМ с правилами
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)

SELECT DISTINCT
       'ТМ с набором операций '+CONVERT(NVARCHAR(10), [CombineRulesId]) AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,4
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]

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
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) and SimpleProductId in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17)


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

   print 'Создание переходящих маршрутов'
  ----Маппинг маршрутов для других цехов
DECLARE @aggregateOperations table ( article nvarchar(99), KTOPN int)
INSERT INTO @aggregateOperations
SELECT DISTINCT
	vi.Article
	,KTOPN 
FROM [InputData].[SemiProducts] as SP
INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as VI on VI.IdSemiProduct = SP.IdSemiProduct
WHERE vi.SimpleProductId = 18 and vi.Code = 'OP02'

DECLARE @aviableTable as Table ( Article nvarchar(99), CountKTOP_OP02 int, CountKTOP_OP61 int, CountKTOP_OP71 int, CountKTOP_OP81 int, CountKTOP_OP92 int
, RealCountKTOP_OP61 int, RealCountKTOP_OP71 int, RealCountKTOP_OP81 int, RealCountKTOP_OP09 int)
INSERT INTO @aviableTable
SELECT DISTINCT 
	Article
	,COUNT(KTOPN) as CountKTOP_OP02
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 9)) as CountKTOP_OP61
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 13)) as CountKTOP_OP71
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 14)) as CountKTOP_OP81
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 20)) as CountKTOP_OP92
	,(SELECT DISTINCT COUNT(KTOPN)		FROM [SupportData].[TempOperations] WHERE Article =  aggr.Article  AND KPO = 'П9147') as RealCountKTOP_OP61 
	,(SELECT DISTINCT COUNT(KTOPN)		FROM [SupportData].[TempOperations] WHERE Article =  aggr.Article  AND KPO = 'П9127') as RealCountKTOP_OP71 
	,(SELECT DISTINCT COUNT(KTOPN)		FROM [SupportData].[TempOperations] WHERE Article =  aggr.Article  AND KPO = 'П9128') as RealCountKTOP_OP81 
	,(SELECT DISTINCT COUNT(KTOPN)		FROM [SupportData].[TempOperations] WHERE Article =  aggr.Article  AND KPO = 'П9130') as RealCountKTOP_OP09
FROM @aggregateOperations as aggr
GROUP BY Article

--Создаем маршруты для 6/1 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
SELECT DISTINCT
'Альтернативный маршрут для цеха 6/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 9
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE (CountKTOP_OP02 = CountKTOP_OP61 or RealCountKTOP_OP61 <> 0) and visp.SimpleProductId = 18 

--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
SELECT DISTINCT
'Альтернативный маршрут для цеха 7/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 13
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE (CountKTOP_OP02 = CountKTOP_OP71 or RealCountKTOP_OP71 <> 0) and visp.SimpleProductId = 18 

--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
SELECT DISTINCT
'Альтернативный маршрут для цеха 8/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 14
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE ( CountKTOP_OP02 = CountKTOP_OP81 or RealCountKTOP_OP81 <> 0 ) and visp.SimpleProductId = 18 

--Создаем маршруты для 8 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
SELECT DISTINCT
'Альтернативный маршрут для цеха 9/2 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 20
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE (CountKTOP_OP02 = CountKTOP_OP92 or RealCountKTOP_OP09 <> 0) and visp.SimpleProductId = 18 

RETURN 0