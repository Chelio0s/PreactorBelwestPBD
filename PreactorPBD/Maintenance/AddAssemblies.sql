USE PreactorSDBTest
GO
 exec sp_configure 'clr enabled', 1
 reconfigure
 EXEC sp_changedbowner 'sa'
 ALTER DATABASE PreactorSDBTest  SET TRUSTWORTHY ON
CREATE ASSEMBLY my

FROM 'C:\Accessibility\Oracle.ManagedDataAccess.dll'
WITH PERMISSION_SET = UNSAFE; 