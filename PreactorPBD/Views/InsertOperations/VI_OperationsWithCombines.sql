CREATE VIEW [InputData].[VI_OperationsWithCombines]
	AS 
SELECT DISTINCT  
r.IdRout
, vi.TitlePreactorOper
, vi.IdSemiProduct
, vi.IdProfession
, 4 AS TypeTime
, vi.CategoryOperation
, vi.OperOrder
, vi.Code
,  NPP
, vi.KTOPN
, vi.REL
, 0 AS isMappingRule
, ar.IdArea
, vi.SimpleProductId
FROM            InputData.Rout AS r 
INNER JOIN		InputData.Areas AS ar ON ar.IdArea = r.AreaId
INNER JOIN		InputData.VI_OperationsWithSemiProducts_FAST AS vi ON vi.IdSemiProduct = r.SemiProductId 
															AND ar.Code = vi.Code
WHERE        (r.CombineId IS NOT NULL) 
EXCEPT
SELECT DISTINCT  
r.IdRout
, vi.TitlePreactorOper
, vi.IdSemiProduct
, vi.IdProfession
, 4 AS TypeTime
, vi.CategoryOperation
, vi.OperOrder
, vi.Code
, NPP
, vi.KTOPN
, vi.REL
, 0 AS isMappingRule
, ar.IdArea
, vi.SimpleProductId
FROM            InputData.Rout AS r 
INNER JOIN		InputData.Areas AS ar ON ar.IdArea = r.AreaId
INNER JOIN		InputData.VI_OperationsWithSemiProducts_FAST AS vi ON vi.IdSemiProduct = r.SemiProductId 
															AND ar.Code = vi.Code  

OUTER APPLY InputData.ctvf_GetDisableOperationsForRout(r.IdRout) as fi
WHERE        (r.CombineId IS NOT NULL) 
AND KTOPN = fi.KTOP
		  


 


 
