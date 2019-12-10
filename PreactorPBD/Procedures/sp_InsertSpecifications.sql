CREATE PROCEDURE [InputData].[sp_InsertSpecifications]
AS

TRUNCATE TABLE [InputData].[Specifications]
	INSERT INTO [InputData].[Specifications]
			   ([MaterialId]
			   ,[Norma]
			   ,[OperationId])
		SELECT DISTINCT
		   FKGR
		   ,NORMA
		  ,[IdOperation]
	  FROM  [InputData].[VI_OperationsFromSDBWithREL] as virel										
	  INNER JOIN [SupportData].[TempMaterials] as tmat ON tmat.REL = virel.REL 
													      
RETURN 0
