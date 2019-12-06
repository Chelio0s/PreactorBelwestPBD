CREATE VIEW [InputData].[VI_OperationsFromSDBWithREL]
	AS SELECT [IdOperation]
      ,oper.[Title]
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTimeId]
      ,oper.[CategoryOperation]
      ,oper.[Code]
	  ,[InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId) AS KTOP
	  ,operktop.REL
  FROM [InputData].[Operations]									AS oper 
  LEFT JOIN  [InputData].[OperationWithKTOP]					AS operktop ON oper.IdOperation = operktop.[OperationId]
  INNER JOIN [InputData].[Rout]									AS rout		ON rout.IdRout = oper.RoutId
  
