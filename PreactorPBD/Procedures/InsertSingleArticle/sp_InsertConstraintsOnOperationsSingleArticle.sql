CREATE PROCEDURE [InputData].[sp_InsertConstraintsOnOperationsSingleArticle]
	@article nvarchar(99)
AS
	
    DELETE [InputData].[UseConstraintOperations] 
    FROM [InputData].[UseConstraintOperations]              AS useop
    INNER JOIN [InputData].[Operations]                     AS Oper     ON Oper.IdOperation = useop.OperationId
    INNER JOIN [InputData].[Rout]					        AS R		ON R.IdRout = Oper.RoutId
    INNER JOIN [InputData].[VI_SemiProductsWithArticles]	AS VISEMI	ON VISEMI.IdSemiProduct = R.SemiProductId
    WHERE VISEMI.TitleArticle = @article

INSERT INTO [InputData].[UseConstraintOperations]
	SELECT [IdOperation]
       ,SC.IdSecondaryConstraint
	   ,UseCount
	   ,1
  FROM [InputData].[Operations]							AS Oper
  INNER JOIN [InputData].[Rout]							AS R		ON R.IdRout = Oper.RoutId
  INNER JOIN [InputData].[VI_SemiProductsWithArticles]	AS VISEMI	ON VISEMI.IdSemiProduct = R.SemiProductId
  INNER JOIN [SupportData].[ArticleModels]				AS AM		ON AM.AticleId = VISEMI.ArticleId
  LEFT JOIN  [InputData].[OperationWithKTOP]			AS OperKtp	ON Oper.IdOperation = OperKtp.OperationId
  INNER JOIN [SupportData].[CuttersForKTOPs]			AS CuttKtop	ON CuttKtop.KTOP = OperKtp.KTOP
  INNER JOIN [SupportData].[CuttersRaw]					AS CR		ON CR.[Model] = AM.Model 
																	AND CuttKtop.TypeCutterId = CR.TypeCutterId
  INNER JOIN [InputData].[SecondaryConstraints]			AS SC		ON Sc.TypeId = 1 
																	AND SC.Param = [IdCutterRaw]
  WHERE AM.Article = @article
RETURN 0
