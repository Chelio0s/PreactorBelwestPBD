-- ТМ 2 цеха, которые содержат не переносимые операции
CREATE VIEW [InputData].[VI_BannedRoutesForMapping]
	AS   SELECT DISTINCT 	
	  r.IdRout
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE Code = 'OP02' 
		AND (vi.[IdSemiProduct] = r.SemiProductId 
		AND KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout) AS fn)) -- Недоступные операции для данного маршрута
		AND SimpleProductId = 18 -- Убираем натуральную стельку. //todo: Возможно нужно будет заменить на др ПФ. 
		AND KTOPN IN (592,397,382
		,429 --16 MO
		,505 --17 MO
		,424 --18 MO
		,584 --20 MO
		,468,413,412 -- 36 MO
		,482 -- 38 MO
		,347 -- 48 MO
		,348,503 -- 49 MO
		,535 --53 MO
		,500 --55 MO
		,396,439 -- 58 MO
		,514  -- 59 MO
		,511,512) -- 61 MO
