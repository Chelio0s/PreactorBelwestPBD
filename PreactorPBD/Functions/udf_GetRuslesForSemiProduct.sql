CREATE FUNCTION [InputData].[udf_GetRulesForSemiProduct]
(
	@IdSemiProduct int, 
	@SimpleProductId int = NULL
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



  IF @SimpleProductId is NULL
	
	BEGIN 
		INSERT INTO @routedProducts
	SELECT DISTINCT  sp.[IdSemiProduct]
		,r.IDRoutRule
		,rr.RuleGroupId
	FROM [InputData].[SemiProducts] as sp
	INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
	OUTER APPLY [InputData].ctvf_GetRouteRules(sp.[IdSemiProduct]) as r
	INNER JOIN  [SupportData].[RoutRoules] as rr ON rr.IdRule = r.IDRoutRule
	WHERE sp.[IdSemiProduct] = @IdSemiProduct
	END 
ELSE 
	BEGIN 
		INSERT INTO @routedProducts
		SELECT DISTINCT  sp.[IdSemiProduct]
		,r.IDRoutRule
		,rr.RuleGroupId
		FROM [InputData].[SemiProducts] as sp
		INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
		OUTER APPLY [InputData].[ctvf_GetRouteRules](sp.[IdSemiProduct]) as r
		CROSS APPLY [InputData].[ctvf_FilterRouteRules](@IdSemiProduct) as filter
		INNER JOIN  [InputData].[VI_RulesWithOperations] as rr ON rr.IdRule = r.IDRoutRule
		WHERE sp.[IdSemiProduct] = @IdSemiProduct and filter.IDRoutRule  = rr.IdRule
	END
	RETURN

	RETURN 
END
