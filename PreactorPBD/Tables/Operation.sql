CREATE TABLE [InputData].[Operations]
(
	[IdOperation] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL, 
    [NumberOp] FLOAT NOT NULL, 
    [RoutId] INT NOT NULL, 
    [ProfessionId] INT NOT NULL, 
    [TypeTimeId] INT NOT NULL, 
    [CategoryOperation] INT NOT NULL, 
    [Code] varchar(4) NULL, 
    [MappingRuleId] INT NULL, 
    CONSTRAINT [FK_Operations_ToProfGroup] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_Operations_ToRout] FOREIGN KEY ([RoutId]) REFERENCES [InputData].[Rout](IdRout)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT [FK_Operations_ToMappingRule] FOREIGN KEY (MappingRuleId) REFERENCES [SupportData].[MappingRules]([IdRule])
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT [FK_Operations_ToTypeTime] FOREIGN KEY (TypeTimeId) REFERENCES [InputData].[TypeTimes](IdTypeTime)
)
