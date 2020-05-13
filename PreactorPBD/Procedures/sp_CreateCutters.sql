CREATE PROCEDURE [InputData].[sp_CreateCutters]

AS
   INSERT [SupportData].[CuttersRaw]
   SELECT DISTINCT
      artmod.Model
	  , IdCutterType
	  , ct.Title  + ' на модель :' + CAST(artmod.Model as varchar(20))	AS [Title]
  FROM [SupportData].[ArticleModels]									AS artmod
  CROSS JOIN [SupportData].[CutterType]									AS ct
  EXCEPT 
  SELECT  [Model]					
		  ,[TypeCutterId]			
		  ,[Title]
  FROM	  [SupportData].[CuttersRaw]
RETURN 0
