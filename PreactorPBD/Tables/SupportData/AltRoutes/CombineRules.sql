CREATE TABLE [SupportData].[CombineRules]
(
	[IdCombineRules] INT NOT NULL PRIMARY KEY IDENTITY, 
    [SemiProductId] INT NOT NULL,
	[Number_] INT NOT NULL
	CONSTRAINT [FK_CombineRules_ToSemiProduct] FOREIGN KEY (SemiProductId) REFERENCES [InputData].[SemiProducts](IdSemiProduct)
	ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_CombineRules_SemiIdNumber] UNIQUE(SemiProductId, Number_)
)
