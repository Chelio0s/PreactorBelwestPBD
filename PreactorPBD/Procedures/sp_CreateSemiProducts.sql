CREATE PROCEDURE [InputData].[sp_CreateSemiProducts]
AS
DELETE FROM [InputData].[SemiProducts]
	INSERT INTO [InputData].[SemiProducts]
           ([Title]
           ,[NomenclatureID]
           ,[SimpleProductId])
SELECT Title+':'+Number_ 
		, IdNomenclature
		, IdSimpleProduct
  FROM [InputData].[Nomenclature]
  CROSS JOIN [SupportData].[SimpleProduct]
RETURN 0
