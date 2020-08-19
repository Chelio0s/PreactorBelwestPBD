CREATE VIEW [InputData].[VI_CHECK_ExistingAllOperationsForJump2To1]
	AS  SELECT DISTINCT
        ART
        ,MAX(input) OVER (PARTITION BY ART) as IsThereInput
        ,MAX([output]) OVER (PARTITION BY ART) as IsThereOut
        ,MAX(Operation) OVER (PARTITION BY ART) as IsThereOperation
    FROM(
    SELECT
    ART
    ,CASE WHEN KTOPN IN (516, 554) THEN 1 END as [Input]
    ,CASE WHEN KTOPN IN (517, 564) THEN 1 END as [Output]
    ,CASE WHEN KTOPN IN (263,269,187)THEN 1 END as [Operation]
    FROM [InputData].[VI_OperationsFromRKV]
    WHERE ART in (SELECT Title FROM [InputData].[Article])
    AND KTOPN in (516,517,564,554, 263,269,187)) as q
