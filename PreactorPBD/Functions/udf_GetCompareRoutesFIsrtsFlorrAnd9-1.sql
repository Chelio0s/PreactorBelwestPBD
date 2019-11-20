-- Compare ROUTE from 1st floor and automatical 9-1 floor route
CREATE FUNCTION [InputData].[udf_GetCompareRoutesFIsrtsFlorrAnd9-1]
(
	@article nvarchar(99)
)
RETURNS @returntable TABLE
(
	   KTOPN				int
	   ,NTOP				nvarchar(99)
	   ,KOB					int			
	   ,NORMATIME			decimal(6,2)
	   ,KPROFOrig			int
	   ,categoryOper		int
	   ,KTOPParent			int
	   ,KOBParent			int
	   ,KTOPChild			int
	   ,TitleOperNew		nvarchar(99)
	   ,KOBChild			int
	   ,normatimenew		decimal(6,2)
	   ,KPROFNew			int
	   ,categoryoperation	int
)
AS
BEGIN
	 DECLARE @temp as table ( IdRout  int
	  , TitleArticle nvarchar(99)
	  , SemiProductId int 
	  , Size int 
	  , AreaId int
	  , KOBParent int
	  , KOBChild int
	  , KTOPParent int
	  , KTOPChild int
	  , normatimeold decimal(6,2)
	  , normatimenew decimal(6,2)
	  , categoryoperation int
	  , KPROF int )
	 INSERT INTO @temp
	 SELECT DISTINCT 
	  vi.IdRout 
	  , vi.TitleArticle
	  , vi.SemiProductId 
	  , vi.Size 
	  , vi.AreaId
	  , KOBParent
	  , KOBChild
	  , KTOPParent
	  , KTOPChild
	  , fn.normatimeold
	  , fn.normatimenew
	  , fn.categoryoperation
	  , fn.KPROF
	  FROM  [InputData].[VI_RoutesWithArticle] as vi	
	  CROSS APPLY [InputData].[ctvf_GetAltRouteForFirstFloor](IdRout) as fn
	  WHERE TitleArticle in (@article) 
	  AND Size = (SELECT MAX(size) FROM [InputData].[VI_RoutesWithArticle] WHERE TitleArticle = vi.TitleArticle)
	  AND vi.AreaId = 3

	  DECLARE @tempvifast as table (
	  Article nvarchar(99)
	  ,size int
	  ,idSemiProduct int
	  ,Code nvarchar(4)
	  ,KTOPN int
	  ,NTOP nvarchar(99)
	  ,NORMATIME decimal(6,2)
	  ,KOB int
	  ,MOB nvarchar(99)
	  ,KPROF int
	  ,categoryOper int
	  ,NPP int
	  ,kold int)
	  INSERT INTO @tempvifast
	  SELECT   Article 
	  ,size 
	  ,idSemiProduct 
	  ,Code 
	  ,KTOPN 
	  ,NTOP 
	  ,NORMATIME 
	  ,KOB 
	  ,MOB 
	  ,KPROF 
	  ,CategoryOperation 
	  ,NPP 
	  ,kold 
	   FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vifast
	   WHERE Article in (@article) and vifast.SimpleProductId < 18
	   AND SIZE = (SELECT MAX(size) FROM [InputData].[VI_OperationsWithSemiProducts_FAST] 
	                                 WHERE Article = vifast.Article) 
	   AND code = 'OP01'

	   INSERT INTO @returntable
	   SELECT 
	   KTOPN
	   ,NTOP
	   ,KOB
	   ,NORMATIME
	   ,vifast.KPROF
	   ,vifast.categoryOper
	   ,KTOPParent
	   ,KOBParent
	   ,KTOPChild
	   ,so.Title
	   ,KOBChild
	   ,normatimenew
	   ,proff.CodeRKV
	   ,temp.categoryoperation
	   FROM @temp as temp
	   FULL OUTER JOIN @tempvifast as vifast ON temp.TitleArticle = vifast.Article
											 AND temp.KTOPParent = vifast.ktopn
	   LEFT JOIN [SupportData].[SequenceOperations] as SO ON so.KTOP = KTOPChild
	   LEFT JOIN [InputData].[Professions] as proff ON proff.[IdProfession]  = temp.KPROF
	   LEFT JOIN [InputData].[Professions] as proff2 ON proff2.CodeRKV = vifast.KPROF
	   ORDER BY vifast.NPP
	RETURN
END
