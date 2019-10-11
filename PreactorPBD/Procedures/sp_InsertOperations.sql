CREATE PROCEDURE [InputData].[sp_InsertOperations]
AS

	DELETE FROM [InputData].[OperationWithKTOP]
	DELETE FROM  [InputData].[Operations]
		DECLARE @table as table(idRout int, 
		TitleOperPr nvarchar(99), 
		IdSemiProduct int, 
		idProfesson int, 
		TypeTime int, 
		CategoryOperation int, 
		OperOrder int, 
		Code varchar(4), 
		NPP int, 
		KTOPN int,
		TimeMultiply float,
		IdMappingRule int NULL)
	--Все для 1 цеха (там операции строго сортированы по правилам)
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,1  --заменяем NPP на 1 чтобы убрать потом дубликаты
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
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
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP09' and r.AreaId = 20
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Выборка таких маршрутов 3 и 4 цеха, которые могут "прыгать из цеха в цех"
  DECLARE @JumpSemiProducts as table (Article nvarchar(99), IdMergeRoutes int, IdSemiProduct int, BaseAreaId int, ChildAreaId int,KtopChildRoute int, KtopParentRoute int)
  INSERT INTO @JumpSemiProducts
  SELECT
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	as vifast
  INNER JOIN [InputData].[Areas]							as area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
  CROSS JOIN [SupportData].[MergeRoutes]					as mr
  WHERE (mr.BaseAreaId = area.IdArea and vifast.KTOPN = mr.KtopPrentRoute) or (mr.ChildAreaId = area.IdArea and vifast.KTOPN = mr.KtopChildRoute)
  --тут ограничено только 3 и 4 цехом
  AND IdArea in (5,6)
  GROUP BY   
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
  HAVING COUNT(mr.IdMergeRoutes) = 2
  
  --Залив прыгающих ТМ
  INSERT INTO @table
  SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
  FROM [InputData].[Rout]											as r
  INNER JOIN @JumpSemiProducts										as jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].ctvf_GetMergedRouteForSemiProduct(r.SemiProductId)	as vi

  --Все для 3 и 4 цеха кроме маршрутов с Jump
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE ((Code = 'OP03' and r.AreaId = 5) or (Code = 'OP04' and r.AreaId = 6))
  and IdSemiProduct not in (SELECT  j.IdSemiProduct FROM @JumpSemiProducts as j)
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

   --Все для 5 цеха 
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,1 --timemultiply
	  ,NULL -- idMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE (Code = 'OP05' and r.AreaId = 7) 
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]


	--Залив финала 1 цех
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTimeId]
           ,[CategoryOperation]
           ,[Code])
	SELECT DISTINCT
		TitleOperPr
		,OperOrder*10
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
	FROM @table
	WHERE Code = 'OP01' and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0
	ORDER BY 
		idRout
		,OperOrder*10	
		,TitleOperPr
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code

--Залив финала 2 цех и 6/1, 7/1, 8/1, 9/2 цех
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTimeId]
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
		WHERE Code  in ('OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04') and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0
		ORDER BY idRout, NPP

		--Заливаем в КТОПы		TitleOperPr
		INSERT INTO [InputData].[OperationWithKTOP]
 		SELECT DISTINCT
		oper.IdOperation
		,t.KTOPN
		,t.TimeMultiply
		FROM @table							as t
		INNER JOIN [InputData].[Operations] as oper ON oper.Title = t.TitleOperPr
													AND oper.RoutId = t.idRout
													AND oper.CategoryOperation = t.CategoryOperation
		WHERE oper.Code in ('OP01', 'OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04')
		-- ORDER BY idRout, OperOrder


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
	   ,fn.KTOPChild
	   ,mr.TimeCoefficient
	   ,mr.IdRule
  FROM [InputData].[Rout]																				AS r
  INNER JOIN	[InputData].[VI_SemiProductsWithArticles]												AS sp ON r.SemiProductId = sp.IdSemiProduct
  CROSS APPLY	[InputData].[ctvf_GetFinalRoutForOtherPlaceSemiProduct](sp.IdSemiProduct, r.[AreaId])	AS fn
  LEFT JOIN		[InputData].[VI_OperationsWithSemiProducts_FAST]										AS vi ON vi.IdSemiProduct = sp.IdSemiProduct and vi.KTOPN = KTOPParent
  INNER JOIN	[InputData].[VI_MappingRules]															AS mr ON mr.KTOPParent = fn.KTOPParent 
																										AND mr.KOBParent = fn.KOBParent
																										AND mr.KTOPChild = fn.KTOPChild
																										AND mr.KOBChild = fn.KOBChild
																										AND mr.AreaId = r.AreaId
   INNER JOIN	[InputData].[Areas]																		AS area ON area.IdArea = mr.AreaId
 
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
           ,[TypeTimeId]
           ,[CategoryOperation]
           ,[Code]
		   ,MappingRuleId)
	SELECT DISTINCT
		tt.TitleOperPr
		,(SELECT TOP(1) NPP FROM @table as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		,IdMappingRule
		FROM @table as tt
		ORDER BY idRout, NPP

		----Залив Опер - ктоп
		INSERT INTO OperationWithKTOP
 		SELECT DISTINCT
		oper.IdOperation
		,t.KTOPN
		,t.TimeMultiply
		FROM @table							as t
		INNER JOIN [InputData].[Operations] as oper ON oper.Title = t.TitleOperPr
													AND oper.RoutId = t.idRout
													AND oper.CategoryOperation = t.CategoryOperation
		WHERE oper.Code in ('OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04')

RETURN 0
