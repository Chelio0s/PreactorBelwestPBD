CREATE PROCEDURE [InputData].[sp_CreateConstraintCalendar_Cutters]
AS
	INSERT INTO [InputData].[ConstraintsCalendar]
           ([SecondaryConstraintId]
           ,[Start]
           ,[End]
           ,[Count])
 (
	SELECT IdSecondaryConstraint
		,ISNULL(DateStart, '2010-01-01')							   AS [DateStart]
		,ISNULL(DateStart, '2010-01-01')+365 						   AS [DateEnd]
		,CASE WHEN isAutomat = 1 OR IdCutter IS NULL THEN 0 ELSE 1 END AS [Count]
	FROM [InputData].[SecondaryConstraints] as sc
	INNER JOIN [SupportData].[CuttersRaw]	 as cr ON sc.Param = cr.idCutterRaw 
													AND sc.TypeId = 1
	LEFT JOIN [SupportData].[Cutters] as cutters ON cutters.Model = cr.Model
	WHERE [TypeCutterId] = 1
	UNION
	SELECT IdSecondaryConstraint
		,ISNULL(DateStart, '2010-01-01')								AS [DateStart]
		,ISNULL(DateStart, '2010-01-01')+365							AS [DateEnd]
		,CASE WHEN IdCutter IS NULL THEN 0 ELSE 1 END					AS [Count]
	FROM [InputData].[SecondaryConstraints] as sc
	INNER JOIN [SupportData].[CuttersRaw]	 as cr ON sc.Param = cr.idCutterRaw 
													AND sc.TypeId = 1
	LEFT JOIN [SupportData].[Cutters] as cutters ON cutters.Model = cr.Model
	WHERE [TypeCutterId] <> 1 
 )
  EXCEPT
  SELECT [SecondaryConstraintId]
           ,[Start]
           ,[End]
           ,[Count]
 FROM [InputData].[ConstraintsCalendar] 
RETURN 0 
