CREATE PROCEDURE [InputData].[sp_InsertMissedSpecificationSingleArticle]
	@article nvarchar(99)
AS
	 INSERT INTO [InputData].[Specifications]
	SELECT  mat.IdMaterial, SUM(CAST(REPLACE(matVi.NORMA,',','.') AS float))  AS Norma, IdOperation AS OperationId, KEI FROM (
SELECT DISTINCT  art.Title AS Ntitle, op.*
,sp.SimpleProductId
,FIRST_VALUE(NumberOp) OVER (PARTITION BY art.IdArticle ORDER BY NumberOp) AS NewNomOp
,FIRST_VALUE(SimpleProductId) OVER(PARTITION BY art.IdArticle ORDER BY SimpleProductId) AS NewSimpleProduct
FROM [InputData].[Operations] AS op
    INNER JOIN [InputData].[Rout] AS r ON op.RoutId = r.IdRout
    INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
    INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
    INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
    INNER JOIN [InputData].[VI_ArticlesWithoutMaterials] AS vi ON vi.IdArticle = art.IdArticle
    ) AS tabl
    INNER JOIN [InputData].[VI_MissingMaterialsFromNSI] AS matVi ON tabl.Ntitle = matVi.ART collate Cyrillic_General_BIN
    INNER JOIN [InputData].[Material] AS mat ON mat.Title = matVi.TITLE
    WHERE NumberOp = NewNomOp
    AND NewSimpleProduct = SimpleProductId
    AND matVi.NORMA IS NOT NULL
    AND Ntitle = @article
    GROUP BY IdMaterial, IdOperation, NTITLE, KEI
    ORDER BY OperationId
RETURN 0
