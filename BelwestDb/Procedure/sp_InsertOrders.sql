CREATE PROCEDURE [dbo].[sp_InsertOrders]
	@art varchar(50)
AS
INSERT INTO [dbo].[Orders]
           ([ArticleCode]
           ,[ArticleName]
           ,[ArticleVersion]
           ,[CountOnOrder]
           ,[DateStart]
           ,[DateEnd]
           ,[Priority])
	SELECT *, [Count] * (CountPersent / 100) AS CountPar FROM [InputData].[Plan] AS p
INNER JOIN [InputData].[Article] AS art ON art.IdArticle = p.ArticleId
INNER JOIN [InputData].[Nomenclature] AS nom ON nom.ArticleId = art.IdArticle
INNER JOIN [InputData].[SemiProducts] AS sp ON sp.NomenclatureID = nom.IdNomenclature
WHERE art.Title = @art


RETURN 0
