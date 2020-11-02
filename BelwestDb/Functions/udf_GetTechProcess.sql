CREATE FUNCTION [dbo].[udf_GetTechProcess]
(
)
RETURNS @returntable TABLE
(
	 RoutCode varchar(30),
	 SemiProductName varchar(50),
	 OperationCode varchar(24),
	 OperationNumber char(4),
	 OperationNextNumber char(4),
	 OperationName varchar(100) 
)
AS
BEGIN
	INSERT @returntable
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
INNER JOIN (SELECT r.IdRout,
			REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))+'_' + CAST (ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS varchar(max)) AS [RoutCode]
			FROM [PreactorSDB].[InputData].[Rout] AS r
			INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON r.SemiProductId = sp.IdSemiProduct
			INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
			INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
			INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId) AS tabl ON tabl.IdRout = r.IdRout

	RETURN
END
