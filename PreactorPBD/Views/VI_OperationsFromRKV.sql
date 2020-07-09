CREATE VIEW [InputData].[VI_OperationsFromRKV]	AS 
--Выборка операций на артикул с РКВ
SELECT  DISTINCT 
		D.REL
		,D.KPO
		,D.KUCH
		,F13.ART as ART
		,D.MOD
		,D.NPP
		,OP.NTOP
		,D.KTOPN
		,D.NORMA
		,OP.RD
		,OP.KPROF
		,P.NPROF
		,D.RUCH
		,D.PONEOB
		,D.KOB
		,OBR.MOB
		,KOLD
		,KOLN
FROM  [$(RKV)].[$(RKV_SCAL)].dbo. F160013		AS F13 
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.drive	AS D		ON F13.MOD=D.MOD
	-- DRIVE0 должен быть большими буквами, не трогать
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.DRIVE0	AS ART		ON D.REL=ART.REL AND F13.ART=ART.ART
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_top2	AS OP		ON OP.KTOP=D.KTOPN
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_prof2	AS P		ON P.KPROF=OP.KPROF
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_obor2	AS OBR		ON OBR.KOB = D.KOB
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.[status] AS ST		ON ST.MOD = D.MOD AND ST.KPO = D.KPO
WHERE        (D.NORMA <> 0)  AND ST.PR_UD2<>3