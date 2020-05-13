CREATE VIEW [InputData].[VI_MaterialsForArticleWithNomenclatureFAST]
	AS SELECT TM.[IdArticle]
      ,[Article]
      ,[REL]
      ,[FKGR]
      ,[NORMA]
      ,[KPODTO]
      ,[FNGR]
      ,[DOP]
      ,[DOPN]
      ,[TOL]
      ,[KC]
      ,[NC]
      ,[PARAM]
      ,[PROT]
      ,[PRTO]
	  ,[SIZE]
	  ,N.IdNomenclature
	  ,N.Number_
  FROM [SupportData].[TempMaterials]	AS TM
  INNER JOIN [InputData].[Nomenclature]	AS N	ON N.ArticleId = TM.[IdArticle] 
												AND (SIZE >= [PROT] AND SIZE<=[PRTO]  OR  (PROT IS NULL AND PRTO IS NULL))
