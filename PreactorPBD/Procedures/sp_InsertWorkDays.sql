
--Залвает рабочие дни для работников с графиком 5-2-5-3
CREATE PROCEDURE [InputData].[sp_InsertWorkDays]
	
AS
		if object_id(N'tempdb..#tempGraph',N'U') is not null drop table #tempGraph
	CREATE table #tempGraph(dated datetime, smena1 varchar(2), smena2 varchar(2))
	INSERT #tempGraph
	EXEC [InputData].[pc_Select_Oralce_MPU] @selectCommandText = 'SELECT
																	dated,
																	smena1,
																	smena2
																  FROM
																	belwpr.s_weeks'
TRUNCATE TABLE [SupportData].[WorkDays]
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(1) as ShiftId
	,smena1 as Crew
	FROM #tempGraph
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(2) as ShiftId
	,smena2 as Crew
	FROM #tempGraph

if object_id(N'tempdb..#tempGraph',N'U') is not null drop table #tempGraph
RETURN 0
