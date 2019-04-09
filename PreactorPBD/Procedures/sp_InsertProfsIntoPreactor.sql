
--Заливает профессии связанные RKV-SAP в преактор
CREATE PROCEDURE [InputData].[sp_InsertProfsIntoPreactor]
	
AS
	

if object_id(N'tempdb..#t1',N'U') is not null drop table #t1
create table #t1(STELL varchar(max), STEXT varchar(max))
insert #t1
exec [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 
																			'SELECT distinct
																			   st.stell,st.stext
																			FROM
																			   belwpr.s_stell st'
 
 ALTER TABLE #t1
  ALTER COLUMN  STELL VARCHAR(99) COLLATE Cyrillic_General_BIN NULL;

  DELETE FROM [InputData].[Professions]
  INSERT INTO [InputData].[Professions]
           ([IdProfession]
           ,[Title]
           ,[CodeRKV])
		   VALUES('00000000',
		   'Не подходящая осн. проф.',
		   '00000')
  INSERT INTO [InputData].[Professions]
           ([IdProfession]
           ,[Title]
           ,[CodeRKV])

  SELECT 
	  profSAP.STELL
	  ,profSAP.STEXT
	  ,prof.[KPROF]
  FROM [RKV].[PLANT].[dbo].[s_prof2] as prof
  INNER JOIN [RKV].[RKV_SCAL].[dbo].[d_sap_vika10] as vika ON vika.KPROF = prof.KPROF
  INNER JOIN #t1 as profSAP ON profSAP.STELL = vika.[ALT_KPROF]

RETURN 0
