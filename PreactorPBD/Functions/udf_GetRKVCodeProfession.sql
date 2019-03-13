--Выбирает код профессии RKV по коду профессии из SAP

CREATE FUNCTION [InputData].[udf_GetRKVCodeProfession]
(
    --Код профессии SAP
	@codeProfSAP VARCHAR(50)
)
RETURNS INT
AS
BEGIN
DECLARE @res AS VARCHAR(50)
	 SELECT  TOP(1) @res =  KPROF FROM  [RKV].[RKV_SCAL].[dbo].[d_sap_vika10]
	 WHERE [ALT_KPROF] = @codeProfSAP
	 RETURN @res
END
