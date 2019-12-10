CREATE VIEW [InputData].[VI_MaterialsFromRKV_SLOW]
	AS 

SELECT  
      [IdArticle]
      ,[Title]			AS ArtTitle
      ,[MaxCountUse]
	  ,REL
	  ,ART
	  ,KPODTO
	  ,KTOPN
	  ,KPO
	  ,NPP
	  ,FKGR
	  ,FNGR
	  ,NORMA
	  ,DOP
	  ,DOPN
	  ,TOL
	  ,KC
	  ,NC
	  ,[PARAM]
	  ,FN.RROT
	  ,FN.RRTO		
  FROM [InputData].[Article]											AS ART
  CROSS APPLY [InputData].[tvf_GetMaterialForArticleRKVSlow] ([Title])	AS FN
  WHERE FKGR NOT LIKE '109%'  -- исключаем 109 группу, так как в ней есть формы и др. расходники с нормой 1 на 100 пар, а в реале норма куда ниже. 
   
