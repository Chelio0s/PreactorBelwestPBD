--  Все операции в ПБД для каждого маршрута
--  DON'T CHANGE PLEASE
--  От этой вью зависит инсерт OperationsInResources
CREATE VIEW [InputData].[VI_OperationsFromSDB]
	AS 
	SELECT [IdOperation]
	  ,art.Title as ArtTitle
	  ,nom.Size
	  ,nom.Number_ as Nomenclature
      ,oper.[Title] as OperTitle
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTime]
      ,[CategoryOperation]
      ,[Code]
	  ,sp.IdSemiProduct
	  ,sp.SimpleProductId 
  FROM [InputData].[Operations]			as oper
  INNER JOIN [InputData].[Rout]			as rout	ON rout.IdRout = oper.RoutId
  INNER JOIN [InputData].[SemiProducts] as sp	ON sp.IdSemiProduct = rout.SemiProductId
  INNER JOIN [InputData].[Nomenclature] as nom	ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]		as art	ON art.IdArticle = nom.ArticleId
