CREATE VIEW [InputData].[VI_CheckList_Persentage]
	AS
	SELECT DISTINCT Title,  SUM(Percents) OVER (partition by Title) as CountPercent
	FROM [InputData].[Article]
	CROSS APPLY [InputData].[ctvf_GetSizes]([Title])