CREATE PROCEDURE [InputData].[sp_InsertOrgUnit]

AS
	if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
create table #tempEmp(tabno varchar(15), orgunit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), stell varchar(20), stext1 varchar(99))
insert #tempEmp
exec [PreactorSDB].[InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
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
	WHERE  dated = ''31.12.9999'' and ESTPOST <> 99999999 and tabno not like ''3%'' '

	DELETE FROM [PreactorSDB].[SupportData].[Orgunit]
	INSERT INTO [PreactorSDB].[SupportData].[Orgunit]
           ([orguinit]
           ,[kcex]
           ,[title])
 select  orgunit, 
 -9,
 CASE WHEN orgunit = '50033716' THEN 'Смена А участок №9 - Участок раскроя и обработки'
	  WHEN orgunit = '50033722' THEN 'Смена Б участок №9 - Участок раскроя и обработки'
	  WHEN orgunit = '50033718' THEN 'Смена A участок №9 - Участок сборки заготовок'
	  WHEN orgunit = '50033723' THEN 'Смена Б участок №9 - Участок сборки заготовок'
	  ELSE stext1 END as stext1
    
 
 from #tempEmp as sell
 INNER JOIN [PreactorSDB].[InputData].[Professions] as prof ON sell.stell = prof.IdProfession
 Group by orgunit, stext1 

 order by stext1
RETURN 0
