CREATE VIEW [InputData].[VI_GetOperationsForMappingFirstFloor]
	AS  
	--Вьюха для получения операций первого цеха, которые могут быть смаплены для 9/1
	-- Т.е. все кроме автомата и т.д.
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
	  ,vi.REL
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE  Code = 'OP01' 
		AND (vi.[IdSemiProduct] = r.SemiProductId and KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout) AS fn))
		AND IdRout NOT IN (SELECT DISTINCT xr.IdRout
							FROM [InputData].[Rout] as xr
							INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] AS xvi ON xvi.IdSemiProduct = xr.SemiProductId
							WHERE CombineId IS NOT NULL 
							AND (IdSemiProduct = xr.SemiProductId 
							AND KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](xr.IdRout) AS fn))
							--Отсев ТМ в каторых есть операции, которые сразу отваливаются и не переходят автоматом в ц 9/1
							AND KTOPN IN (125,209,226,219,126,127,256,217, 203,293,118,264,269,155,236,263,280,278,295,196,255,281,283,161,211,178,165,167,243))
