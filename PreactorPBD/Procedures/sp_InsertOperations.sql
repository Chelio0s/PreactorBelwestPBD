﻿CREATE PROCEDURE [InputData].[sp_InsertOperations]
AS
	DELETE FROM  [InputData].[Operations]
	DECLARE @table as table(Title nvarchar(99), IdSemiProduct int, idProfesson int, TypeTime int, CategoryOperation int, OperOrder int, Code varchar(4))
	INSERT INTO @table
	SELECT DISTINCT
	[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  INNER JOIN [InputData].[SemiProducts] as sp ON sp.IdSemiProduct = vi.[IdSemiProduct]
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

	INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[SemiProductID]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
		   ,Code)
	SELECT 
		Title
		,ROW_NUMBER() over (partition by IdSemiProduct order by IdSemiProduct, OperOrder)
		,IdSemiProduct
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table
RETURN 0