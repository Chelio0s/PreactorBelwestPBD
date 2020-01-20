--kill all connections for particular DB
CREATE PROCEDURE [System].[sp_KillConnections]
	@DBName NVARCHAR(99)
AS
	SET NOCOUNT OFF
	DECLARE @query VARCHAR(MAX)
	SET @query = ''

 
	IF db_id(@DBName) < 4
		BEGIN
			print 'system database connection cannot be killeed'
			RETURN
		END

	SELECT @query=coalesce(@query,',' )+'kill '+convert(varchar, spid)+ '; '
	FROM master..sysprocesses 
	WHERE dbid=db_id(@DBName)

	IF len(@query) > 0
		BEGIN
			print @query
			exec(@query)
		END
RETURN 0
