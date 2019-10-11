CREATE FUNCTION [InputData].[udf_GetRulesForSemiProduct]
(
	@IdSemiProduct int
)
RETURNS @routedProducts TABLE
(
	IdSemiProduct  int
	,IdRoutRule    int
	,RuleGroupId   int 
)
AS
BEGIN

DECLARE @FilteredTable as table (IdSemiProduct int NOT NULL)
INSERT INTO @FilteredTable
SELECT [IdSemiProduct]
FROM [InputData].[SemiProducts] as sp
--Просееваем заведомо не нужные ПФ (для которых нет RULES)
WHERE sp.SimpleProductId IN (SELECT DISTINCT
								   [ForSemiProduct]
							  FROM  [SupportData].[RuleGroup])
INSERT INTO @routedProducts
SELECT   sp.[IdSemiProduct]
		,r.IdRoutRule
		,rr.RuleGroupId
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
  OUTER APPLY [InputData].ctvf_GetRouteRules(sp.[IdSemiProduct]) as r
  INNER JOIN  [SupportData].[RoutRoules] as rr ON rr.IdRule = r.IdRoutRule
  WHERE sp.[IdSemiProduct] = @IdSemiProduct
	RETURN 
END
