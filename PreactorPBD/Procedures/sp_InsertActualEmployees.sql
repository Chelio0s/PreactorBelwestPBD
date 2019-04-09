﻿
--Заполняем справочник по работникам
CREATE PROCEDURE [InputData].[sp_InsertActualEmployees]

AS
	

if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
create table #tempEmp(tabno varchar(15), orgunit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), stell varchar(20), stext1 varchar(99))
insert #tempEmp
exec [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
    tabno,
    orgunit,
    fio,
    trfst,
    trfs1,
    persg,
    stell,
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
 
 ALTER TABLE #tempEmp
  ALTER COLUMN  STELL VARCHAR(99) COLLATE Cyrillic_General_BIN NULL;

 
 DELETE FROM [InputData].[Employees]
 INSERT INTO [InputData].[Employees]
           ([Name]
           ,[TabNum]
           ,org.[Orgunit])
 select distinct fio, tabno, org.orgunit from #tempEmp as sell
 INNER JOIN [SupportData].[Orgunit] as org ON org.OrgUnit = sell.orgunit
 order by fio

RETURN 0
