CREATE VIEW [InputData].[VI_GetOperationsForMappingSecondFloor]
	AS   
	SELECT DISTINCT 	
	  r.IdRout
	  ,Article
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
	  ,CategoryOperation
	  ,vi.[OperOrder]
	  ,Code
	  ,KTOPN
	  ,KOB
	  ,NORMATIME AS NormaTime
	  ,vi.SimpleProductId
	  ,vi.KOLD
	  ,vi.KOLN
	  ,vi.NPP
	  ,vi.REL
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE Code = 'OP02' 
		AND (vi.[IdSemiProduct] = r.SemiProductId 
		AND KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout) AS fn)) -- Недоступные операции для данного маршрута
		AND SimpleProductId = 18 -- Убираем натуральную стельку. //todo: Возможно нужно будет заменить на др ПФ. 
