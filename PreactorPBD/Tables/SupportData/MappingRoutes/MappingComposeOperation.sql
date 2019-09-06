CREATE TABLE [SupportData].[MappingComposeOperation]
(
   [IdMappingComposeOperation]	INT				PRIMARY KEY IDENTITY,
   [Title]						VARCHAR(99)		NOT NULL UNIQUE,
   [User]						NVARCHAR(20)	NOT NULL DEFAULT(SUSER_SNAME()), 
   [DateChanged]				DATETIME		NOT NULL DEFAULT(GETDATE())
)
