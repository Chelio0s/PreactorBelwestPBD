CREATE VIEW [InputData].[VI_OperationsFullInfo]
	AS SELECT [IdOperation]
      ,[ArtTitle]
      ,[Size]
      ,[Nomenclature]
      ,[OperTitle]
	  ,k.KTOP
	  ,operinres.OperateTime
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTimeId]
      ,[CategoryOperation]
      ,[Code]
      ,[IdSemiProduct]
      ,[SimpleProductId]
	  ,res.kob
	  ,operdep.resTitle
	  ,operdep.IdResource
	  ,operdep.IdDepartment

  FROM			[InputData].[VI_OperationsFromSDB]			AS oper	
  LEFT JOIN		[InputData].[OperationInResource]			AS operinres	ON operinres.OperationId = oper.IdOperation
  INNER JOIN	[InputData].[VI_ResourcesOnDepartments]		AS operdep		ON operdep.IdResource = operinres.ResourceId
  LEFT JOIN		[InputData].[OperationWithKTOP]				AS k			ON k.OperationId = oper.IdOperation
  INNER JOIN	[InputData].[Resources]						AS res			ON res.IdResource = operinres.ResourceId
