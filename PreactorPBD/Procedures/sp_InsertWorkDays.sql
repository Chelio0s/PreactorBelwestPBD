--Заливает рабочие дни для работников с графиком 5-2-5-3
CREATE PROCEDURE [InputData].[sp_InsertWorkDays]
	
AS

DECLARE @tempGraph as table (dated datetime, smena1 varchar(2), smena2 varchar(2))
INSERT INTO @tempGraph
SELECT 	CONVERT(date,dated,104) as dated,
		smena1,
		smena2
FROM OPENQUERY([MPU], 'SELECT
						dated,
						smena1,
						smena2
					   FROM belwpr.s_weeks')
WHERE smena1 is not null OR smena2 is not null


TRUNCATE TABLE [SupportData].[WorkDays]
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(1) as ShiftId
	,smena1 as Crew
	FROM @tempGraph
	WHERE smena1 IS NOT NULL 
INSERT INTO [SupportData].[WorkDays]
           ([DateWorkDay]
           ,[ShiftId]
           ,[Crew])
	SELECT dated
	,(2) as ShiftId
	,smena2 as Crew
	FROM @tempGraph
	WHERE smena2 IS NOT NULL 

RETURN 0
