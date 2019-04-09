CREATE TRIGGER [tgr_DDLListChange]
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS


SET NOCOUNT ON

DECLARE @dataXML XML
SET @dataXML = EVENTDATA() --— получил данные по текущему событию.

IF (
SELECT @dataXML.value('(/EVENT_INSTANCE/ObjectName)[1]' ,'varchar(max)')
) IS NOT NULL
BEGIN
INSERT [LogData].[Log]
(
LoginName --— под чьим логином
,HostName --— на чьей машине
,ObjectName --— что изменено
,ObjectType --— тип измененного обьекта
,EventType --— тип изменения
,EventSQLCommand --— полностью SQL команда
,EventTime --— во сколь изменено
,XMLChange --— полностью вся хмл-команда
,IP_address
)
VALUES
(
@dataXML.value('(/EVENT_INSTANCE/LoginName)[1]' ,'varchar(2000)') --— под чьим логином
,HOST_NAME() --— на чьей машине
,@dataXML.value('(/EVENT_INSTANCE/ObjectName)[1]' ,'varchar(100)') --— что изменено
,@dataXML.value('(/EVENT_INSTANCE/ObjectType)[1]' ,'varchar(100)') --— тип измененного обьекта
,@dataXML.value('(/EVENT_INSTANCE/EventType)[1]' ,'varchar(100)') --— тип изменения
,@dataXML.value('(/EVENT_INSTANCE/TSQLCommand)[1]' ,'varchar(max)') --— полностью SQL команда
,GETDATE()
,@dataXML
,(
  SELECT  dmec.client_net_address 
  FROM sysprocesses sp 
  JOIN sys.dm_exec_connections dmec ON sp.spid = dmec.session_id
  WHERE sp.spid = @@SPID)
)
END