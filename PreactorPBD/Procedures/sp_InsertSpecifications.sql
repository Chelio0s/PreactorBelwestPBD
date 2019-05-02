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
	  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = oper.SemiProductID
	  INNER JOIN [SupportData].[TempOperations] as toper ON toper.IdNomenclature = sp.NomenclatureID and toper.TitlePreactorOper = oper.title
	  INNER JOIN [SupportData].[TempMaterials] as tmat ON tmat.REL = toper.REL
COMMIT TRANSACTION
RETURN 0
