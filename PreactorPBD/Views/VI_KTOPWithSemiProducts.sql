--Вьюха для выборки операций с привязкой к ПФ
CREATE VIEW [InputData].[VI_KTOPWithSemiProducts]
	AS 

	SELECT DISTINCT [IdSemiProduct]
	  ,art.Title as artTitle
      ,sp.[Title] as spTitle
      ,sp.[SimpleProductId]
	  ,sqo.KTOP
      ,toper.PONEOB
  FROM [InputData].[SemiProducts] as sp

  INNER JOIN [InputData].[Nomenclature] as nom ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article] as art ON nom.[ArticleId] = art.IdArticle
  INNER JOIN [SupportData].[SequenceOperations] as sqo ON sqo.SimpleProductId = sp.SimpleProductId
  INNER JOIN [SupportData].[TempOperations] as toper ON toper.KTOPN = sqo.KTOP and toper.Article = art.Title collate Cyrillic_General_BIN