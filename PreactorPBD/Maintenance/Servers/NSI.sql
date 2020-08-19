EXECUTE sp_addlinkedserver 
   @server = N'NSI',
   @srvproduct=N'chto_ugodno', 
   @provider=N'OraOLEDB.Oracle', 
   @datasrc=N'(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = 176.60.208.2)(PORT = 1521))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ORCL)))'

GO
EXECUTE sp_addlinkedsrvlogin @rmtsrvname = N'NSI',  @useself = 'false', @rmtuser = 'GUI_SAP', @rmtpassword = '_Gui_sap'
