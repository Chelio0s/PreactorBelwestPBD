CREATE FUNCTION [InputData].[udf_GetMergedRouteForSemiProduct]
(
	@IdSemiProduct int
)
RETURNS @returntable TABLE
(
   IdNomenclature		int
  ,Article				nvarchar(99)
  ,Model				nvarchar(99)
  ,Nomenclature			nvarchar(99)
  ,Size					decimal(6,2)
  ,IdSemiProduct		int
  ,TitleSemiProd		nvarchar(99)
  ,KPO					nvarchar(99)
  ,Code					nvarchar(99)
  ,ktopn				int
  ,NTOP					nvarchar(99)
  ,PONEOB				int
  ,normatime			decimal(6,2)
  ,KOB					int
  ,MOB					nvarchar(99)
  ,KPROF				int
  ,IdProfession			int
  ,CategoryOperation	int
  ,TitlePreactorOper	nvarchar(99)
  ,SimpleProductId		int
  ,OperOrder			int
  ,REL					int
  ,NPP					int
  ,IdArea				int
  ,areaCode				nvarchar(99)
  ,areaTitle			nvarchar(99)
  ,areaKPO				nvarchar(99)
  ,areaKPODTO			int
  ,jumpArticle			nvarchar(99)
  ,jumpIdMergeRoutes	int
  ,jumpIdSemiProduct	int
  ,jumpBaseAreaId		int
  ,jumpChildAreaId		int
  ,jumpKtopChildRoute	int
  ,jumpKtopParentRoute	int
)
AS
BEGIN
 
 DECLARE @SimpleProductTypeId int 
 SELECT TOP(1) @SimpleProductTypeId =  [SimpleProductId] FROM [InputData].[SemiProducts]
														 WHERE IdSemiProduct = @IdSemiProduct

 IF @SimpleProductTypeId IS NULL
 BEGIN 
   RETURN
 END

 IF @SimpleProductTypeId = 20
 BEGIN
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
		  --тут ограничено пока (надеюсь навсегда) только 3 и 4 цехом
		  AND IdArea in (5,6)
		  AND IdSemiProduct = @IdSemiProduct

		  GROUP BY   
			   Article
			  ,mr.IdMergeRoutes
			  ,IdSemiProduct
			  ,mr.BaseAreaId
			  ,mr.ChildAreaId
			  ,mr.KtopChildRoute
			  ,mr.KtopPrentRoute
		  HAVING COUNT(mr.IdMergeRoutes) = 2
		  INSERT @returntable
		  SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,poneob
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute 
			  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct
																			AND (jump.BaseAreaId = area.IdArea 
																			OR   jump.ChildAreaId = area.IdArea)
		  WHERE NPP <= (SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] 
						WHERE IdSemiProduct = vifast.IdSemiProduct AND KTOPN = jump.KtopParentRoute)
				AND area.IdArea = jump.BaseAreaId
		  UNION 
		  SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,poneob
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,(SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] WHERE IdSemiProduct = vifast.IdSemiProduct AND KTOPN = jump.KtopParentRoute) 
			  + ROW_NUMBER() OVER(PARTITION BY vifast.IdSemiProduct, size, vifast.Code  ORDER BY vifast.IdSemiProduct, size, vifast.Code, NPP) AS NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute
		  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]				AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct
																			AND (jump.BaseAreaId = area.IdArea 
																			OR   jump.ChildAreaId = area.IdArea)
		  WHERE jump.ChildAreaId = area.IdArea
		  UNION 
		  SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,poneob
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute
		  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct
																			AND (jump.BaseAreaId = area.IdArea 
																			OR   jump.ChildAreaId = area.IdArea)
		  WHERE NPP > (SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] 
					   WHERE IdSemiProduct = vifast.IdSemiProduct 
					   AND KTOPN = jump.KtopParentRoute)
					   AND area.IdArea = jump.BaseAreaId
		  ORDER BY   vifast.IdSemiProduct, NPP
		  RETURN
	 END

    IF @SimpleProductTypeId = 1
	BEGIN 
	    -- Получаем маркеры по которым будем собирать маршрут
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

		  AND vifast.SimpleProductId = @SimpleProductTypeId and IdArea in (8)
		  AND IdSemiProduct = @IdSemiProduct

		  GROUP BY   
			   Article
			  ,mr.IdMergeRoutes
			  ,IdSemiProduct
			  ,mr.BaseAreaId
			  ,mr.ChildAreaId
			  ,mr.KtopChildRoute
			  ,mr.KtopPrentRoute
		  HAVING COUNT(mr.IdMergeRoutes) = 2

		  INSERT INTO @returntable
		  --Выбираем все операции до отправки в другой цех
		  SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,poneob
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct
																			AND (jump.BaseAreaId = area.IdArea 
																			OR   jump.ChildAreaId = area.IdArea)
		  WHERE NPP <= (SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] 
						WHERE IdSemiProduct = vifast.IdSemiProduct AND KTOPN = jump.KtopParentRoute)
				AND area.IdArea = jump.BaseAreaId

        UNION
		-- Все операции в другом цехе
		SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,PONEOB
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,(SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] WHERE IdSemiProduct = vifast.IdSemiProduct AND KTOPN = jump.KtopParentRoute) 
			  + ROW_NUMBER() OVER(PARTITION BY vifast.IdSemiProduct, size, vifast.Code  ORDER BY vifast.IdSemiProduct, size, vifast.Code, NPP) AS NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute
		  FROM [InputData].[VI_OperationsWithSemiProducts_FAST]	AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct AND area.IdArea = 3
		 --Только на эти коды могут отправлять в 1 цех крой
		 WHERE KTOPN IN (104,204,139,203,293,118,264,120,269,257,246,235,245,159,155,233,236,234,263,237,270,191,267,272,252,248,218, 280,278,295,196,255,281,283,161,211,178,165,167,243)
		 UNION 
		 -- Все операции после приемки с 1 цеха 
		 SELECT IdNomenclature
			  ,vifast.Article
			  ,Model
			  ,Nomenclature
			  ,Size
			  ,vifast.IdSemiProduct
			  ,vifast.Title
			  ,vifast.KPO
			  ,vifast.Code
			  ,ktopn
			  ,NTOP
			  ,poneob
			  ,normatime
			  ,KOB
			  ,MOB
			  ,KPROF
			  ,IdProfession
			  ,CategoryOperation
			  ,TitlePreactorOper
			  ,vifast.SimpleProductId
			  ,OperOrder
			  ,REL
			  ,NPP
			  ,area.IdArea
			  ,area.Code
			  ,area.Title
			  ,area.KPO
			  ,area.KPODTO
			  ,jump.Article
			  ,jump.IdMergeRoutes
			  ,jump.IdSemiProduct
			  ,jump.BaseAreaId
			  ,jump.ChildAreaId
			  ,jump.KtopChildRoute
			  ,jump.KtopParentRoute FROM [InputData].[VI_OperationsWithSemiProducts_FAST]		AS vifast
		  INNER JOIN [InputData].[Areas]									AS area ON area.Code = vifast.Code COLLATE Cyrillic_General_BIN
		  INNER JOIN @JumpSemiProducts										AS jump ON jump.IdSemiProduct = vifast.IdSemiProduct
																			AND (jump.BaseAreaId = area.IdArea 
																			OR   jump.ChildAreaId = area.IdArea)
		  WHERE NPP > (SELECT NPP FROM [InputData].[VI_OperationsWithSemiProducts_FAST] 
					   WHERE IdSemiProduct = vifast.IdSemiProduct 
					   AND KTOPN = jump.KtopParentRoute)
					   AND area.IdArea = jump.BaseAreaId
		  ORDER BY   vifast.IdSemiProduct, NPP
	END
 RETURN
 END