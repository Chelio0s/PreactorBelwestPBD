CREATE PROCEDURE [InputData].[sp_InsertCombinesSingleArticle]
	@article nvarchar(10)
AS

	DELETE [SupportData].[CombineRules] 
	FROM [SupportData].[CombineRules] as cp
	INNER JOIN [InputData].[VI_SemiProductsWithArticles] as vi ON vi.IdSemiProduct = cp.SemiProductId
	WHERE vi.TitleArticle = @article

	DECLARE @FilteredTable as table (IdSemiProduct int NOT NULL)
    INSERT INTO @FilteredTable
    SELECT sp.[IdSemiProduct]
    FROM [InputData].[SemiProducts] as sp
    INNER JOIN [InputData].[VI_SemiProductsWithArticles] as vi ON vi.IdSemiProduct = sp.IdSemiProduct
    --Просееваем заведомо не нужные ПФ (для которых нет RULES)
    WHERE vi.TitleArticle = @article 
         AND sp.SimpleProductId IN (SELECT DISTINCT
								   [SimpleProductId]
							  FROM [SupportData].[SequenceOperations] as sq
							  INNER JOIN [SupportData].[OperationСomposition] as oc ON sq.KTOP = oc.KTOP)
--Таблица просеяных ТМ 
DECLARE @combinesProducts as table (IdSemiProduct  int, Title nvarchar(99), IdRoutRule  int, IdCombine int, IsParent bit)
INSERT INTO @combinesProducts
SELECT   sp.[IdSemiProduct]
		,sp.Title
		,cc.IDRoutRule
		,cc.IdCombine
		,cc.IsParent
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
  OUTER APPLY [InputData].[ctvf_CombineCombines](sp.[IdSemiProduct]) as cc
 
  INSERT INTO [SupportData].[CombineRules]
           ([SemiProductId]
           ,[Number_])
  SELECT Distinct IdSemiProduct
  ,IdCombine FROM @combinesProducts
  WHERE IdCombine is not null 

  --Заполняем Compositons
  INSERT INTO [SupportData].[CombineComposition]
           ([CombineRulesId]
           ,[RuleId]
           ,[RuleIsParent])
  SELECT IdCombineRules
  ,IdRoutRule
  ,IsParent
  FROM [SupportData].[CombineRules] as cr
  INNER JOIN @combinesProducts as cp ON cp.IdSemiProduct = cr.[SemiProductId] 
										and cp.IdCombine = cr.[Number_]
RETURN 0
