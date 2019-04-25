 CREATE VIEW [InputData].[VI_OperationsFromRKV]	AS 

SELECT DISTINCT 
D.REL
,RTRIM(F.ART) as ART
,D.KPO 
,D.KTOPN 
,OP.NTOP as NTOP
,KOB
,NORMA
FROM  [$(RKV)].[$(PLANT)].dbo.drive as D 
INNER JOIN [$(RKV)].[$(RKV_SCAL)].dbo.F160013  as F on D.MOD=F.MOD
INNER JOIN [$(RKV)].[$(PLANT)].dbo.status as  S  on S.MOD=D.MOD AND S.KPO=D.KPO
INNER JOIN [$(RKV)].[$(PLANT)].dbo.drive0 as artdrive on D.REL=artdrive.REL and F.ART = artdrive.ART
INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_top2 as  OP on OP.KTOP=D.KTOPN
WHERE S.PR_UD2=0  and D.KTOPN <> 0