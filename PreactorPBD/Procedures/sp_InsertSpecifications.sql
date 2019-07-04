CREATE PROCEDURE [InputData].[sp_InsertSpecifications]
AS

BEGIN TRANSACTION
TRUNCATE TABLE [InputData].[Specifications]
	INSERT INTO [InputData].[Specifications]
			   ([MaterialId]
			   ,[Norma]
			   ,[OperationId])
		SELECT DISTINCT
		   FKGR
		   ,NORMA
		  ,[IdOperation]
	  FROM [InputData].[Operations] as oper
	  INNER JOIN [InputData].[Rout] as r ON r.SemiProductId = oper.RoutId
	  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = r.SemiProductID
	  INNER JOIN [SupportData].[TempOperations] as toper ON toper.IdNomenclature = sp.NomenclatureID and toper.TitlePreactorOper = oper.Title
	  INNER JOIN [InputData].[Nomenclature] as nom ON nom.IdNomenclature = sp.NomenclatureID
      INNER JOIN [InputData].[Article] as art ON art.IdArticle = nom.ArticleId														
	  INNER JOIN [InputData].[Areas] as area ON area.Code = toper.Code COLLATE Cyrillic_General_BIN
	  INNER JOIN [SupportData].[TempMaterials] as tmat ON tmat.REL = toper.REL 
														and tmat.Article  = art.Title COLLATE Cyrillic_General_BIN
														and tmat.KPODTO = area.KPODTO 
COMMIT TRANSACTION
RETURN 0
