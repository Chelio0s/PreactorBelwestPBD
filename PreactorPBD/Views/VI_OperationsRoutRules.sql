--Вьюха для выборки операций из правил формирования альт. маршрутов
CREATE VIEW [InputData].[VI_OperationsRoutRules]
	AS 
	SELECT DISTINCT [IdRule]
	  ,co.[Title] as parentTitle
	  ,co1.Title as childTitle
	  ,oc.KTOP as KTOPParent
	  ,oc1.KTOP as KTOPChild
  FROM [SupportData].[RoutRoules] as rr
  INNER JOIN [SupportData].[ComposeOperation] as co ON co.[idComposeOper] = rr.[OperationParentId]
  INNER JOIN [SupportData].[ComposeOperation] as co1 ON co1.[idComposeOper] = rr.[OperationChildId]
  INNER JOIN [SupportData].[OperationСomposition] as oc ON oc.ComposeOperationId = co.idComposeOper
  INNER JOIN [SupportData].[OperationСomposition] as oc1 ON oc1.ComposeOperationId = co1.idComposeOper