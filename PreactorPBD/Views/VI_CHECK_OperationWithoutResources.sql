CREATE VIEW [InputData].[VI_CHECK_OperationWithoutResources]
	AS SELECT 
O.IdOperation
,O.Title
,O.RoutId
,O.Code	
FROM InputData.Operations				AS O
LEFT JOIN InputData.OperationInResource AS OIR ON (OIR.OperationId=O.IdOperation)
WHERE OIR.IdOpInResource is NULL