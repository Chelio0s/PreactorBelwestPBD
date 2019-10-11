create table [SupportData].ComposeOperation (
   idComposeOper        int                  not null IDENTITY,
   Title                varchar(99)          not null UNIQUE,
   [Date] DATETIME NOT NULL DEFAULT GETDATE(), 
   [User] VARCHAR(99) NOT NULL DEFAULT SUSER_SNAME(), 
   CONSTRAINT PK_COMPOSEOPERATION primary key (idComposeOper)
)