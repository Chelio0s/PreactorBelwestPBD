CREATE PROCEDURE [InputData].[sp_InsertEmployeesInProffs]
AS
	if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
	CREATE table #tempEmp(tabno varchar(15), orgunit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), stell varchar(20), PROF_STELL varchar(99), PROF_TRFST varchar(99), PROF_TRFGR varchar(99), ENDDA varchar(99), prozt varchar(5))
insert #tempEmp
	EXEC[InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
		seller.tabno,
		orgunit,
		fio,
		trfst,
		trfs1,
		persg,
		stell,
		PROF_STELL,
		PROF_TRFST,
		PROF_TRFGR,
		ENDDA,
		prozt
		FROM
		belwpr.s_seller seller 
	LEFT JOIN belwpr.s_tab_stell_add  s_tab ON s_tab.tabno = seller.tabno
	WHERE  dated = ''31.12.9999'' and ESTPOST <> 99999999 and seller.tabno not like ''3%'' and prof_stell <>''00000000'' and prozt<>0 and trfst<>'' '''

	 
		ALTER TABLE #tempEmp
		ALTER COLUMN  STELL VARCHAR(99) COLLATE Cyrillic_General_BIN NULL;
		ALTER TABLE #tempEmp
		ALTER COLUMN  PROF_STELL VARCHAR(99) COLLATE Cyrillic_General_BIN NULL;

		DELETE FROM [InputData].[EmployeesInProfession]
  

IF object_id(N'tempdb..#tempPrimaryProf',N'U') is not null DROP TABLE #tempPrimaryProf
CREATE TABLE #tempPrimaryProf(tabno varchar(15), MAIN_STELL varchar(15), MAIN_TRFST VARCHAR(5), PROF_STELL varchar(15), PROF_TRFST varchar(5), isPrimary bit)
INSERT INTO  #tempPrimaryProf
           (tabno
		   ,MAIN_STELL
		   ,MAIN_TRFST
           ,PROF_STELL
           ,PROF_TRFST
           ,[IsPrimary])
SELECT DISTINCT  tabno, stell, trfst, stell, trfst, 1
FROM #tempEmp as sell
INNER JOIN [InputData].[Professions] as prof ON sell.stell = prof.IdProfession


INSERT INTO  #tempPrimaryProf
           (tabno
		   ,MAIN_STELL
		   ,MAIN_TRFST
           ,PROF_STELL
           ,PROF_TRFST
           ,[IsPrimary])
SELECT 
   tabno, 
   stell,
   trfst,
   PROF_STELL,
   MAX(PROF_TRFST) as PROF_TRFST, 0 
   FROM #tempEmp as sell
 INNER JOIN [InputData].[Professions] as prof ON sell.stell = prof.IdProfession

 group by  tabno, PROF_STELL,stell , trfst
 order by PROF_STELL

 DELETE FROM #tempPrimaryProf 
 WHERE  MAIN_STELL = PROF_STELL and isPrimary = 0 AND (MAIN_TRFST>PROF_TRFST or MAIN_TRFST=PROF_TRFST)

 INSERT INTO [InputData].[EmployeesInProfession]
			   ([EmployeeId]
			   ,[ProfessionId]
			   ,[CategoryProfession]
			   ,[IsPrimary])
 SELECT tabno, 
		prof_stell, 
		prof_trfst, 
		isPrimary
 FROM #tempPrimaryProf as t 
 INNER JOIN [InputData].[Professions] AS p ON p.IdProfession=t.PROF_STELL
 ORDER BY tabno

RETURN 0
