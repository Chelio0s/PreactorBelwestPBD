CREATE VIEW [InputData].[VI_PercentageNomenclature]
	AS 
	SELECT [IdArticle]
	  ,Title+' '+CAST(SIZE as varchar(5)) as TitleNomenclature
	  ,SIZE
	  ,Percents
	  ,SUM(Percents) over(partition by IdArticle) as sumpercents
  FROM [InputData].[Article] as art
  OUTER APPLY [InputData].[ctvf_GetSizes]([Title])
  