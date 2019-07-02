create table [SupportData].ComposeOperation (
   idComposeOper        int                  not null IDENTITY,
   Title                varchar(99)          not null UNIQUE,
   constraint PK_COMPOSEOPERATION primary key (idComposeOper)
)