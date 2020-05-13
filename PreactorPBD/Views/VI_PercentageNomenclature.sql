CREATE VIEW [InputData].[VI_PercentageNomenclature]
	AS 
	SELECT [IdArticle]
	  ,Title+' '+CAST(ISNULL(SIZE, 40)	 AS VARCHAR(5))					AS TitleNomenclature
	  ,ISNULL(SIZE, 40)													AS SIZE					-- todo: Костыль на несуществующий артикул в БД оракла электр. экскиз
	  ,ISNULL(Percents, 100)											AS Percents				-- todo: Костыль на несуществующий артикул в БД оракла электр. экскиз
	  ,SUM(ISNULL(Percents, 100)	) OVER(PARTITION BY IdArticle)		AS sumpercents
  FROM [InputData].[Article]											AS art
  OUTER APPLY [InputData].[ctvf_GetSizes]([Title])						As fn
  