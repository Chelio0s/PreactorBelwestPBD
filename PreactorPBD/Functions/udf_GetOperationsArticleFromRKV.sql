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
	,RD int
	,KOB varchar(5)
	,MOB varchar(199)
	,NPP int
)
AS
BEGIN
	INSERT @returntable
SELECT DISTINCT 
 ART
,[MOD]
,REL 
,KPO 
,KTOPN 
,NTOP as NTOP
,PONEOB
,NORMA as NORMATIME
,KPROF as KPROF
,RD
,KOB 
,MOB
,NPP
FROM  VI_OperationsFromRKV
WHERE ART = @article
ORDER BY KPO
	RETURN
END
