CREATE VIEW [InputData].[VI_CheckList_CheckModelExistense]
AS 
	SELECT * FROM [InputData].[Article]
	OUTER APPLY [InputData].[ctvf_GetModelArticle](Title)
	WHERE INDEX_MODEL IS NULL