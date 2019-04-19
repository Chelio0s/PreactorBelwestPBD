EXECUTE sp_addlinkedserver 
   @server = N'MPU',
   @srvproduct=N'chto_ugodno', 
   @provider=N'OraOLEDB.Oracle', 
   @datasrc=N'(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = prod.vit.belwest.com)(PORT = 1521))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = orcl.Belw-MPUDB)))'

GO
EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'MPU',  @useself = 'false', @rmtuser = 'SergeyTrofimov', @rmtpassword = 'jC7EGzQ1pX'
