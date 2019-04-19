CREATE FUNCTION [InputData].[udf_GetTitleOperation]
(
	@KTOPN varchar(10),
	@NTOP varchar(150)
)
RETURNS varchar(99)
AS
BEGIN
DECLARE @Return varchar(99)

SELECT @Return =
CASE WHEN (SELECT  title
			FROM SupportData.[GroupKTOP] as ktop
			INNER JOIN SupportData.[GroupsOperations] as gr ON gr.IdGroupOperations = ktop.GroupOperationId
			WHERE KTOP = @KTOPN) is null THEN @NTOP 
			ELSE (SELECT  title
			FROM SupportData.[GroupKTOP] as ktop
			INNER JOIN SupportData.[GroupsOperations] as gr ON gr.IdGroupOperations = ktop.GroupOperationId
			WHERE KTOP = @KTOPN) END
	RETURN @Return
END
