CREATE VIEW [InputData].[VI_OperationsMappingRules]
	AS 
	
	SELECT [IdMappingComposeOperation]
		  ,[Title]
		  ,MO.KTOP
	  FROM [SupportData].[MappingComposeOperation]			AS MC
	  LEFT JOIN [SupportData].[MappingOperationComposition] AS MO ON MC.IdMappingComposeOperation = MO.MappingComposeOperationId
