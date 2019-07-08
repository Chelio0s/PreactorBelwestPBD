CREATE PROCEDURE [InputData].[sp_InsertOperations]
AS

	DELETE FROM  [InputData].[Operations]
	DECLARE @table as table(idRout int, TitleOperPr nvarchar(99), IdSemiProduct int, idProfesson int, TypeTime int, CategoryOperation int, OperOrder int, Code varchar(4), NPP int)
	--Все для 1 цеха (там операции строго сортированы по правилам)
	INSERT INTO @table
	SELECT DISTINCT
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,1  --заменяем NPP на 1 чтобы убрать потом дубликаты
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE code = 'OP01'
  ORDER BY vi.[IdSemiProduct], vi.[OperOrder]

  --Все для 2 цеха с правилами, сортировка по NPP
  INSERT INTO @table
  SELECT DISTINCT 	
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is not null and (IdSemiProduct = r.SemiProductId and KTOPN not in (SELECT KTOP FROM [InputData].[ctvf_GetDisableOperationsForRout](r.IdRout)))
  AND code = 'OP02'
  ORDER BY r.IdRout, NPP
  --Все для 2 цеха без правил, сортировка по NPP
    INSERT INTO @table
    SELECT DISTINCT 	 
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,1 as [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId is null AND code = 'OP02'
  ORDER BY r.IdRout, NPP
  
--Залив финала 1 цех
INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
           ,[Code])
	SELECT 
		TitleOperPr
		,ROW_NUMBER() over (partition by IdSemiProduct order by IdSemiProduct, OperOrder)*10
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table
		WHERE Code = 'OP01'
		ORDER BY idRout, OperOrder
--Залив финала 2 цех
		INSERT INTO [InputData].[Operations]
           ([Title]
           ,[NumberOp]
           ,[RoutId]
           ,[ProfessionId]
           ,[TypeTime]
           ,[CategoryOperation]
           ,[Code])
	SELECT DISTINCT
		tt.TitleOperPr
		,(SELECT TOP(1) NPP FROM @table as t WHERE t.TitleOperPr = tt.TitleOperPr and t.idRout = tt.idRout and t.IdSemiProduct = tt.IdSemiProduct) as NPP
		,idRout
		,idProfesson
		,TypeTime
		,CategoryOperation
		,Code
		FROM @table as tt
		WHERE Code = 'OP02'
		ORDER BY idRout, NPP
RETURN 0
