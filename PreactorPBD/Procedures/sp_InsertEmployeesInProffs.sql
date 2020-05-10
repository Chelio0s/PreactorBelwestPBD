CREATE PROCEDURE [InputData].[sp_InsertEmployeesInProffs]
AS

DECLARE @tempEmp as table (
			tabno varchar(15)
			, OrgUnit varchar(15)
			, fio varchar(99)
			, trfst varchar(5)
			, trfs1 varchar(5)
			, persg varchar(5)
			, STELL varchar(20))

insert @tempEmp
SELECT * FROM OPENQUERY ([OracleMpu], 'SELECT
    tabno,
    OrgUnit,
    fio,
    trfst,
    trfs1,
    persg,
    STELL
FROM
    belwpr.s_seller
		WHERE DATEB <= (select sysdate from SYS.dual)
    and DATED > (select sysdate from SYS.dual)
    and ESTPOST <> 99999999
	and tabno not like ''3%''
	and nvl(prozt, ''0'') <> ''0'' 
	and persg in (''1'',''8'')
	and btrtl = ''0900''')

DECLARE @mainProffs as table (tabno varchar(15), MAIN_STELL varchar(15), MAIN_TRFST VARCHAR(5), isPrimary bit, OrgUnit varchar(15) )
	--Выбираем главные профессии
INSERT INTO  @mainProffs
           (tabno
		   ,MAIN_STELL
		   ,MAIN_TRFST
           ,[isPrimary]
		   ,[OrgUnit])
SELECT DISTINCT  tabno,
			CASE WHEN prof.IdProfession  is null THEN 0 ELSE prof.IdProfession END as STELL,
			trfst, 
			1
			,sell.OrgUnit
FROM @tempEmp as sell
LEFT JOIN [InputData].[Professions] as prof ON sell.STELL = prof.IdProfession
--Только нужные участки
INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = sell.OrgUnit

DECLARE @semiproffs table(tabno varchar(15), OrgUnit varchar(15), 
PROF_STELL varchar(99), PROF_TRFST varchar(99))
insert @semiproffs
	SELECT * FROM OPENQUERY ([OracleMpu], 'SELECT
		seller.tabno,
		OrgUnit,
		PROF_STELL,
		PROF_TRFST
		FROM
		belwpr.s_seller seller 
	LEFT JOIN belwpr.s_tab_stell_add  s_tab ON s_tab.tabno = seller.tabno
	WHERE  DATEB <= (select sysdate from SYS.dual)
    and DATED > (select sysdate from SYS.dual)
    and BEG <= (select sysdate from SYS.dual)
    and s_tab.end > (select sysdate from SYS.dual)
    and ESTPOST <> 99999999
	and seller.tabno not like ''3%''
	and nvl(prozt, ''0'') <> ''0'' 
	and persg in (''1'',''8'')
	and btrtl = ''0900''
	and PROF_STELL <>''00000000'' 
	and trfst<>'' ''
    and PERSK in (''V3'', ''V4'')
	and PROF_TRFST IS NOT NULL')
	
	INSERT INTO [InputData].[EmployeesInProfession]
           ([EmployeeId]
           ,[ProfessionId]
           ,[CategoryProfession]
           ,[IsPrimary])
	SELECT DISTINCT tabno
	, MAIN_STELL
	, trfst
	, IsPrimary
	FROM (
	SELECT agreageteQuery.tabno
	, agreageteQuery.MAIN_STELL
	, trfst
	, CASE WHEN agreageteQuery.MAIN_STELL = main.MAIN_STELL THEN 1 ELSE 0 END as IsPrimary
	FROM (
		SELECT DISTINCT tabno
		,MAIN_STELL
		,MAX(MAIN_TRFST) OVER(PARTITION BY tabno ,MAIN_STELL) as trfst
		FROM (
			SELECT DISTINCT tabno
			,MAIN_STELL
			,MAIN_TRFST
			FROM @mainProffs
			UNION
			SELECT DISTINCT tabno 
			,CASE WHEN prof.IdProfession  is null THEN 0 ELSE prof.IdProfession END as STELL
			,semi.PROF_TRFST  
			FROM @semiproffs as semi
			--Только нужные участки
			INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = semi.OrgUnit
			LEFT JOIN [InputData].[Professions] as prof ON semi.PROF_STELL = prof.IdProfession) as unionQuery ) as agreageteQuery
			LEFT JOIN @mainProffs as main ON main.MAIN_STELL = agreageteQuery.MAIN_STELL
											AND main.tabno = agreageteQuery.tabno) as q
RETURN 0
