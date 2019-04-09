CREATE PROCEDURE [InputData].[sp_InsertOrgUnit]

AS
	if object_id(N'tempdb..#tempEmp',N'U') is not null drop table #tempEmp
create table #tempEmp(tabno varchar(15), OrgUnit varchar(15), fio varchar(99), 
trfst varchar(5), trfs1 varchar(5), persg varchar(5), stell varchar(20), stext1 varchar(99))
insert #tempEmp
EXEC [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
    tabno,
    OrgUnit ,
    fio,
    trfst,
    trfs1,
    persg,
    stell,
	stext1
FROM
    belwpr.s_seller
	WHERE  dated = ''31.12.9999'' and ESTPOST <> 99999999 and tabno not like ''3%'' '

	DELETE FROM [SupportData].[OrgUnit]
	INSERT INTO [SupportData].[OrgUnit]
           ([OrgUnit]
           ,AreaId
           ,[Title])
 select  OrgUnit, 
 -9,
 CASE WHEN OrgUnit = '50033716' THEN 'Смена А участок №9 - Участок раскроя и обработки'
	  WHEN OrgUnit = '50033722' THEN 'Смена Б участок №9 - Участок раскроя и обработки'
	  WHEN OrgUnit = '50033718' THEN 'Смена A участок №9 - Участок сборки заготовок'
	  WHEN OrgUnit = '50033723' THEN 'Смена Б участок №9 - Участок сборки заготовок'
	  ELSE stext1 END as stext1
    
 
 from #tempEmp as sell
 INNER JOIN [InputData].[Professions] as prof ON sell.stell = prof.IdProfession
 Group by OrgUnit, stext1 

 order by stext1
RETURN 0
