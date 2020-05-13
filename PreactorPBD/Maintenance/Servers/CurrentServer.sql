	--ссылка сервера на самого себя
	
	EXEC sp_addlinkedserver @server = N'CurrentServer',
                                                @srvproduct = N'',
                                                @provider = N'SQLOLEDB', 
                                                @datasrc = N'172.30.6.11'
	EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'CurrentServer',  @useself = 'false', @rmtuser = N'Trofimov', @rmtpassword = N'32306600'