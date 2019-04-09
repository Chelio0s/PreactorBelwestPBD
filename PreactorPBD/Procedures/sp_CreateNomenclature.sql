CREATE PROCEDURE [InputData].[sp_CreateNomenclature]
AS
DELETE FROM [InputData].[Nomenclature]
INSERT INTO [InputData].[Nomenclature]
           ([ArticleId]
           ,[Number_]
           ,[Size]
           ,[CountPersent])
SELECT  [IdArticle]
      ,[TitleNomenclature]
      ,[SIZE]
      ,[Percents]
  FROM [InputData].[VI_PercentageNomenclature]
  WHERE size is not null and sumpercents = 100
RETURN 0
