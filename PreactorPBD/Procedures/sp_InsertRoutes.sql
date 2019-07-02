CREATE PROCEDURE [InputData].[sp_InsertRoutes]

AS
	
BEGIN TRANSACTION

DELETE FROM [InputData].[Rout]

--Инсерт ТМ с правилами
INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId])

SELECT DISTINCT
       'ТМ с набором операций '+CONVERT(NVARCHAR(10), [CombineRulesId]) AS Title
	  ,[SemiProductId]
	  ,10
	  ,[CombineRulesId]
  FROM [SupportData].[CombineComposition] as cc
  INNER JOIN [SupportData].[CombineRules] as cr ON cc.[CombineRulesId] = cr.[IdCombineRules]

  --Инсерт ТМ всех остальных
  INSERT INTO [InputData].[Rout]
           ([Title]
           ,[SemiProductId]
           ,[Priority]
           ,[CombineId])
  SELECT 'Стандартный ТМ для ПФ '+ CONVERT(NVARCHAR(10), IdSemiProduct)
  , IdSemiProduct
  ,10
  ,NULL
  FROM [InputData].[SemiProducts]
  WHERE IdSemiProduct not in (SELECT DISTINCT SemiProductId FROM [InputData].[Rout])

IF @@ERROR = 0
BEGIN
	COMMIT TRANSACTION 
END
ELSE 
BEGIN
	ROLLBACK TRANSACTION
END

RETURN 0