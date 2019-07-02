
--Залвает рабочие дни для работников с графиком 5-2-5-3
CREATE PROCEDURE [InputData].[sp_InsertWorkDays]
	
AS
			DECLARE @tempGraph as table (dated datetime, smena1 varchar(2), smena2 varchar(2))
	INSERT INTO @tempGraph
	SELECT 	CONVERT(date,dated,104) as dated,
			smena1,
			smena2
			--Переделал на OPENQUERY потому что просто EXEC ругался сильно
	FROM OPENQUERY(CurrentServer, 
                                          'SET FMTONLY OFF EXEC [PreactorSDB].[InputData].[pc_Select_Oralce_MPU] @selectCommandText = ''SELECT
																	dated,
																	smena1,
																	smena2
																  FROM
																	belwpr.s_weeks''
															WITH RESULT SETS
															(
															(dated  varchar(max)
															,smena1  varchar(2)
															,smena2  varchar(2))
															)' )



TRUNCATE TABLE [SupportData].[WorkDays]
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(1) as ShiftId
	,smena1 as Crew
	FROM @tempGraph
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(2) as ShiftId
	,smena2 as Crew
	FROM @tempGraph


RETURN 0
