CREATE PROCEDURE [InputData].[sp_GetAlterRoutsOtherPlaces]
AS
	  ----Маппинг маршрутов для других цехов
DECLARE @aggregateOperations table ( article nvarchar(99), KTOPN int)
INSERT INTO @aggregateOperations
SELECT DISTINCT
	vi.Article
	,KTOPN 
FROM [InputData].[SemiProducts] as SP
INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as VI on VI.IdSemiProduct = SP.IdSemiProduct
WHERE vi.SimpleProductId = 18 and vi.Code = 'OP02'

DECLARE @aviableTable as Table ( Article nvarchar(99), CountKTOP_OP02 int, CountKTOP_OP61 int, CountKTOP_OP71 int, CountKTOP_OP81 int, CountKTOP_OP92 int)
INSERT INTO @aviableTable
SELECT DISTINCT 
	Article
	,COUNT(KTOPN) as CountKTOP_OP02
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 9)) as CountKTOP_OP61
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 13)) as CountKTOP_OP71
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 14)) as CountKTOP_OP81
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 20)) as CountKTOP_OP92
FROM @aggregateOperations

GROUP BY Article

SELECT * FROM @aviableTable

SELECT DISTINCT
'Альтернативный маршрут для цеха 6/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 9
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE CountKTOP_OP02 = CountKTOP_OP61 and visp.SimpleProductId = 18

SELECT DISTINCT
'Альтернативный маршрут для цеха 7/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 13
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE CountKTOP_OP02 = CountKTOP_OP71 and visp.SimpleProductId = 18

SELECT DISTINCT
'Альтернативный маршрут для цеха 8/1 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 14
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE CountKTOP_OP02 = CountKTOP_OP81 and visp.SimpleProductId = 18


SELECT DISTINCT
'Альтернативный маршрут для цеха 9/2 для ПФ: '+ CONVERT(nvarchar(15), IdSemiProduct)
, IdSemiProduct
, 10
, NULL
, 20
FROM [InputData].[VI_SemiProductsWithArticles] as visp
INNER JOIN @aviableTable  as aggr ON aggr.article = visp.TitleArticle COLLATE Cyrillic_General_CI_AS
WHERE CountKTOP_OP02 = CountKTOP_OP92 and visp.SimpleProductId = 18
RETURN 0
