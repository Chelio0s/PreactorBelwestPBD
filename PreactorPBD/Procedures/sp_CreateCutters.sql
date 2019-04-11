CREATE PROCEDURE [InputData].[sp_CreateSecondaryConstraint_Cutters]

AS
DELETE FROM [InputData].[SecondaryConstraints]
WHERE [TypeId] = 1
INSERT INTO [InputData].[SecondaryConstraints]
           ([Title]
           ,[TypeId]
           ,[ParamDescript]
           ,[Param])
  SELECT 'Комплект резаков на модель:'+[Model] as title
	  ,1
	  ,'IdCutter'
	  , [IdCutter]
  FROM [SupportData].[Cutters]
RETURN 0
