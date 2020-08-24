CREATE VIEW [InputData].[VI_CHECK_AreThereOperationsInArticle]
	AS 
SELECT 
	Title as Article
	,IsTopCut
	,IsBlank
	,IsFinishedShoes
FROM 
(
	SELECT Title
	,IIF ((SELECT COUNT(*) FROM [InputData].[VI_OperationsWithSemiProducts_FAST] WHERE Article = ART.Title collate Cyrillic_General_CI_AS AND SimpleProductId = 1) > 0,1,0) AS IsTopCut
	,IIF ((SELECT COUNT(*) FROM [InputData].[VI_OperationsWithSemiProducts_FAST] WHERE Article = ART.Title collate Cyrillic_General_CI_AS AND SimpleProductId = 18) > 0,1,0) AS IsBlank
	,IIF ((SELECT COUNT(*) FROM [InputData].[VI_OperationsWithSemiProducts_FAST] WHERE Article = ART.Title collate Cyrillic_General_CI_AS AND SimpleProductId = 20) > 0,1,0) AS IsFinishedShoes
	FROM [InputData].[Article] AS ART
) as q
WHERE IsTopCut = 0 OR IsBlank = 0 OR IsFinishedShoes = 0
