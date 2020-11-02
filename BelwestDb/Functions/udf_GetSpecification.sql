CREATE FUNCTION [dbo].[udf_GetSpecification]
(

)
RETURNS @returntable TABLE
(
	[ArticleCode] varchar(30)
	,[ArticleName] varchar(100)
	,[SpecificationName] varchar(30)
	,[RoutCode] varchar(30)
	,[MaterialCode] varchar(30)
	,[MaterialName] varchar(100)
	,[BaseCount] numeric(10,3)
	,[IncludeCount] numeric(10,3)
	,[EngagementPhase] char(4)
)
AS
BEGIN
	INSERT @returntable
		SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS [ArticleCode]
	,sp.Title [ArticleName]
	,NULL AS [SpecificationName]
	,REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))+'_' + CAST (ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS varchar(max)) AS [RoutCode]
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
	RETURN
END
