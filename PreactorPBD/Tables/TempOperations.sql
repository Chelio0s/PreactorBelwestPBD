CREATE TABLE [SupportData].[TempOperations]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [IdNomenclature] INT NOT NULL, 
	[REL] NCHAR(15) NULL,
    [Model] NVARCHAR(15) NOT NULL, 
    [Article] NCHAR(15) NOT NULL, 
    [Nomenclature] NCHAR(20) NOT NULL, 
    [Size] FLOAT NOT NULL, 
    [KPO] NCHAR(15) NOT NULL, 
    [Code] VARCHAR(5) NOT NULL, 
    [KTOPN] SMALLINT NOT NULL, 
    [NTOP] NVARCHAR(99) NOT NULL, 
    [PONEOB] BIT NOT NULL, 
    [NORMATIME] DECIMAL(5, 2) NOT NULL, 
    [KOB] SMALLINT NOT NULL, 
    [MOB] NVARCHAR(99)  NULL, 
    [KPROF] NCHAR(10) NOT NULL,
	[CategoryOperation] INT NOT NULL,
	[TitlePreactorOper] NVARCHAR(99) NOT NULL,
	[NPP] INT NOT NULL, 
	InsertedDate NVARCHAR(99) DEFAULT GetDate() NOT NULL, 
    [KOLD] INT NOT NULL, 
    [KOLN] NCHAR(10) NOT NULL
)

GO

CREATE INDEX [IX_TempOperations_Column] ON [SupportData].[TempOperations] ([IdNomenclature], Code, KTOPN)
