CREATE PROCEDURE [InputData].[sp_InsertEmployeesInProffs]
AS
if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
create table #tempEmp(tabno varchar(15), OrgUnit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), STELL varchar(20), stext1 varchar(99))
insert #tempEmp
exec [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
    tabno,
    OrgUnit,
    fio,
    trfst,
    trfs1,
    persg,
    STELL,
	stext1
FROM
    belwpr.s_seller
		WHERE DATEB <= (select sysdate from SYS.dual)
    and DATED > (select sysdate from SYS.dual)
    and ESTPOST <> 99999999
	and tabno not like ''3%''
	and prozt<>0 
	and persg in (''1'',''8'')
	and btrtl = ''0900'''

	IF object_id(N'tempdb..#tempPrimaryProf',N'U') is not null DROP TABLE #tempPrimaryProf
CREATE TABLE #tempPrimaryProf(tabno varchar(15), MAIN_STELL varchar(15), MAIN_TRFST VARCHAR(5), PROF_STELL varchar(15), PROF_TRFST varchar(5), isPrimary bit)
	--Выбираем главные профессии
INSERT INTO  #tempPrimaryProf
           (tabno
		   ,MAIN_STELL
		   ,MAIN_TRFST
           ,PROF_STELL
           ,PROF_TRFST
           ,[isPrimary])
SELECT DISTINCT  tabno,
			CASE WHEN prof.IdProfession  is null THEN 0 ELSE prof.IdProfession END as STELL,
			trfst, 
			CASE WHEN prof.IdProfession  is null THEN 0 ELSE prof.IdProfession END as STELL, 
			trfst, 
			1
FROM #tempEmp as sell
LEFT JOIN [InputData].[Professions] as prof ON sell.STELL = prof.IdProfession
--Только нужные участки
INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = sell.OrgUnit

--Подготовка данных под доп. профы

if object_id(N'tempdb..#tempEmp1',N'U') is not null drop table #tempEmp1
	CREATE table #tempEmp1(tabno varchar(15), OrgUnit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), STELL VARCHAR(20), PROF_STELL varchar(99), PROF_TRFST varchar(99), PROF_TRFGR varchar(99), ENDDA varchar(99), prozt varchar(5))
insert #tempEmp1
	EXEC[InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
		seller.tabno,
		OrgUnit,
		fio,
		trfst,
		trfs1,
		persg,
		STELL,
		PROF_STELL,
		PROF_TRFST,
		PROF_TRFGR,
		ENDDA,
		prozt
		FROM
		belwpr.s_seller seller 
	LEFT JOIN belwpr.s_tab_stell_add  s_tab ON s_tab.tabno = seller.tabno
	WHERE  DATEB <= (select sysdate from SYS.dual)
    and DATED > (select sysdate from SYS.dual)
    and BEG <= (select sysdate from SYS.dual)
    and s_tab.end > (select sysdate from SYS.dual)
    and ESTPOST <> 99999999
	and seller.tabno not like ''3%''
	and prozt<>0 
	and persg in (''1'',''8'')
	and btrtl = ''0900''
	and PROF_STELL <>''00000000'' 
	and prozt<> 0 and trfst<>'' ''
    and PERSK in (''V3'', ''V4'')'


  
--Выбираем доп профы с макс. разрядом
INSERT INTO  #tempPrimaryProf
           (tabno
		   ,MAIN_STELL
		   ,MAIN_TRFST
           ,PROF_STELL
           ,PROF_TRFST
           ,[IsPrimary])
SELECT 
   tabno, 
   STELL,
   trfst,
   PROF_STELL,
   MAX(PROF_TRFST) as PROF_TRFST,
   0 
   FROM #tempEmp1 as sell
   INNER JOIN [InputData].[Professions] as prof ON sell.STELL = prof.IdProfession
   --Только нужные участки
   INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = sell.OrgUnit
 group by  tabno, PROF_STELL,STELL , trfst
 order by PROF_STELL

 --Дропаем дубли главная = доп. профа  если главный разряд больше доп. профы или они равны
 DELETE FROM #tempPrimaryProf 
 WHERE  MAIN_STELL = PROF_STELL and isPrimary = 0 AND (MAIN_TRFST>PROF_TRFST or MAIN_TRFST=PROF_TRFST)
 
 --Очищаем таблицу 
 DELETE FROM [InputData].[EmployeesInProfession]
 INSERT INTO [InputData].[EmployeesInProfession]
			   ([EmployeeId]
			   ,[ProfessionId]
			   ,[CategoryProfession]
			   ,[IsPrimary])
 SELECT tabno, 
		PROF_STELL, 
		PROF_TRFST, 
		isPrimary
 FROM #tempPrimaryProf as t 
 INNER JOIN [InputData].[Professions] AS p ON p.IdProfession=t.PROF_STELL
 
 ORDER BY tabno

RETURN 0
