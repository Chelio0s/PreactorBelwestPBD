CREATE VIEW [InputData].[VI_RulesWithOperations]
	AS 
	SELECT DISTINCT
	 rr.IdRule
	 ,rr.RuleGroupId
	  ,co2.Title		as parentOperations
	  ,oc2.KTOP			as parentKTOP
	  ,co1.Title		as childOperations
	  ,oc1.KTOP			as childKTOP
	  ,rr.RulePriority	as rulePriority 
  FROM [SupportData].[RoutRoules] rr
  INNER JOIN [SupportData].[ComposeOperation] as co1 ON co1.idComposeOper = rr.OperationChildId
  INNER JOIN [SupportData].[ComposeOperation] as co2 ON co2.idComposeOper = rr.OperationParentId
  INNER JOIN [SupportData].[OperationСomposition] as oc1 ON oc1.ComposeOperationId = co1.idComposeOper
  INNER JOIN [SupportData].[OperationСomposition] as oc2 ON oc2.ComposeOperationId = co2.idComposeOper
