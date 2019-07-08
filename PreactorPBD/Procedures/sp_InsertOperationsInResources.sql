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
  INNER JOIN [InputData].[Rout] as r ON r.SemiProductId = vi.IdSemiProduct
  INNER JOIN [InputData].[Operations] as oper ON oper.RoutId = r.IdRout  and TitlePreactorOper = oper.Title
  LEFT JOIN [SupportData].[GroupKOB] as groupkob ON groupkob.KTOPN = vi.KTOPN
  LEFT JOIN [InputData].[ResourcesGroup] as resgroup ON resgroup.IdResourceGroup = groupkob.[GroupId]
  INNER JOIN [InputData].[Areas] as area ON area.Code = oper.Code COLLATE Cyrillic_General_BIN
  INNER JOIN [InputData].[Departments] as dep ON dep.AreaId = area.IdArea
  INNER JOIN [InputData].[Resources] as res ON res.KOB = vi.KOB 
												AND dep.IdDepartment = res.DepartmentId
									 --and  resgroup.IdResourceGroup = groupkob.[GroupId] 
									 
									 -- Не знаю зачем это тут было но оставлю для истории на всякий случай
  

RETURN 0
