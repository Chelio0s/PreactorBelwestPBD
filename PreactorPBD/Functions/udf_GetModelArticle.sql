﻿--CREATE FUNCTION [InputData].[udf_GetModelArticle]
--(
--	@article as varchar(99)
--)
--RETURNS varchar(99)
--AS
--BEGIN
--DECLARE @commandText as nvarchar(max) = 'SELECT distinct INDEX_MODEL
--                FROM gui_sap.MKZ_MAIN a 
--                INNER JOIN gui_sap.MKZ_ART c ON a.id = c.id_model 
--             where  art = ' + @article
--			 DECLARE @return as varchar(99)

--	DECLARE @tempMKZ_ART TABLE (Model varchar(15))
--insert @tempMKZ_ART
--	EXEC [InputData].[pc_Select_Oralce_MPU] @selectCommandText = @commandText
--	SELECT @return =  Model FROM @tempMKZ_ART
--	RETURN @return
--END
