CREATE VIEW [InputData].[VI_OperationsWithBigGroup]
	AS SELECT [IdOperation]
      ,OP.[Title] as OperTitle
      ,OPWK.KTOP 
	  ,r.AreaId
	  ,bok.[IdBigOperationsGroup]
	  ,bo.[Title] as BigGroupTitle
  FROM  [InputData].[Operations]		as OP
  INNER JOIN [InputData].[OperationWithKTOP]		as OPWK  ON OPWK.OperationId = OP.IdOperation
  INNER JOIN [InputData].[Rout]						as R	 ON R.IdRout = OP.RoutId	
  INNER JOIN [InputData].[SemiProducts]				as SP	 ON sp.IdSemiProduct = r.SemiProductId
  LEFT JOIN [SupportData].[BigOperationsGroupWithKtop] as bok ON [InputData].[udf_GetCorrectKTOPForArea](bok.ktop, r.AreaId) = OPWK.KTOP
																OR BOK.ktop = OPWK.KTOP
  INNER JOIN [SupportData].[BigOperationsGroups]		as bo ON bo.[IdBigOperationsGroup] = bok.[IdBigOperationsGroup]
  WHERE  sp.SimpleProductId = 18
