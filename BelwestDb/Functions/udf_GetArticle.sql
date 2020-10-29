CREATE FUNCTION [dbo].[udf_GetArticle]
(

)
RETURNS @returntable TABLE
(
	[ArticleCode] varchar(30)
	,[ArticleName] varchar(50)
	,[ArticleVersion] int
	,[RoutCode] varchar(30)
	,[Specification] varchar(30)
	,[ArticleType] char(2)
	,[Unit] varchar(10)
)
AS
BEGIN
	INSERT @returntable
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

	INSERT @returntable
	SELECT Number_ AS [ArticleCode]
	,REPLACE(Number_,' ','_')  AS[ArticleName] 
	,0 AS [ArticleVersion]
	,NULL AS [RoutCode]
	,NULL AS [Specification]
	,'SF' AS [ArticleType]
	,'ПАРА' AS [Unit] 
	FROM [PreactorSDB].[InputData].[Nomenclature] AS nom
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle  = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
	
	
	INSERT @returntable
	SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS [ArticleCode]
	,sp.Title [ArticleName]
	,ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS [ArticleVersion]
	,REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))+'_' + CAST (ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS varchar(max)) AS [RoutCode]
	,NULL [Specification]
	,'SF' AS [ArticleType]
	,'ПАРА' AS [Unit] 
	FROM [PreactorSDB].[InputData].[SemiProducts] AS sp
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.SemiProductId = sp.IdSemiProduct
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
	
	INSERT @returntable
	SELECT CodeMaterial AS [ArticleCode]
	,mat.Title AS [ArticleName]
	,0 AS [ArticleVersion]
	,NULL AS [RoutCode]
	,NULL AS [Specification]
	,'MP' AS [ArticleType]
	,NEI AS [Unit] 
	FROM       [PreactorSDB].[InputData].[Material] AS mat
	INNER JOIN [PreactorSDB].[InputData].[Specifications] AS spec ON spec.MaterialId = mat.IdMaterial
	INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.IdOperation = spec.OperationId
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.IdRout = op.RoutId
	INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON ord.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[KEI] AS k ON k.KEI = spec.KEI
	


	RETURN
END
