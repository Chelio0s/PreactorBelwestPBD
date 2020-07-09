CREATE PROCEDURE [LogData].[WriteInsertingLog]
	@text nvarchar(99),
	@timeMs int
AS
	INSERT INTO [LogData].[InsertingLog] (Title, DurationMs)
	VALUES (@text, @timeMs)
RETURN 0
