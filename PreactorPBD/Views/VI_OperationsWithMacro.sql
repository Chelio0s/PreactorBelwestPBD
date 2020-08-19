CREATE VIEW [InputData].[VI_OperationsWithMacro]
	AS SELECT [IdOperation]
      ,OP.[Title] as OperTitle
      ,OPWK.KTOP
	  ,r.AreaId
	  ,mo.[Title] as MacroTitle
  FROM  [InputData].[Operations]		as OP
  INNER JOIN [InputData].[OperationWithKTOP]		as OPWK  ON OPWK.OperationId = OP.IdOperation
  INNER JOIN [InputData].[Rout]						as R	 ON R.IdRout = OP.RoutId	
  INNER JOIN [InputData].[SemiProducts]				as SP	 ON sp.IdSemiProduct = r.SemiProductId
  LEFT JOIN  [SupportData].[MacroOperationWithKtop] as mok ON mok.ktop = OPWK.KTOP
  INNER JOIN [SupportData].[MacroOperations]		as mo  ON mo.[IdMacroOperation]  = mok.[MacroOperationId]
  WHERE  sp.SimpleProductId = 18