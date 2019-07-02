CREATE TABLE [InputData].[Rout]
(
	[IdRout] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE,
	[SemiProductId] int NOT NULL, 
    [Priority] INT NOT NULL default (0), 
    [CombineId] INT NULL, 
	
    CONSTRAINT [FK_Rout_ToSemiProduct] FOREIGN KEY (SemiProductId) REFERENCES [InputData].[SemiProducts](IdSemiProduct)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_Rout_CombineRoutRules] FOREIGN KEY ([CombineId]) REFERENCES [SupportData].[CombineRules](IdCombineRules)
)
