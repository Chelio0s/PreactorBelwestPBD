CREATE VIEW [InputData].[VI_CHECK_OperationWithoutResources]
	AS SELECT 
O.IdOperation
,O.Title
,O.RoutId
,O.Code	
,VI.TitleArticle
,KT.KTOP
FROM [InputData].[Operations]					AS O
LEFT JOIN  [InputData].[OperationInResource]	AS OIR	ON OIR.OperationId=O.IdOperation
INNER JOIN [InputData].[VI_RoutesWithArticle]	AS VI	ON VI.IdRout = O.RoutId
LEFT JOIN  [InputData].[OperationWithKTOP]		AS KT	ON KT.OperationId = O.IdOperation
WHERE OIR.IdOpInResource is NULL