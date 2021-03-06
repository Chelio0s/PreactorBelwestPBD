﻿CREATE VIEW [InputData].[VI_OperationsFromRKV]	AS 
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
FROM  [$(RKV)].[$(RKV_SCAL)].dbo. F160013		as F13 
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.drive	as D		on F13.MOD=D.MOD
	-- DRIVE0 должен быть большими буквами, не трогать
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.DRIVE0	as ART		on D.REL=ART.REL and F13.ART=ART.ART
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_top2	as OP		on OP.KTOP=D.KTOPN
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_prof2	as P		on P.KPROF=OP.KPROF
	INNER JOIN [$(RKV)].[$(PLANT)].dbo.s_obor2	as OBR		on OBR.KOB = D.KOB
WHERE  D.NORMA <> 0
