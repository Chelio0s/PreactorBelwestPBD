CREATE PROCEDURE [InputData].[sp_InsertOperationsSingleArticle]
	@article nvarchar(99)
AS
	PRINT 'DELETE FROM [InputData].[Operations]'
 	DELETE [InputData].[Operations]
    FROM [InputData].[Operations]           AS op
    INNER JOIN [InputData].[Rout]           AS r  ON r.IdRout = op.RoutId
    INNER JOIN [InputData].[SemiProducts]   AS sp ON sp.IdSemiProduct = r.SemiProductId
    INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
    INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
    WHERE a.Title = @article

	TRUNCATE TABLE [SupportData].[TempOperationsForInsertingOperations]
	
	
    --Все для 1 цеха с правилами (комбинациями операций), сортировка по правилам
  PRINT 'Все для 1 цеха с правилами (комбинациями операций), сортировка по правилам'

 INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
 SELECT DISTINCT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
  FROM [InputData].[VI_OperationsWithCombines] AS vi
  INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
  INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
  WHERE art.Title = @article
  AND Code = 'OP01'
  AND IdArea = 3
  ORDER BY vi.[IdSemiProduct], [OperOrder]
	
	--Все для 1 цеха (там операции строго сортированы по правилам)
    PRINT 'Все для 1 цеха (там операции строго сортированы по правилам)'																											 
	INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
	SELECT DISTINCT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
	FROM [InputData].[VI_OperationsStandardRoutes] AS vi
	INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
	INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	WHERE art.Title =  @article
	AND ( (code = 'OP01' AND AreaId = 3)
	OR (code = 'OP09' AND vi.SimpleProductId = 10) -- учитываем раскрой стельки в цехе 9/1
	OR (code = 'OP02' AND vi.SimpleProductId = 10)) -- учитывает то, что ПФ 10 может отправится на одну операцию в цех 2
	ORDER BY vi.[IdSemiProduct], [OperOrder]

   --JUMP для цеха N2
	PRINT 'JUMP для цеха N2'																										  
	TRUNCATE TABLE [SupportData].[TempJumpSemiProduct]
	INSERT INTO [SupportData].[TempJumpSemiProduct]
	SELECT DISTINCT
	     Article
		  ,mr.IdMergeRoutes
		  ,IdSemiProduct
		  ,mr.BaseAreaId
		  ,mr.ChildAreaId
		  ,mr.KtopChildRoute
		  ,mr.KtopPrentRoute
	FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	    AS vifast
	INNER JOIN [InputData].[Areas]							AS area   ON area.Code = vifast.Code
	CROSS JOIN [SupportData].[MergeRoutes]					AS mr
	WHERE ((mr.BaseAreaId = area.IdArea AND vifast.KTOPN = mr.KtopPrentRoute) 
	OR (mr.ChildAreaId = area.IdArea and vifast.KTOPN = mr.KtopChildRoute))
	AND mr.BaseAreaId =4
	AND Article = @article
	GROUP BY   
	     Article
		  ,mr.IdMergeRoutes
		  ,IdSemiProduct
		  ,mr.BaseAreaId
		  ,mr.ChildAreaId
		  ,mr.KtopChildRoute
		  ,mr.KtopPrentRoute
	HAVING COUNT(mr.IdMergeRoutes) = 2

	INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
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
	  ,vi.REL
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											AS r
  INNER JOIN [SupportData].[TempJumpSemiProduct]					AS jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](jump.IdSemiProduct)	as vi
  ORDER BY IdRout , NPP

  --Все для 2 цеха с правилами (комбинациями), сортировка по NPP  без JUMP
  PRINT 'Все для 2 цеха с правилами (комбинациями), сортировка по NPP'
    INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
    SELECT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
   FROM [InputData].[VI_OperationsWithCombines] AS vi
  INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
  INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
  WHERE art.Title = @article
   AND  code = 'OP02' 
   AND IdArea = 4
   AND IdRout NOT IN (SELECT J.idRout FROM [SupportData].[TempOperationsForInsertingOperations] AS J
   WHERE J.Code IN ('OP01', 'OP02'))
   ORDER BY IdRout, NPP

	  --Все для 2 цеха без правил, сортировка по NPP
   PRINT 'Все для 2 цеха без правил, сортировка по NPP'
    INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
   SELECT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
  FROM [InputData].[VI_OperationsStandardRoutes] AS vi
	INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
	INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	WHERE art.Title =  @article
	AND AreaId = 4 
	AND Code = 'OP02'
	AND IdRout NOT IN (SELECT J.idRout FROM [SupportData].[TempOperationsForInsertingOperations] AS J
  WHERE J.Code IN ('OP01', 'OP02'))
  ORDER BY IdRout, NPP


  --JUMP для цеха N5
  PRINT 'JUMP для цеха N5'
  TRUNCATE TABLE [SupportData].[TempJumpSemiProduct]
  INSERT INTO [SupportData].[TempJumpSemiProduct]
  SELECT
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	    AS vifast
  INNER JOIN [InputData].[Areas]							AS area   ON area.Code = vifast.Code
  CROSS JOIN [SupportData].[MergeRoutes]					AS mr
  WHERE ((mr.BaseAreaId = area.IdArea AND vifast.KTOPN = mr.KtopPrentRoute) 
  OR (mr.ChildAreaId = area.IdArea and vifast.KTOPN = mr.KtopChildRoute))
  AND mr.BaseAreaId =7
  AND Article = @article
  GROUP BY   
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
  HAVING COUNT(mr.IdMergeRoutes) = 2
  -- ЗАЛИВ Jump для 5 цеха
  INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
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
	  ,vi.REL
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											as r
  INNER JOIN [SupportData].[TempJumpSemiProduct]					as jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](jump.IdSemiProduct)	as vi
  ORDER BY IdRout , NPP

--Все для 5 6/1 7/1 8/1 9/2 цеха - стандарт, подготовлено технологами  (Кроме jump 5)
PRINT 'Все для 5 (кроме jump) 6/1 7/1 8/1 9/2 цеха - стандарт, подготовлено технологами '
	INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
	SELECT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
  FROM [InputData].[VI_OperationsStandardRoutes]	AS vi
	INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
	INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	WHERE art.Title =  @article
  AND    ((Code = 'OP61' AND AreaId = 9) 
		OR (Code = 'OP71' AND AreaId = 13) 
		OR (Code = 'OP81' AND AreaId = 14)
		OR (Code = 'OP09' AND AreaId = 20)
        OR (AreaId = 7)) -- 5 цех
		AND vi.IdSemiProduct NOT IN (SELECT IdSemiProduct 
								  FROM  [SupportData].[TempOperationsForInsertingOperations] 
								  WHERE Code = 'OP05')
  ORDER BY vi.[IdSemiProduct], [OperOrder]

   --Выборка таких маршрутов 3 и 4 цеха, которые могут "прыгать из цеха в цех"
  PRINT 'Выборка таких маршрутов 3 и 4 цеха, которые могут "прыгать из цеха в цех"'

   TRUNCATE TABLE [SupportData].[TempJumpSemiProduct]
  INSERT INTO [SupportData].[TempJumpSemiProduct]
  SELECT
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	    AS vifast
  INNER JOIN [InputData].[Areas]							AS area   ON area.Code = vifast.Code
  CROSS JOIN [SupportData].[MergeRoutes]					AS mr
  WHERE ((mr.BaseAreaId = area.IdArea AND vifast.KTOPN = mr.KtopPrentRoute) 
  OR (mr.ChildAreaId = area.IdArea and vifast.KTOPN = mr.KtopChildRoute))
  --тут ограничено только 3 и 4 цехом
  AND IdArea in (5,6)
  AND Article = @article
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
  PRINT 'Залив прыгающих ТМ   3 и 4'
  INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
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
	  ,vi.REL
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											as r
  INNER JOIN [SupportData].[TempJumpSemiProduct]					as jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](jump.IdSemiProduct)	as vi
  ORDER BY IdRout , NPP
 

   --Все для 3 и 4 цеха кроме маршрутов с Jump - стандарт, подготовлено технологами 
	PRINT 'Все для 3 и 4 цеха кроме маршрутов с Jump - стандарт, подготовлено технологами'

	INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
	SELECT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
  FROM [InputData].[VI_OperationsStandardRoutes]	AS vi
	INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
	INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	WHERE art.Title =  @article												  
  AND ((Code = 'OP03' AND AreaId = 5) 
  OR (Code = 'OP04' AND AreaId = 6))
  AND vi.IdSemiProduct NOT IN (SELECT  j.IdSemiProduct FROM [SupportData].[TempJumpSemiProduct] as j)
  ORDER BY vi.[IdSemiProduct], [OperOrder]

    --Чистим таблицу от прошлых прыгающих ТМок
  PRINT 'Чистим таблицу от прошлых прыгающих ТМок'
  TRUNCATE TABLE [SupportData].[TempJumpSemiProduct]

   PRINT 'Выборка таких маршрутов 9/1 цеха, которые могут "прыгать из цеха в цех"'
   --Выборка таких маршрутов 9/1 цеха, которые могут "прыгать из цеха в цех"
  INSERT INTO [SupportData].[TempJumpSemiProduct]
  SELECT
       Article
	  ,mr.IdMergeRoutes
	  ,IdSemiProduct
	  ,mr.BaseAreaId
	  ,mr.ChildAreaId
	  ,mr.KtopChildRoute
	  ,mr.KtopPrentRoute
   FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	as vifast
   INNER JOIN [InputData].[Areas]							as area ON area.Code = vifast.Code
   CROSS JOIN [SupportData].[MergeRoutes]					as mr
   WHERE ((mr.BaseAreaId = area.IdArea and vifast.KTOPN = mr.KtopPrentRoute) 
   OR (mr.ChildAreaId = area.IdArea and vifast.KTOPN = mr.KtopChildRoute))
   AND IdArea in (8)
   AND Article = @article
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
  PRINT 'Залив прыгающих ТМ '
  INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
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
	  ,vi.REL
	  ,0 -- isMappingRule
  FROM [InputData].[Rout]											AS r
  INNER JOIN [SupportData].[TempJumpSemiProduct]					AS jump ON jump.IdSemiProduct = r.SemiProductId
																	AND jump.BaseAreaId = r.AreaId
  CROSS APPLY [InputData].[udf_GetMergedRouteForSemiProduct](jump.IdSemiProduct)	AS vi


   --Все для 9/1 цеха кроме маршрутов с Jump
  PRINT 'Все для 9/1 цеха кроме маршрутов с Jump'
	INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
	SELECT [IdRout]
      ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,[IdProfession]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[OperOrder]
      ,[Code]
      ,[NPP]
      ,[KTOPN]
      ,[REL]
      ,[isMappingRule]
  FROM [InputData].[VI_OperationsStandardRoutes] AS vi
	INNER JOIN [InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
	INNER JOIN [InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	WHERE art.Title =  @article												  													  
  AND (Code = 'OP09' and AreaId = 8)
  and vi.IdSemiProduct not in (SELECT  j.IdSemiProduct FROM [SupportData].[TempJumpSemiProduct] as j)
  ORDER BY vi.[IdSemiProduct], [OperOrder]

  --Все маршруты для 9/1 для которых нет операций ТМ в базе (пробуем создать операции автоматом)
  PRINT 'Все маршруты для 9/1 для которых нет операций ТМ в базе (пробуем создать операции автоматом)'
  DECLARE @routes AS TABLE (IdRoute int, Article nvarchar(99))
  INSERT INTO @routes
  SELECT DISTINCT
	  r.IdRout
	 ,art.Title AS Article
  FROM [InputData].[Rout]				AS r
  INNER JOIN [InputData].[SemiProducts] AS sp	ON sp.IdSemiProduct = r.SemiProductId
  INNER JOIN [InputData].[Nomenclature] AS nom	ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]		AS art	ON art.IdArticle = nom.ArticleId
  WHERE  r.AreaId = 8  AND  r.IsAutoGenerated = 1
  AND art.Title = @article
 
  -- Маппим 1 в 9/1
  INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
  SELECT  DISTINCT
	   IdRout
	  ,[InputData].[udf_GetTitleOperation] (KTOPChild, so.Title) as TitleOperation
      ,SemiProductId
      ,IdProfesson	AS [idProfesson]
      ,4 as [TypeTime]
	  ,MAP.CategoryOperation
	  ,so.OperOrder
	  ,MAP.Code												                              as Code
	  ,ROW_NUMBER() over(partition by FAS.[IdSemiProduct] order by so.OperOrder) * 10 as NPP
	  ,KTOPChild
	  ,MAP.REL
	  ,1 -- 1 - значит это автоматически замапленные ТМ
   FROM [InputData].[VI_OperationsAfterMapping]										AS MAP
   INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = MAP.KTOPChild
   RIGHT JOIN  [InputData].[VI_OperationsWithSemiProducts_FAST]						AS FAS	ON FAS.IdSemiProduct = SemiProductId
																							AND FAS.KTOPN =  KTOPParent
   INNER JOIN [InputData].[SemiProducts] AS sp	ON sp.IdSemiProduct = MAP.SemiProductId
  INNER JOIN [InputData].[Nomenclature] AS nom	ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]		AS art	ON art.IdArticle = nom.ArticleId
WHERE art.Title = @article  
AND IdArea IN (8)

	--Залив финала 1 цех
		PRINT 'Залив финала 1 цех'								 
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
	FROM [SupportData].[TempOperationsForInsertingOperations]						as t
	INNER JOIN [InputData].[Rout]	as r ON t.idRout = r.IdRout 
	INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [InputData].[Nomenclature] as n  ON n.IdNomenclature = sp.NomenclatureID
	INNER JOIN [InputData].[Article]	  as art ON art.IdArticle = n.ArticleId
	WHERE Code = 'OP01' and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0 
	and r.AreaId = 3   -- поставил тут еще фильтр по цеху потому что ОП01 встречается и в ТМ 9го цеха при прыжках
	AND art.Title = @article
	ORDER BY 
		t.idRout
		,OperOrder*10	
		,TitleOperPr
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code

--Залив финала 1 c jump, и 2 цех и 6/1, 7/1, 8/1, 9/2 цех и 5 цех
	PRINT 'Залив финала 1 c jump, и 2 цех и 6/1, 7/1, 8/1, 9/2 цех и 5 цех'																						   
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
		,(SELECT TOP(1) NPP FROM [SupportData].[TempOperationsForInsertingOperations] as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		,IsMappingRule
		FROM [SupportData].[TempOperationsForInsertingOperations] as tt
		WHERE Code  in ('OP01', 'OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04', 'OP05') and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0
		and idrout not in (SELECT DISTINCT t.idRout
							FROM [SupportData].[TempOperationsForInsertingOperations]						as t
							INNER JOIN [InputData].[Rout]	as r ON t.idRout = r.IdRout 
							WHERE Code = 'OP01' and LEN(RTRIM(LTRIM(TitleOperPr))) <> 0 and r.AreaId = 3  )
		
		ORDER BY idRout, NPP

		--Заливаем в КТОПы
		PRINT 'Заливаем в КТОПы		TitleOperPr'											 
		INSERT INTO [InputData].[OperationWithKTOP]
 		SELECT DISTINCT
		oper.IdOperation
		,t.KTOPN
		,FIRST_VALUE(t.REL) OVER(PARTITION BY IdOperation, KTOPN ORDER BY IdOperation)
		FROM [SupportData].[TempOperationsForInsertingOperations]							as t
		INNER JOIN [InputData].[Operations] as oper ON oper.Title = t.TitleOperPr
													AND oper.RoutId = t.idRout
													AND oper.CategoryOperation = t.CategoryOperation
		INNER JOIN [InputData].[Rout]	as r ON t.idRout = r.IdRout 
		INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
		INNER JOIN [InputData].[Nomenclature] as n  ON n.IdNomenclature = sp.NomenclatureID
		INNER JOIN [InputData].[Article]	  as art ON art.IdArticle = n.ArticleId
		WHERE oper.Code in ('OP01', 'OP02','OP61', 'OP71', 'OP81', 'OP09', 'OP03', 'OP04', 'OP05')
		AND art.Title = @article
                                                
	--Очищаем таблицу
	print 'Заливаем операции в альт. ТМ'
	DELETE FROM [SupportData].[TempOperationsForInsertingOperations]
	TRUNCATE TABLE  [SupportData].[TempOperationForMapping]
	--Заливаем в нее данные для переходящих маршрутов
	--Маршруты для 18 ПФ для которых нет операций для альтернативных цехов
INSERT INTO [SupportData].[TempOperationsForInsertingOperations]
SELECT DISTINCT
      IdRout
	  ,[InputData].[udf_GetTitleOperation](KTOPChild, SO.Title)					AS TitleOperation
      ,SemiProductId
      ,IdProfesson																	AS [idProfesson]
	  ,4																			AS [TypeTime]																	
	  ,MAP.CategoryOperation
      ,SO.OperOrder
	  ,MAP.Code
	  ,MIN(NPP) OVER(PARTITION BY  IdRout, [InputData].[udf_GetTitleOperation](KTOPChild, SO.Title)) AS NPP
	  ,KTOPChild
	  ,MAP.REL
	  ,0
   FROM [InputData].[VI_OperationsAfterMapping]										AS MAP

  INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = MAP.KTOPChild
  RIGHT JOIN  [InputData].[VI_OperationsWithSemiProducts_FAST]						AS FAS	ON FAS.IdSemiProduct = SemiProductId
																							AND FAS.KTOPN =  KTOPParent													 
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = MAP.SemiProductId
  INNER JOIN [InputData].[Nomenclature] as n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]	  as art ON art.IdArticle = n.ArticleId
  WHERE IdArea IN (9,13,14,20)
  AND art.Title = @article

 -- -- Залив во временную таблицу все операции которые маппили (потом пригодится при расстановке операций на оборудование)
	print 'Залив во временную таблицу все операции которые маппили (потом пригодится при расстановке операций на оборудование)'																																																							
  DELETE FROM [SupportData].[TempOperationForMapping]
   INSERT INTO [SupportData].[TempOperationForMapping]
  SELECT [IdRout]
		   
      ,[TitleOperation]
      ,[SemiProductId]
      ,[idProfesson]
      ,[CategoryOperation]
      ,[Code]
      ,[KTOPChild]
      ,[KOBChild]
      ,[NormaTimeNew]
      ,[REL]																													   												
  FROM [InputData].[VI_OperationsAfterMapping] AS MAP
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = MAP.SemiProductId
  INNER JOIN [InputData].[Nomenclature] as n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]	  as art ON art.IdArticle = n.ArticleId
  WHERE art.Title = @article
  
  
 -- залив финала  6/1, 7/1, 8/1, 9/2 цех переходящие маршруты
 print 'залив финала  6/1, 7/1, 8/1, 9/2 цех переходящие маршруты'
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
		FROM [SupportData].[TempOperationsForInsertingOperations] as tt
		ORDER BY idRout, NPP

		----Залив Опер - ктоп
		print 'Залив Опер - ктоп'								
		INSERT INTO OperationWithKTOP
 		SELECT DISTINCT
		oper.IdOperation
		,t.KTOPN
		,FIRST_VALUE(t.REL) OVER(PARTITION BY IdOperation, KTOPN ORDER BY IdOperation)
		FROM [SupportData].[TempOperationsForInsertingOperations]							as t
		INNER JOIN [InputData].[Operations] as oper ON oper.Title = t.TitleOperPr
													AND oper.RoutId = t.idRout
													AND oper.CategoryOperation = t.CategoryOperation
		WHERE oper.Code in ('OP61', 'OP71', 'OP81', 'OP09')
		
RETURN 0
