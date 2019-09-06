CREATE PROCEDURE [InputData].[sp_DeleteInappropriateSemiProducts]
AS 
  DELETE FROM [InputData].[SemiProducts]
  WHERE IdSemiProduct not in (
  SELECT DISTINCT
	sp.[IdSemiProduct]
 FROM [InputData].[SemiProducts] as sp
 INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = sp.[IdSemiProduct] )
RETURN 0
