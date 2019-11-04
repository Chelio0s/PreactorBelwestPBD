
--Заполняем справочник по работникам
CREATE PROCEDURE [InputData].[sp_InsertActualEmployees]

AS
	
DECLARE @tempEmp as table (tabno varchar(15), OrgUnit varchar(15), fio varchar(99), dated date)
insert @tempEmp
EXEC [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
    tabno,
    OrgUnit,
    fio,
	dateb
FROM
    belwpr.s_seller
		WHERE DATEB <= (select sysdate from SYS.dual)
    and DATED > (select sysdate from SYS.dual)
    and ESTPOST <> 99999999
	and tabno not like ''3%''
	and prozt<>0 
	and persg in (''1'',''8'')
	and btrtl = ''0900'''
 


 DECLARE @table table (  fio varchar(99), tabno varchar(15), OrgUnit varchar(15), dated date, maxdate date)
 INSERT INTO @table
 SELECT DISTINCT fio, tabno, org.OrgUnit, dated, max(dated) over(partition by tabno) from @tempEmp as sell
 INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = sell.OrgUnit
 ORDER BY fio


 DELETE FROM [InputData].[Employees]
 INSERT INTO [InputData].[Employees]
           ([Name]
           ,[TabNum]
           ,org.[OrgUnit])
 SELECT fio, tabno, orgunit
 FROM @table 
 WHERE dated = maxdate

RETURN 0
