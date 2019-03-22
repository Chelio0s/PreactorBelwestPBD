CREATE PROCEDURE [InputData].[sp_CheckEmployees]

AS
	if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
	CREATE table #tempEmp(tabno varchar(15), orgunit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), STELL varchar(20), PROF_STELL varchar(99), PROF_TRFST varchar(99), PROF_TRFGR varchar(99), ENDDA varchar(99), prozt varchar(5))
insert #tempEmp
	EXEC [PreactorSDB].[InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
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
	WHERE  dated = ''31.12.9999'' and ESTPOST <> 99999999 and seller.tabno not like ''3%'' and prof_stell <>''00000000'' and prozt<>0'

  SELECT 
  'Проверка главных профессий (наличие)' as Title, 
  CASE WHEN (  SELECT COUNT([EmployeeId]) as CountPrimary
  FROM [PreactorSDB].[InputData].[EmployeesInProfession]
  WHERE [IsPrimary] = 1
  GROUP BY [EmployeeId]
      ,[IsPrimary]
  HAVING  COUNT([EmployeeId]) <> 1) is NULL THEN 'OK' ELSE 'BAD' END as [Status]
  UNION 
SELECT 
  'Проверка главных профессий (совпадение)' as Title, 
  CASE WHEN EXISTS(SELECT EmployeeId
  ,ProfessionId
  ,CategoryProfession
  ,STELL
  ,trfst
   FROM [PreactorSDB].[InputData].[EmployeesInProfession] as eip
  LEFT JOIN #tempEmp as temp ON eip.EmployeeId = temp.tabno
  WHERE eip.IsPrimary = 1 and (ProfessionId<>stell and CategoryProfession <>trfst)) THEN 'BAD' ELSE 'OK' END as [Status]
  UNION
 SELECT 
 'Проверка дополнительных профессий (количество)' as Title,
 CASE WHEN EXISTS(  SELECT * FROM (  SELECT q1.tabno, count(*) as countP FROM (Select  tabno,PROF_STELL, max(PROF_TRFST) as PROF_TRFST  from #tempEmp
  INNER JOIN [PreactorSDB].[InputData].[Professions] as profs ON profs.IdProfession = PROF_STELL
  WHERE ((PROF_STELL = STELL and PROF_TRFST > trfst) or PROF_STELL <> STELL)
  
  GROUP BY tabno, PROF_STELL, PROF_STELL) as q1
  GROUP BY q1.tabno) as s

  LEFT JOIN ( 
  select EmployeeId, count(*) as countP1 from [PreactorSDB].[InputData].[EmployeesInProfession]  
  WHERE  IsPrimary = 0
  GROUP BY EmployeeId ) as q2 ON s.tabno = q2.EmployeeId
  where countP<> countP1) THEN 'BAD' ELSE 'OK' END as [Status]
 	UNION
	SELECT 'Проверка дополнительных профессий (совпадение)'
	,CASE WHEN EXISTS(  SELECT * FROM ( SELECT t.tabno, PROF_STELL, max(prof_trfst) as prof_trfst  FROM #tempEmp as t
  INNER JOIN [PreactorSDB].[InputData].[Employees] as e ON e.TabNum = t.tabno
  INNER JOIN [PreactorSDB].[InputData].[Professions] as profs ON profs.IdProfession = PROF_STELL
  WHERE  ((PROF_STELL = STELL and PROF_TRFST > trfst) or PROF_STELL <> STELL) 
  GROUP BY t.tabno, PROF_STELL) as q1
  
  LEFT JOIN 
  (SELECT * from [PreactorSDB].[InputData].[EmployeesInProfession] WHERE IsPrimary = 0) as q2 ON EmployeeId = tabno
																								and ProfessionId = PROF_STELL
																								and CategoryProfession = prof_trfst
   WHERE ProfessionId is null) THEN 'BAD' ELSE 'OK' END as [Status]
RETURN 0
