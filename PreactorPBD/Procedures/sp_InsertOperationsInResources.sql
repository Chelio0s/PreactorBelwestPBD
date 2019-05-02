CREATE PROCEDURE [InputData].[sp_InsertOperationsInResources]
AS
DELETE FROM [InputData].[OperationInResource]
INSERT INTO [InputData].[OperationInResource]
           ([OperationId]
           ,[ResourceId]
           ,[OperateTime])
SELECT DISTINCT IdOperation
	  ,res.IdResource
      ,[NORMATIME]
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  INNER JOIN [InputData].[Operations] as oper ON oper.SemiProductID = vi.IdSemiProduct and TitlePreactorOper = oper.Title
  LEFT JOIN [SupportData].[GroupKOB] as groupkob ON groupkob.KTOPN = vi.KTOPN
  LEFT JOIN [InputData].[ResourcesGroup] as resgroup ON resgroup.IdResourceGroup = groupkob.[GroupId]
  LEFT JOIN [InputData].[Resources] as res ON res.KOB = vi.KOB and  resgroup.IdResourceGroup = groupkob.[GroupId]
RETURN 0
