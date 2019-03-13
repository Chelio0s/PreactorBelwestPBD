CREATE TABLE [LogData].[Log](
[LoginName] [varchar](2000) NULL,
[HostName] [varchar](100) NULL,
[ObjectName] [varchar](100) NULL,
[ObjectType] [varchar](100) NULL,
[EventType] [varchar](100) NULL,
[EventSQLCommand] [varchar](max) NULL,
[EventTime] [datetime] NOT NULL,
[XMLChange] [xml] NULL,
[Id] [int] IDENTITY(1,1) NOT NULL,
[IP_address] [nvarchar](50) null
CONSTRAINT [PK_tbl_ListChange] PRIMARY KEY CLUSTERED
(
[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

