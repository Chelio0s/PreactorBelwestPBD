CREATE PROCEDURE [InputData].[sp_InsertOperationsInResources]
AS

DELETE FROM [InputData].[OperationInResource]
INSERT INTO [InputData].[OperationInResource]
           ([OperationId]
           ,[ResourceId]
           ,[OperateTime])
  SELECT DISTINCT 
      IdOperation
	  ,IdResource
      ,MAX([NORMATIME]) OVER(PARTITION BY IdOperation ,IdResource)
  FROM [InputData].[VI_OperationsFromSDBWithConcreetResources]								 
RETURN 0
