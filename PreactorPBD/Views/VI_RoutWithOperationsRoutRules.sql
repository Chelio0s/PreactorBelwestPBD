CREATE VIEW [InputData].[VI_RoutWithOperationsRoutRules]
	AS SELECT [IdRout]
      ,r.[SemiProductId]
	  , cc.[RuleId]
	  ,[RuleIsParent]
	  ,co2.Title as ParentOperations
	  ,co1.Title as ChildOperations
	  ,vifast.IdSemiProduct
  FROM [InputData].[Rout] as r
  LEFT JOIN [SupportData].[CombineRules] as cr ON cr.[IdCombineRules] = r.[CombineId]
  LEFT JOIN [SupportData].[CombineComposition] as cc ON cc.[CombineRulesId] = r.[CombineId]
  LEFT JOIN [SupportData].[RoutRoules] as rr ON rr.IdRule = cc.[RuleId]
  LEFT JOIN [SupportData].[ComposeOperation] as co1 ON co1.idComposeOper = rr.OperationChildId
  LEFT JOIN [SupportData].[ComposeOperation] as co2 ON co2.idComposeOper = rr.OperationParentId
  LEFT JOIN [SupportData].[OperationСomposition] as oc1 ON oc1.ComposeOperationId = co1.idComposeOper
  LEFT JOIN [SupportData].[OperationСomposition] as oc2 ON oc2.ComposeOperationId = co2.idComposeOper
  LEFT JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vifast ON vifast.IdSemiProduct = r.SemiProductId
  
  GROUP BY [IdRout] , cc.[RuleId]
	  ,[RuleIsParent],co2.Title,co1.Title ,r.[SemiProductId],vifast.IdSemiProduct
