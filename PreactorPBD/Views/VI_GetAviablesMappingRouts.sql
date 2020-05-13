CREATE VIEW [InputData].[VI_GetAviablesMappingRouts]
	AS SELECT  
    Article 
	,COUNT(KTOPN) as CountKTOP_OP02
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 9)) as CountKTOP_OP61
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 13)) as CountKTOP_OP71
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 14)) as CountKTOP_OP81
	,(SELECT DISTINCT COUNT(KTOPChild)  FROM [InputData].[ctvf_GetFinalRoutForOterPlaceArticle](Article, 20)) as CountKTOP_OP92
 FROM [InputData].[VI_OperationsWithSemiProducts_FAST]
GROUP BY Article
 