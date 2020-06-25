CREATE VIEW [InputData].[VI_OperationsWithCombines]
	AS SELECT DISTINCT TOP(100) PERCENT  	
	  r.[IdRout]
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,[CategoryOperation]
	  ,vi.[OperOrder]
	  ,[Code]
	  ,1 as NPP
	  ,[KTOPN]
	  ,vi.[REL]
	  ,0 as isMappingRule
	  ,r.AreaId
  FROM [InputData].[Rout]									  AS r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] AS vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is not null 
  AND (IdSemiProduct = r.SemiProductId 
  AND KTOPN not in (SELECT KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout)))
		  


 


 
