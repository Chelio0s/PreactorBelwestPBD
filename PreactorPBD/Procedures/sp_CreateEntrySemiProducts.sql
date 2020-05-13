CREATE PROCEDURE [InputData].[sp_CreateEntrySemiProducts]
AS


DELETE FROM [InputData].[EntrySemiProduct]
INSERT INTO [InputData].[EntrySemiProduct]
           ([IdSemiProduct]
           ,[IdSemiProductChild])
	SELECT semi.IdSemiProduct
	  ,spp.IdSemiProduct
  FROM  [InputData].[SemiProducts] as semi
  INNER JOIN [SupportData].[EntrySimpleProduct] as simplep ON semi.SimpleProductId = simplep.SimpleProductId
  INNER JOIN [InputData].[SemiProducts] as spp ON simplep.SimpleProductIdChild= spp.SimpleProductId and spp.NomenclatureID = semi.NomenclatureID
  
RETURN 0
