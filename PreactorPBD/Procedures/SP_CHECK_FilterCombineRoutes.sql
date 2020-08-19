CREATE PROCEDURE [InputData].[SP_CHECK_FilterCombineRoutes]
	@IdSemiProduct int
AS

DECLARE @FilteredTable as table (IdSemiProduct int NOT NULL)
INSERT INTO @FilteredTable
SELECT [IdSemiProduct]
FROM [InputData].[SemiProducts] as sp
--Просееваем заведомо не нужные ПФ (для которых нет RULES)
WHERE sp.SimpleProductId IN (SELECT DISTINCT
								   [ForSimpleProduct]
							  FROM  [SupportData].[RuleGroup])

SELECT  DISTINCT  sp.[IdSemiProduct]
		,r.IDRoutRule
		,rr.RuleGroupId
		,parentKTOP
		,childKTOP
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
  OUTER APPLY [InputData].ctvf_GetRouteRules(sp.[IdSemiProduct]) as r
  INNER JOIN  [InputData].[VI_RulesWithOperations] as rr ON rr.IdRule = r.IDRoutRule
  WHERE sp.[IdSemiProduct] = @IdSemiProduct
  ORDER BY IDRoutRule DESC

  SELECT * FROM [InputData].[ctvf_FilterRouteRules](@IdSemiProduct)
RETURN 0
