EXECUTE sp_addlinkedserver 
   @server = N'RKV',
   @srvproduct=N'chto_ugodno', 
   @provider=N'SQLNCLI11', 
   @datasrc=N'192.168.0.55'

GO
EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'RKV',  @useself = 'false', @rmtuser = 'rkv'
