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
      ,[NORMATIME]
  FROM [InputData].[VI_OperationsFromSDBWithConcreetResources]								 
RETURN 0
