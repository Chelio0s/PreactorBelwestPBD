CREATE PROCEDURE [InputData].[sp_InsertCombines]
AS
	
	DELETE FROM [SupportData].[CombineRules]
	TRUNCATE TABLE [SupportData].[TempFilteredSemiProducts]
	INSERT INTO [SupportData].[TempFilteredSemiProducts]
    SELECT sp.[IdSemiProduct]
		  ,vi.TitleArticle
		  ,vi.SimpleProductId
    FROM [InputData].[SemiProducts] as sp
	INNER JOIN [InputData].[VI_SemiProductsWithArticles] as vi ON sp.IdSemiProduct = vi.IdSemiProduct
    --Просееваем заведомо не нужные ПФ (для которых нет RULES)
    WHERE sp.SimpleProductId IN (SELECT DISTINCT
								   [SimpleProductId]
							  FROM [SupportData].[SequenceOperations] as sq
							  INNER JOIN [SupportData].[OperationСomposition] as oc ON sq.KTOP = oc.KTOP)
							  ORDER BY TitleArticle, sp.[IdSemiProduct]


--Таблица просеяных ТМ, дергаем CLR только для 1 SemiProduct в [TempFilteredSemiProducts]
--так как по сути у артикула 5-7 одинаковых SP отличающихся только размером
--а значит можно получить резульаты CLR на SimpleProduct + Article

  DECLARE @combinesProducts as table (TitleArticle  nvarchar(199), SimpleProductId int, IdRoutRule  int, IdCombine int, IsParent bit)
  INSERT INTO @combinesProducts
  SELECT 
		TitleArticle
		,SimpleProductId
  		,cc.IDRoutRule
		,cc.IdCombine
		,cc.IsParent 
		FROM 
  (
		SELECT DISTINCT FIRST_VALUE(filtered.IdSemiProduct) 
					     OVER(PARTITION BY filtered.TitleArticle, filtered.[SimpleProductId] 
						      ORDER BY SimpleProductId) as  IdSemiProduct
	    ,filtered.TitleArticle
		,filtered.SimpleProductId
  FROM  [SupportData].[TempFilteredSemiProducts] AS filtered 
  ) as q
  CROSS APPLY [InputData].[ctvf_CombineCombines]([IdSemiProduct]) AS cc

  INSERT INTO [SupportData].[CombineRules]
           ([SemiProductId]
           ,[Number_])
  SELECT DISTINCT  
  IdSemiProduct
  ,IdCombine
  FROM @combinesProducts as cp
  INNER JOIN [SupportData].[TempFilteredSemiProducts]  AS t ON t.[SimpleProductId] = cp.SimpleProductId
															AND t.TitleArticle = cp.TitleArticle
  --Заполняем Compositons
  INSERT INTO [SupportData].[CombineComposition]
           ([CombineRulesId]
           ,[RuleId]
           ,[RuleIsParent])
  SELECT DISTINCT IdCombineRules
  ,IdRoutRule
  ,IsParent
  FROM [SupportData].[CombineRules]						AS cr
  INNER JOIN [SupportData].[TempFilteredSemiProducts]	AS t ON t.IdSemiProduct = cr.SemiProductId
  INNER JOIN @combinesProducts							AS CP ON CP.TitleArticle = t.TitleArticle
														AND t.[SimpleProductId] = cp.SimpleProductId
														AND cp.IdCombine = cr.Number_
RETURN 0
