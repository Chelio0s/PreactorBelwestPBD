CREATE FUNCTION [InputData].[udf_CanIMapSecondFloor]
(
	@RoutId int
	,@AreaId int
)
RETURNS BIT
AS
BEGIN
DECLARE @Ret bit
 
DECLARE @table as table (    Article			nvarchar(99)
							,KTOPN				int
							,KOB				int
							,TitlePreactorOper	nvarchar(99)
							,NORMATIME			decimal(6,2)	
							,NPP				int
							,ktopparent			int
							,kobparent			int
							,KTOPChild			int
							,KOBChild			int
							,NORMATIMEOld		dec(6,2)
							,NormaTimeNew		dec(6,2)) 

  
		IF @AreaId = 20
		BEGIN
		INSERT INTO @table
			SELECT
			vi.Article 
			,vi.KTOPN
			,vi.kob
			,vi.TitlePreactorOper
			,vi.NORMATIME
			,vi.npp
			,t.ktopparent
			,t.kobparent
			,t.KTOPChild
			,t.KOBChild
			,t.NormaTimeOld
			,t.NormaTimeNew
			FROM 
			(
						SELECT DISTINCT 	
						  r.IdRout
						  ,Article
						  ,[TitlePreactorOper]
						  ,vi.[IdSemiProduct]
						  ,vi.[IdProfession]
						  ,CategoryOperation
						  ,Code
						  ,KTOPN
						  ,KOB
						  ,NORMATIME AS NormaTime
						  ,NPP
					  FROM [InputData].[Rout] as r
					  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
					  WHERE Code = 'OP02' 
							AND vi.[IdSemiProduct] = r.SemiProductId 
							AND KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout) AS fn) -- Недоступные операции для данного маршрута
							AND SimpleProductId = 18 -- Убираем натуральную стельку. //todo: Возможно нужно будет заменить на др ПФ. 
							AND IdRout = @RoutId
							AND KTOPN NOT IN (349, 598, 311, 360, 494, 594, 475, 401) -- Вырубаем операции, которых в теории может не быть в ТМ
			) as vi
			FULL JOIN (SELECT * FROM [InputData].[ctvf_GetAltRouteForSecondFloor](@RoutId, @AreaId)) as t ON t.ktopparent = vi.ktopn
																									  AND t.kobparent = vi.KOB
			WHERE KTOPParent IS NULL
	
			ORDER BY NPP
		END
		ELSE
		BEGIN
	    INSERT INTO @table 
			SELECT
			vi.Article 
			,vi.KTOPN
			,vi.kob
			,vi.TitlePreactorOper
			,vi.NORMATIME
			,vi.npp
			,t.ktopparent
			,t.kobparent
			,t.KTOPChild
			,t.KOBChild
			,t.NormaTimeOld
			,t.NormaTimeNew
			FROM 
			(
						SELECT DISTINCT 	
						  r.IdRout
						  ,Article
						  ,[TitlePreactorOper]
						  ,vi.[IdSemiProduct]
						  ,vi.[IdProfession]
						  ,CategoryOperation
						  ,Code
						  ,KTOPN
						  ,KOB
						  ,NORMATIME AS NormaTime
						  ,NPP
					  FROM [InputData].[Rout] as r
					  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
					  WHERE Code = 'OP02' 
							AND vi.[IdSemiProduct] = r.SemiProductId 
							AND KTOPN not in (SELECT fn.KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout) AS fn) -- Недоступные операции для данного маршрута
							AND SimpleProductId = 18 -- Убираем натуральную стельку. //todo: Возможно нужно будет заменить на др ПФ. 
							AND IdRout = @RoutId
							AND KTOPN NOT IN (349, 598, 311, 360, 494, 594, 475, 401) -- Вырубаем операции, которых в теории может не быть в ТМ
			) as vi
			FULL JOIN (SELECT * FROM [InputData].[ctvf_GetAltRouteForSecondFloor](@RoutId, @AreaId)) as t ON t.ktopparent = vi.ktopn
																									  AND t.kobparent = vi.KOB
			WHERE KTOPParent IS NULL
	
			ORDER BY NPP
		END
		--если есть не спаставленные записи, то такой ТМ не маппится
		SELECT @ret = CASE WHEN COUNT(*)  > 0 THEN CONVERT(bit, 'false') ELSE CONVERT(bit, 'true')  END  FROM @table
		RETURN @ret
END
