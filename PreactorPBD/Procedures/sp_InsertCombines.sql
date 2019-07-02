CREATE PROCEDURE [InputData].[sp_InsertCombines]
AS
	
	BEGIN TRANSACTION 

	DELETE FROM [SupportData].[CombineRules]

	DECLARE @FilteredTable as table (IdSemiProduct int NOT NULL)
INSERT INTO @FilteredTable
SELECT [IdSemiProduct]
FROM [InputData].[SemiProducts] as sp
--Просееваем заведомо не нужные ПФ (для которых нет RULES)
WHERE sp.SimpleProductId IN (SELECT DISTINCT
								   [SimpleProductId]
							  FROM [SupportData].[SequenceOperations] as sq
							  INNER JOIN [SupportData].[OperationСomposition] as oc ON sq.KTOP = oc.KTOP)
--Таблица просеяных ТМ 
DECLARE @combinesProducts as table (IdSemiProduct  int, Title nvarchar(99), IdRoutRule  int, IdCombine int, IsParent bit)
INSERT INTO @combinesProducts
SELECT   sp.[IdSemiProduct]
		,sp.Title
		,cc.IdRoutRule
		,cc.IdCombine
		,cc.IsParent

  FROM [InputData].[SemiProducts] as sp
  INNER JOIN @FilteredTable as filtered ON filtered.IdSemiProduct = sp.IdSemiProduct
  OUTER APPLY [InputData].[ctvf_CombineCombines](sp.[IdSemiProduct]) as cc
  DELETE FROM [SupportData].[CombineRules]
  INSERT INTO [SupportData].[CombineRules]
           ([SemiProductId]
           ,[Number_])
  SELECT Distinct IdSemiProduct
  ,IdCombine FROM @combinesProducts
  WHERE IdCombine is not null 

  --Заполняем Compositons
  INSERT INTO [SupportData].[CombineComposition]
           ([CombineRulesId]
           ,[RuleId]
           ,[RuleIsParent])
  SELECT IdCombineRules
  ,IdRoutRule
  ,IsParent
  FROM [SupportData].[CombineRules] as cr
  INNER JOIN @combinesProducts as cp ON cp.IdSemiProduct = cr.[SemiProductId] 
										and cp.IdCombine = cr.[Number_]


  
  IF @@ERROR <>0
	ROLLBACK TRANSACTION
  ELSE
	COMMIT TRANSACTION

RETURN 0
