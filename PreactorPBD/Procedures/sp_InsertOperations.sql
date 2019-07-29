CREATE PROCEDURE [InputData].[sp_InsertOperations]
AS

	DELETE FROM  [InputData].[Operations]
		DECLARE @table as table(idRout int, TitleOperPr nvarchar(99), IdSemiProduct int, idProfesson int, TypeTime int, CategoryOperation int, OperOrder int, Code varchar(4), NPP int)
	--Все для 1 цеха (там операции строго сортированы по правилам)
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,1  --заменяем NPP на 1 чтобы убрать потом дубликаты
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE code = 'OP01' and r.AreaId = 3
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все для 2 цеха с правилами, сортировка по NPP
  INSERT INTO @table
  SELECT DISTINCT 	
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is not null and (IdSemiProduct = r.SemiProductId and KTOPN not in (SELECT KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout)))
  AND code = 'OP02' and r.AreaId = 4
  ORDER BY r.IdRout, NPP
  --Все для 2 цеха без правил, сортировка по NPP
    INSERT INTO @table
    SELECT DISTINCT 	 
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is null AND code = 'OP02' and r.AreaId = 4
  ORDER BY r.IdRout, NPP

--Все для 6/1 цеха 
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP61' and r.AreaId = 9
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все для 7/1 цеха 
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP71' and r.AreaId = 13
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

    --Все для 8/1 цеха 
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP81' and r.AreaId = 14
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

--Все для 9/2 цеха 
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP09' and r.AreaId = 20
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  
--Залив финала 1 цех
INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
           ,[Code])
	SELECT 
		TitleOperPr
		,ROW_NUMBER() over (partition by IdSemiProduct order by IdSemiProduct, OperOrder)*10
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table
		WHERE Code = 'OP01'
		ORDER BY idRout, OperOrder
--Залив финала 2 цех и 6/1, 7/1, 8/1, 9/2 цех
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
           ,[Code])
	SELECT DISTINCT
		tt.TitleOperPr
		,(SELECT TOP(1) NPP FROM @table as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table as tt
		WHERE Code  in ('OP02','OP61', 'OP71', 'OP81', 'OP09')
		ORDER BY idRout, NPP
		--Очищаем таблицу 
	DELETE FROM @table
	--Заливаем в нее данные для переходящих маршрутов
	--Маршруты для 18 ПФ для которых нет операций для альтернативных цехов
  INSERT INTO @table
  SELECT  DISTINCT
       r.IdRout
	   ,vi.TitlePreactorOper
       ,r.SemiProductId
	   ,vi.IdProfession
       ,1
	   ,CategoryOperation
	   ,vi.OperOrder
	   ,area.Code
	   ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_SemiProductsWithArticles] as sp ON r.SemiProductId = sp.IdSemiProduct
  OUTER APPLY [InputData].[ctvf_GetFinalRoutForOtherPlaceSemiProduct](sp.IdSemiProduct, [AreaId]) as fn
  LEFT JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = sp.IdSemiProduct and vi.KTOPN = KTOPParent
  INNER JOIN [InputData].[Areas] as area ON area.IdArea = r.AreaId
 
  WHERE IdRout not in 
  (
	  SELECT DISTINCT [RoutId] 
	  FROM [InputData].[Operations]
  ) and sp.SimpleProductId = 18 
  ORDER BY r.IdRout, NPP

 -- залив финала 2 цех и 6/1, 7/1, 8/1, 9/2 цех переходящие маршруты
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
           ,[Code])
	SELECT DISTINCT
		tt.TitleOperPr
		,(SELECT TOP(1) NPP FROM @table as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table as tt
		ORDER BY idRout, NPP

RETURN 0
