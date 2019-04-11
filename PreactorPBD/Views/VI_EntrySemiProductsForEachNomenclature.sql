CREATE VIEW [InputData].[VI_EntrySemiProductsForEachNomenclature]
	AS 

SELECT semi.IdSemiProduct as IdSemiProductParent
	  ,semi.title as TitleParent
	  ,spp.IdSemiProduct as IdSemiProductChild
	  ,spp.Title as TitleChild
  FROM  [InputData].[SemiProducts] as semi
  INNER JOIN [SupportData].[EntrySimpleProduct] as simplep ON semi.SimpleProductId = simplep.SimpleProductId
  INNER JOIN [InputData].[SemiProducts] as spp ON simplep.SimpleProductIdChild= spp.SimpleProductId and spp.NomenclatureID = semi.NomenclatureID
  
