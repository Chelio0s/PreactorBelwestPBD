CREATE PROCEDURE [dbo].[sp_InsertAll]
AS
TRUNCATE TABLE Article
TRUNCATE TABLE Operation
TRUNCATE TABLE Resources
TRUNCATE TABLE Specification
TRUNCATE TABLE TechProcess

DECLARE @routs AS TABLE (
IdRout int, 
RoutCode varchar(50),
ArtVersion int
)
INSERT @routs
SELECT r.IdRout,
REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))+'_' + CAST (ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS varchar(max)) AS [RoutCode],
ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS ArtVersion
FROM [PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON r.SemiProductId = sp.IdSemiProduct
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId


	print('Загрузка артикулов')
	--Артикула 
	INSERT Article
	SELECT 
	art.Title AS [ArticleCode]
	,art.Title AS[ArticleName]
	,0 AS [ArticleVersion]
	,NULL AS [RoutCode]
	,NULL AS [Specification]
	,'PF' AS [ArticleType]
	,'ПАРА' AS [Unit] 
	FROM [PreactorSDB].[InputData].[Article] AS art
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId

	--Номенклатура
	INSERT Article
	SELECT REPLACE(Number_,' ','_') AS [ArticleCode]
	,REPLACE(Number_,' ','_')  AS[ArticleName] 
	,0 AS [ArticleVersion]
	,NULL AS [RoutCode]
	,NULL AS [Specification]
	,'SF' AS [ArticleType]
	,'ПАРА' AS [Unit] 
	FROM [PreactorSDB].[InputData].[Nomenclature] AS nom
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle  = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId

	--ПФ 
	INSERT Article
	SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS [ArticleCode]
	,sp.Title [ArticleName]
	,rt.ArtVersion AS [ArticleVersion]
	,rt.RoutCode AS [RoutCode]
	,NULL [Specification]
	,'SF' AS [ArticleType]
	,'ПАРА' AS [Unit] 
	FROM [PreactorSDB].[InputData].[SemiProducts] AS sp
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.SemiProductId = sp.IdSemiProduct
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
	INNER JOIN @routs AS rt ON rt.IdRout = r.IdRout
	--Материалы
	INSERT Article
	SELECT DISTINCT CodeMaterial AS [ArticleCode]
	,mat.Title AS [ArticleName]
	,0 AS [ArticleVersion]
	,NULL AS [RoutCode]
	,NULL AS [Specification]
	,'MP' AS [ArticleType]
	,NEI AS [Unit] 
	FROM    [PreactorSDB].[InputData].[Material] AS mat
	INNER JOIN [PreactorSDB].[InputData].[Specifications] AS spec ON spec.MaterialId = mat.IdMaterial
	INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.IdOperation = spec.OperationId
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.IdRout = op.RoutId
	INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON ord.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[KEI] AS k ON k.KEI = spec.KEI
	INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout

	print('Загрузка ресурсов')
	INSERT Resources
	SELECT * FROM udf_GetResourceFromSDB();

	print('Загрузка операций')
	INSERT Operation
	SELECT
	tabl.RoutCode AS [RoutCode]
,r.Title AS RoutName
,KTOP AS OperationCode  
,op.Title AS OperationName
,rg.IdResourceGroup AS ResourceGroupCode
,res.IdResource AS ResourceCode
,'ЧАС' AS Unit
,CAST(ROUND((60 / opinres.OperateTime), 2) AS Numeric(10,3)) AS Performance
,10 AS RUC
,NULL AS TPZ
,5 AS PriorityOnResource
FROM 
[PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON r.SemiProductId = sp.IdSemiProduct
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON r.IdRout = op.RoutId
INNER JOIN [PreactorSDB].[InputData].[OperationInResource] AS opinres  ON opinres.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Resources] AS res ON res.IdResource = opinres.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesInGroups] AS rig ON res.IdResource = rig.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] AS rg ON rg.IdResourceGroup = rig.GroupResourcesId
INNER JOIN [PreactorSDB].[InputData].[OperationWithKTOP] AS owk ON owk.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout

	print('Загрузка техпроцессов')
	INSERT TechProcess
	SELECT 
tabl.RoutCode AS RoutCode
,sp.Title AS SemiProductName
,owk.KTOP AS OperationCode
,op.NumberOp AS OperationNumber
,LEAD(op.NumberOp) OVER(PARTITION BY op.RoutId ORDER BY op.NumberOp) AS OperationNextNumber
,op.Title AS OperationName
FROM [PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId 
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.RoutId = R.IdRout
INNER JOIN [PreactorSDB].[InputData].[OperationWithKTOP] AS owk ON owk.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout
WHERE  owk.KTOP not in (5580, 5494)


	print('Загрузка спецификаций')
	INSERT Specification
SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS [ArticleCode]
	,sp.Title [ArticleName]
	,NULL AS [SpecificationName]
	,tabl.RoutCode AS [RoutCode]
	,CodeMaterial AS [MaterialCode]
	,mat.Title AS [MaterialName]
	,1 AS [BaseCount]
	,spec.Norma AS [IncludeCount]
	,op.NumberOp AS [EngagementPhase]
	FROM       [PreactorSDB].[InputData].[Material] AS mat
	INNER JOIN [PreactorSDB].[InputData].[Specifications] AS spec ON spec.MaterialId = mat.IdMaterial
	INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.IdOperation = spec.OperationId
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.IdRout = op.RoutId
	INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON ord.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[KEI] AS k ON k.KEI = spec.KEI
	INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout


RETURN 0
