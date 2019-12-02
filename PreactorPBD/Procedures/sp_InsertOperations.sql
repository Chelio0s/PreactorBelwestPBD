CREATE PROCEDURE [InputData].[sp_InsertOperations]
AS
    print 'Создаем операции'
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
		IsMappingRule bit)

  --Все для 1 цеха с правилами (комбинациями операций), сортировка по правилам
  INSERT INTO @table
  SELECT DISTINCT 	
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,1
	  ,KTOPN
	  ,1 --timemultiply
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is not null and (IdSemiProduct = r.SemiProductId and KTOPN not in (SELECT KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout)))
  AND code = 'OP01' and r.AreaId = 3
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]
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
	  ,0  -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE code = 'OP01' and r.AreaId = 3 and CombineId is null
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все для 2 цеха с правилами (комбинациями), сортировка по NPP
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
	  ,0 -- isMappingRule
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is null AND code = 'OP02' and r.AreaId = 4
  ORDER BY r.IdRout, NPP

--Все для 6/1 цеха - стандарт, подготовлено технологами 
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP61' and r.AreaId = 9
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все для 7/1 цеха  - стандарт, подготовлено технологами  
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP71' and r.AreaId = 13
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

    --Все для 8/1 цеха  - стандарт, подготовлено технологами 
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE Code = 'OP81' and r.AreaId = 14
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

--Все для 9/2 цеха - стандарт, подготовлено технологами 
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
	  ,0 -- idMappingRule
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
  
  --Залив прыгающих ТМ   3 и 4
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											as r
  INNER JOIN @JumpSemiProducts										as jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](r.SemiProductId)	as vi

  --Все для 3 и 4 цеха кроме маршрутов с Jump - стандарт, подготовлено технологами 
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE ((Code = 'OP03' and r.AreaId = 5) or (Code = 'OP04' and r.AreaId = 6))
  and IdSemiProduct not in (SELECT  j.IdSemiProduct FROM @JumpSemiProducts as j)
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

    --Чистим таблицу от прошлых прыгающих ТМок
  DELETE FROM @JumpSemiProducts
   --Выборка таких маршрутов 9/1 цеха, которые могут "прыгать из цеха в цех"
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
  AND IdArea in (8)
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											as r
  INNER JOIN @JumpSemiProducts										as jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](r.SemiProductId)	as vi


  --Все для 9/1 цеха кроме маршрутов с Jump
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
	  ,0 -- isMappingRule
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
  WHERE (Code = 'OP09' and r.AreaId = 8)
  and IdSemiProduct not in (SELECT  j.IdSemiProduct FROM @JumpSemiProducts as j)
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все маршруты для 9/1 для которых нет операций ТМ в базе (пробуем создать операции автоматом)
  DECLARE @routes as table (IdRoute int, Article nvarchar(99))
  INSERT INTO @routes
  SELECT DISTINCT
	  r.IdRout
	 ,art.Title as Article
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
  INNER JOIN [InputData].[Nomenclature] as nom ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]		as art ON art.IdArticle = nom.ArticleId
  WHERE IdRout NOT IN (SELECT DISTINCT
						  rout.IdRout
					  FROM @table as rout) and r.AreaId = 8  
    -- SimpleProductId = 1 - крой верха всегда есть в обуви по этому проверяем только его
	-- т.к. других пф может не быть, например стельки, а это вносит недопонимание
	and sp.SimpleProductId = 1


  -- Выборка тех, которые возможно замаппить
  DECLARE @MappingRoutes table (IdRoute int)
  INSERT INTO @MappingRoutes
  SELECT DISTINCT rr.idRoute 
  FROM  @routes as r
  INNER JOIN @routes as rr ON r.Article = rr.Article
  WHERE [InputData].[udf_CanIMapFirstFloor](r.Article) = 1

  -- Маппим 1 в 9/1
  INSERT INTO @table
  SELECT  DISTINCT
	   IdRout
	  ,[InputData].[udf_GetTitleOperation] (KTOPChild, so.Title) as [PreactorOperation]
      ,[IdSemiProduct]
      ,[KPROF]
      ,4 as [TypeTime]
	  ,CategoryOperation
	  ,so.OperOrder
	  ,'OP09'										                              as Code
	  ,ROW_NUMBER() over(partition by [IdSemiProduct] order by so.OperOrder) * 10 as NPP
	  ,KTOPChild
	  ,1 --timemultiply
	  ,1 -- 1 - значит это автоматически замапленные ТМ
  FROM @MappingRoutes
  CROSS APPLY [InputData].[ctvf_GetAltRouteForFirstFloor](IdRoute) as ctvf
  INNER JOIN [SupportData].[SequenceOperations] as SO ON so.KTOP = KTOPChild
  GROUP BY IdRout
	  ,[InputData].[udf_GetTitleOperation] (KTOPChild, so.Title)
      ,[IdSemiProduct]
      ,[KPROF]
	  ,CategoryOperation
	  ,so.OperOrder
	  ,KTOPChild
	  ,ctvf.IdRule
   ORDER BY IdRout, so.OperOrder

 --  --Все для 5 цеха  -- 5 цех пока выкидываем из балансировки
	--INSERT INTO @table
	--SELECT DISTINCT
	--  r.IdRout
	--  ,[TitlePreactorOper]
 --     ,vi.[IdSemiProduct]
 --     ,vi.[IdProfession]
 --     ,4 as [TypeTime]
	--  ,CategoryOperation, vi.[OperOrder]
	--  ,Code
	--  ,NPP
	--  ,KTOPN
	--  ,1 --timemultiply
	--  ,NULL -- idMappingRule
 -- FROM [InputData].[Rout] as r
 -- INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId												  
 -- WHERE (Code = 'OP05' and r.AreaId = 7) 
 -- ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

	--Залив финала 1 цех
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTimeId]
           ,[CategoryOperation]
           ,[Code]
		   ,[IsMappingRule])
	SELECT DISTINCT
		TitleOperPr
		,OperOrder*10 as NPP
		,t.idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		,0
	FROM @table						as t
	INNER JOIN [InputData].[Rout]	as r ON t.idRout = r.IdRout 
	WHERE Code = 'OP01' and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0 
	and r.AreaId = 3   -- поставил тут еще фильтр по цеху потому что ОП01 встречается и в ТМ 9го цеха при прыжках
	ORDER BY 
		t.idRout
		,OperOrder*10	
		,TitleOperPr
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code

--Залив финала 1 c jump, и 2 цех и 6/1, 7/1, 8/1, 9/2 цех
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTimeId]
           ,[CategoryOperation]
           ,[Code]
		   ,[IsMappingRule])
	SELECT DISTINCT
		tt.TitleOperPr
		,(SELECT TOP(1) NPP FROM @table as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		,IsMappingRule
		FROM @table as tt
		WHERE Code  in ('OP01', 'OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04') and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0
		and idrout not in (SELECT DISTINCT t.idRout
							FROM @table						as t
							INNER JOIN [InputData].[Rout]	as r ON t.idRout = r.IdRout 
							WHERE Code = 'OP01' and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0 and r.AreaId = 3  )
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
		


	--Очищаем таблицу
	print 'Заливаем операции в альт. ТМ'
	DELETE FROM @table
	TRUNCATE TABLE  [SupportData].[TempOperationForMapping]
	--Заливаем в нее данные для переходящих маршрутов
	--Маршруты для 18 ПФ для которых нет операций для альтернативных цехов


INSERT INTO @table
SELECT DISTINCT
      R.IdRout
	  ,[InputData].[udf_GetTitleOperation](FN.KTOPChild, SO.Title)					AS TitleOperation
      ,R.SemiProductId
      ,FN.KPROF																		AS [idProfesson]
	  ,4																			AS [TypeTime]																	
	  ,FN.CategoryOperation
      ,SO.OperOrder
	  ,AR.Code
	  ,MIN(NPP) OVER(PARTITION BY  R.IdRout, [InputData].[udf_GetTitleOperation](FN.KTOPChild, SO.Title)) AS NPP
	  ,FN.KTOPChild
	  ,1
	  ,0
  FROM [InputData].[Rout]															AS R
  CROSS APPLY [InputData].[ctvf_GetAltRouteForSecondFloor](ParentRouteId, Areaid)	AS FN
  INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = FN.KTOPChild
  RIGHT JOIN  [InputData].[VI_OperationsWithSemiProducts_FAST]						AS FAS	ON FAS.IdSemiProduct = R.SemiProductId
																							AND FAS.KTOPN = FN.KTOPParent
  INNER JOIN  [InputData].[Areas]													AS AR	ON AR.IdArea = R.AreaId
  WHERE ParentRouteId IS NOT NULL 
  AND R.AreaId IN (9,13,14,20)
 

 -- -- Залив во временную таблицу все операции которые маппили (потом пригодится при расстановке операций на оборудование)
  DELETE FROM [SupportData].[TempOperationForMapping]
  INSERT INTO [SupportData].[TempOperationForMapping]
SELECT DISTINCT
	  R.IdRout
	  ,[InputData].[udf_GetTitleOperation](FN.KTOPChild, SO.Title)					AS TitleOperation
      ,R.SemiProductId
      ,FN.KPROF																		AS [idProfesson]																
	  ,FN.CategoryOperation
	  ,AR.Code
	  ,FN.KTOPChild
	  ,FN.KOBChild
	  ,FN.NormaTimeNew
  FROM [InputData].[Rout]															AS R
  CROSS APPLY [InputData].[ctvf_GetAltRouteForSecondFloor](ParentRouteId, Areaid)	AS FN
  INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = FN.KTOPChild
  RIGHT JOIN  [InputData].[VI_OperationsWithSemiProducts_FAST]						AS FAS	ON FAS.IdSemiProduct = R.SemiProductId
																							AND FAS.KTOPN = FN.KTOPParent
  INNER JOIN  [InputData].[Areas]													AS AR	ON AR.IdArea = R.AreaId
  WHERE ParentRouteId IS NOT NULL 
  AND R.AreaId IN (9,13,14,20)
  ORDER BY R.IdRout

 -- залив финала  6/1, 7/1, 8/1, 9/2 цех переходящие маршруты
	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTimeId]
           ,[CategoryOperation]
           ,[Code]
		   ,IsMappingRule)
	SELECT DISTINCT
		tt.TitleOperPr
		,NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		,1
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
		WHERE oper.Code in ('OP61', 'OP71', 'OP81', 'OP09')

RETURN 0
