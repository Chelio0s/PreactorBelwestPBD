CREATE TABLE [SupportData].[SimpleProduct]
(
	[IdSimpleProduct]           INT             NOT NULL  IDENTITY, 
    [Title]                     NVARCHAR(99)    NOT NULL  UNIQUE, 
    PRIMARY KEY ([IdSimpleProduct])
)

GO
