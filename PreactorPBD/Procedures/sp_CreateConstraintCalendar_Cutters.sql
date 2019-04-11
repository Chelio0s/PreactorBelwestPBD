CREATE PROCEDURE [InputData].[sp_CreateConstraintCalendar_Cutters]
AS
	INSERT INTO [InputData].[ConstraintsCalendar]
           ([SecondaryConstraintId]
           ,[Start]
           ,[End]
           ,[Count])
SELECT IdSecondaryConstraint
,DateStart
,GETDATE()+365
,CASE WHEN isAutomat = 1 THEN 0 ELSE 1 END
  FROM [InputData].[SecondaryConstraints] as sc
  INNER JOIN [SupportData].[Cutters] as cutters ON cutters.IdCutter = [Param]
RETURN 0
