CREATE PROCEDURE [InputData].[sp_InsertRoutesSingleArticle]
	@article nvarchar(99)
AS

	DELETE [InputData].[Rout] 
    FROM [InputData].[Rout]                 AS r
    INNER JOIN [InputData].[SemiProducts]   AS sp ON sp.IdSemiProduct = r.SemiProductId
    INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
    INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
    WHERE a.Title = @article

  --Инсерт ТМ с правилами для заготовки цех 2
  INSERT INTO [InputData].[Rout]
             ([Title]
             ,[SemiProductId]
             ,[Priority]
             ,[CombineId]
  		   ,AreaId)
  
  SELECT DISTINCT
       'ТМ с набором операций '+CONVERT(NVARCHAR(10), cc.RuleId) +'/'+ CONVERT(NVARCHAR(10), cc.RuleIsParent) + ' для ПФ ' + sp.Title + ' цех 2'  AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,4
  FROM [SupportData].[CombineComposition]   AS cc
  INNER JOIN [SupportData].[CombineRules]   AS cr ON cc.[CombineRulesId] = cr.[IdCombineRules]
  INNER JOIN [InputData].[SemiProducts]     AS sp ON sp.IdSemiProduct = [SemiProductId]
  INNER JOIN [InputData].[Nomenclature]     AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]          AS a  ON a.IdArticle = n.ArticleId
  WHERE sp.SimpleProductId in (18,19) AND  a.Title = @article

  --Инсерт ТМ всех остальных для 2 цеха
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 2'
  , IdSemiProduct
  ,10
  ,NULL
  ,4
  FROM [InputData].[SemiProducts]         AS sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) 
  AND  SimpleProductId in (18, 19)
  AND  a.Title = @article


  --Инсерт ТМ с правилами для кроя цех 1
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId
           ,IsComplex)


	SELECT DISTINCT
        'ТМ с набором операций комплекс'+CONVERT(NVARCHAR(10), cc.RuleId) +'/'+ CONVERT(NVARCHAR(10), cc.RuleIsParent) + ' для ПФ ' + sp.Title + ' цех 1'  AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,3
      ,1
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = [SemiProductId]
  INNER JOIN [InputData].[VI_SemiProductsWithArticles] as visp ON visp.IdSemiProduct = SemiProductId
  LEFT JOIN [InputData].[VI_RulesWithOperations] as vi ON vi.IdRule = cc.RuleId
  WHERE sp.SimpleProductId in (1) 
  AND ((parentKTOP  IN (125,127,209,226,217,219,126) 
		AND cc.RuleIsParent = 1) OR 
		(childKTOP  IN (125,127,209,226,217,219,126) 
		AND cc.RuleIsParent = 0))
  --AND visp.IsComplex = 1 Закоментил потому что разделять ТМ все же надо
  AND visp.TitleArticle = @article

 INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId
           ,IsCutters)
  SELECT DISTINCT
       'ТМ с набором операций резаки: '+CONVERT(NVARCHAR(10), cc.RuleId)+ 'для ПФ ' + sp.Title  + ' цех 1' AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
	  ,3
      ,1
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = [SemiProductId]
  INNER JOIN [InputData].[VI_SemiProductsWithArticles] as visp ON visp.IdSemiProduct = SemiProductId
  LEFT JOIN [InputData].[VI_RulesWithOperations] as vi ON vi.IdRule = cc.RuleId
  WHERE sp.SimpleProductId in (1) 
  AND ((parentKTOP NOT IN (125,127,209,226,217,219,126) 
		AND cc.RuleIsParent = 1) OR 
		(childKTOP NOT IN (125,127,209,226,217,219,126) 
		AND cc.RuleIsParent = 0))
  --AND visp.IsCutters = 1 Закоментил потому что разделять ТМ все же надо
  AND visp.TitleArticle = @article
  

  --Инсерт ТМ для кроя для 1 цеха для остальных артикулов, у которых нет ТМ с правилами
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 1'
  , IdSemiProduct
  ,10
  ,NULL
  ,3
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) 
  AND SimpleProductId in (1)
  AND a.Title = @article



   --Инсерт ТМ всех остальных для других цехов
   --Инсерт ТМ с правилами
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 1'
  , IdSemiProduct
  ,10
  ,NULL
  ,3
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout]) 
  AND SimpleProductId in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,17)
  AND a.Title = @article

  -- Стандартный ТМ для 9/1 - тот что есть в РКВ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT DISTINCT 'Стандартный ТМ для ПФ '+ sp.Title +  ' цех 9/1'
  , vi.IdSemiProduct
  ,10
  ,NULL
  ,8
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] AS vi 
  INNER JOIN [InputData].[SemiProducts]                 AS sp ON sp.IdSemiProduct = vi.IdSemiProduct
  INNER JOIN [InputData].[Nomenclature]                 AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]                      AS a  ON a.IdArticle = n.ArticleId
  INNER JOIN [InputData].[Areas]                        AS area ON area.Code = vi.Code COLLATE Cyrillic_General_BIN
  WHERE vi.Code in ('OP09') 
  AND vi.SimpleProductId in (1,2,3,4,5,6,7,8,9,10,11,12,13,15,17) 
  AND IdArea > 8
  AND a.Title = @article

  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 3'
  , IdSemiProduct
  ,10
  ,NULL
  ,5
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE  SimpleProductId in (20)
   AND a.Title = @article

    INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 4'
  , IdSemiProduct
  ,10
  ,NULL
  ,6
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE SimpleProductId in (20)
  AND a.Title = @article

      INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId)
  SELECT 'Стандартный ТМ для ПФ '+ sp.Title + ' цех 5'
  , IdSemiProduct
  ,10
  ,NULL
  ,7
  FROM [InputData].[SemiProducts] as sp
  INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
  WHERE SimpleProductId in 
  ( 30        -- - Формованная вкладная стелька
  , 1029      -- - Подошва
  , 1030      -- - Простил
  , 1031      -- - Подкаблучник
  , 29        -- - Стойка
  , 21        -- - Задник
  , 1032      -- - Вкладыши 5 цех
  , 19        -- - Стелька вкл. 
  )
  AND a.Title = @article

  -- создание ТМ для 6 7 8 9 цехов (стандартные ТМ) т.е. такие ТМ есть в РКВ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId])
  SELECT DISTINCT 
  'Cтандартный маршрут для цеха ' + area.Title+ ' для ПФ: '+ sp.Title COLLATE Cyrillic_General_BIN
     ,vi.IdSemiProduct
     ,10
	 ,NULL
	 ,area.IdArea
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi 
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = vi.IdSemiProduct
  INNER JOIN [InputData].[Areas] as area ON area.Code = vi.Code COLLATE Cyrillic_General_BIN
  WHERE vi.Code in ('OP61', 'OP71', 'OP81', 'OP09') AND vi.SimpleProductId = 18 AND IdArea > 8
  AND vi.Article = @article

print 'Создание авто переходящих маршрутов'
----Маппинг маршрутов для других цехов

 -- АВТО ТМ для 9/1  - МАППИНГ
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
		   ,AreaId
		   ,IsAutoGenerated
		   ,ParentRouteId)
  SELECT DISTINCT 'Автоматический ТМ для ПФ '+ sp.Title + ' цех 9/1'
  ,SemiProductId 
  ,10
  ,NULL
  ,8
  ,1
  ,FIRST_VALUE(R.IdRout) OVER(PARTITION BY 'Автоматический ТМ для '+ sp.Title + ' цех 9/1' ORDER BY SemiProductId)
  FROM [InputData].[Rout]					AS R  
  INNER JOIN [InputData].[SemiProducts]		AS SP ON SP.IdSemiProduct = R.SemiProductId
  INNER JOIN [InputData].[Nomenclature]     AS n  ON n.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]          AS a  ON a.IdArticle = n.ArticleId
  WHERE R.AreaId = 3 
  AND  SimpleProductId in (1,2,3,4,5,6,7,8,9,10,11,12,13,15) 
  AND (SemiProductId NOT IN (SELECT ROUT.SemiProductId FROM [InputData].[Rout] AS ROUT WHERE ROUT.AreaId = 8))
  AND [InputData].[udf_CanIMapFirstFloorRoute](R.IdRout) = CONVERT(bit, 'true')
  AND a.Title = @article


  --Создаем маршруты для 6/1 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' + COALESCE(RuleTitle, '') + ' для цеха 6/1 для ПФ: '+ sp.Title 
, SemiProductId
, 10
, CombineId
, 9
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 9)	AS ICan 
			   ,CAST(cc.RuleId as nvarchar(10))+'/'+CAST(cc.RuleIsParent as NVARCHAR(5)) as RuleTitle
			   ,r.CombineId
		  FROM  [InputData].[Rout] as R
           INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
           INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
           INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
		   LEFT JOIN [SupportData].[CombineComposition] as cc  on cc.CombineRulesId = r.CombineId 
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP61'
                                        AND fas.Article = @article)
		  AND AreaId = 4 
          AND a.Title = @article
) as t
INNER JOIN [InputData].[SemiProducts]           AS sp ON sp.IdSemiProduct = t.SemiProductId
INNER JOIN [InputData].[Nomenclature]           AS n  ON n.IdNomenclature = sp.NomenclatureID
INNER JOIN [InputData].[Article]                AS a  ON a.IdArticle = n.ArticleId

WHERE  ICan = 1 AND a.Title = @article

--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут '  + COALESCE(RuleTitle, '') +  ' для цеха 7/1 для ПФ: '+ sp.Title 
, SemiProductId
, 10
, CombineId
, 13
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 13)	AS ICan 
               ,CAST(cc.RuleId as nvarchar(10))+'/'+CAST(cc.RuleIsParent as NVARCHAR(5)) as RuleTitle
			   ,r.CombineId
		  FROM  [InputData].[Rout] as R
           INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
           INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
           INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
           LEFT JOIN [SupportData].[CombineComposition] as cc  on cc.CombineRulesId = r.CombineId 
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP71'
                                        AND fas.Article = @article)
		  AND AreaId = 4
          AND a.Title = @article
) as t
INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = t.SemiProductId
INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
WHERE  ICan = 1
AND a.Title = @article



--Создаем маршруты для 7 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут ' + COALESCE(RuleTitle, '') +  ' для цеха 8/1 для ПФ: '+ sp.Title 
, SemiProductId
, 10
, CombineId
, 14
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 14)	AS ICan 
                 ,CAST(cc.RuleId as nvarchar(10))+'/'+CAST(cc.RuleIsParent as NVARCHAR(5)) as RuleTitle
			   ,r.CombineId
		  FROM  [InputData].[Rout] as R
          INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
          INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
          INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
          LEFT JOIN [SupportData].[CombineComposition] as cc  on cc.CombineRulesId = r.CombineId 
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP81')
		  AND AreaId = 4
          AND a.Title = @article
) as t
INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = t.SemiProductId
INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
WHERE  ICan = 1 
AND a.Title = @article


--Создаем маршруты для 9/2 для ПФ 2 цеха
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId]
           ,[AreaId]   
		   ,IsAutoGenerated
		   ,ParentRouteId)
SELECT DISTINCT
'Альтернативный авто маршрут '  + COALESCE(RuleTitle, '') +   ' для цеха 9/2 для ПФ: '+ sp.Title 
, SemiProductId
, 10
, CombineId
, 20
, 1
, IdRout
FROM 
(
		SELECT 
				R.IdRout
			   ,R.[SemiProductId]
			   ,[InputData].[udf_CanIMapSecondFloor](R.IdRout, 20)	AS ICan 
               ,CAST(cc.RuleId as nvarchar(10))+'/'+CAST(cc.RuleIsParent as NVARCHAR(5)) as RuleTitle
			   ,r.CombineId
		  FROM  [InputData].[Rout] as R
           INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductId
           INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
           INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
           LEFT JOIN [SupportData].[CombineComposition] as cc  on cc.CombineRulesId = r.CombineId 
		  WHERE IdRout NOT IN (SELECT IdRout FROM [InputData].[VI_BannedRoutesForMapping])
		  AND R.SemiProductId NOT IN (	SELECT IdSemiProduct	 
										FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as fas
										WHERE fas.IdSemiProduct = R.SemiProductId AND Code = 'OP09')
		  AND AreaId = 4
          AND a.Title = @article
) as t
INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = t.SemiProductId
INNER JOIN [InputData].[Nomenclature]   AS n  ON n.IdNomenclature = sp.NomenclatureID
INNER JOIN [InputData].[Article]        AS a  ON a.IdArticle = n.ArticleId
WHERE  ICan = 1
AND a.Title = @article


--Удаляем лишние не согласованные между собой автомаршруты
DELETE [InputData].[Rout] 
FROM [InputData].[Rout]	as rout
INNER JOIN [InputData].[VI_SemiProductsWithArticles]		AS  visp    ON visp.IdSemiProduct = rout.SemiProductId
INNER JOIN [InputData].[VI_MissedAutoRoutesBetween9and92]   AS  vi      ON vi.articlefirst = visp.TitleArticle 
																	    OR vi.articlesecond = visp.TitleArticle
																	    AND (vi.AreaFirst = rout.AreaId or vi.areasecond = rout.AreaId)
WHERE IsAutoGenerated = 1 AND visp.TitleArticle = @article

RETURN 0
