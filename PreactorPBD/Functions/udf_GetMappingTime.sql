CREATE FUNCTION [InputData].[udf_GetMappingTime]
(
	@norma				decimal(6,2),
	@koef				decimal(6,2),
	@addictionTime		decimal(6,2),
	@NeedCountDetails	bit,
	@KOLD				int
)
RETURNS DECIMAL(6,2)
AS
BEGIN
	RETURN CASE WHEN @NeedCountDetails = 1 THEN @norma + (@addictionTime * @KOLD)*@koef 
				WHEN @NeedCountDetails = 0 THEN @norma * @koef + @addictionTime END
END
