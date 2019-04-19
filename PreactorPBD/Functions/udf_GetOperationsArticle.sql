CREATE FUNCTION [InputData].[udf_GetOperationsArticleFromRKV]
(
	@article varchar(15)
)
RETURNS @returntable TABLE
(
	 ART  varchar(15)
	,[MOD] varchar(15)
    ,REL  varchar(15)
    ,KPO  varchar(15)
	,KTOPN  int
	,NTOP  varchar(199)
	,PONEOB bit
	,NORMATIME decimal(8,2)
	,KPROF varchar(5)
	,KOB varchar(5)
	,MOB varchar(199)
)
AS
BEGIN
	INSERT @returntable
SELECT DISTINCT 
RTRIM(F13.ART) as ART
,D.[MOD]
,D.REL 
,D.KPO 
,D.KTOPN 
,OP.NTOP as NTOP
,PONEOB
,D.NORMA as NORMATIME
,OP.KPROF as KPROF
,D.KOB
,OBR.MOB
FROM  [RKV].PLANT.dbo.drive as D 
INNER JOIN [RKV].RKV_SCAL.dbo.F160013  as F13 on D.MOD=F13.MOD
INNER JOIN [RKV].[PLANT].dbo.status as  S  on S.MOD=D.MOD AND S.KPO=D.KPO
INNER JOIN [RKV].[PLANT].dbo.DRIVE0 as ART on D.REL=ART.REL and F13.ART=ART.ART
INNER JOIN [RKV].[PLANT].dbo.s_top2 as  OP on OP.KTOP=D.KTOPN
LEFT JOIN  [RKV].PLANT.dbo.s_obor2 OBR on D.KOB=OBR.KOB 
WHERE S.PR_UD2=0  
and D.KTOPN <> 0 
and RTRIM(F13.ART) = @article
ORDER BY KPO

	RETURN
END
