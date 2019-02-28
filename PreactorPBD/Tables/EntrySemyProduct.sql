CREATE TABLE [InputData].[EntrySemyProduct]
(
	[IdSemiProduct] INT NOT NULL , 
    [IdSemiProductChild] INT NOT NULL, 
    PRIMARY KEY ([IdSemiProduct], [IdSemiProductChild]), 
    CONSTRAINT [FK_EntrySemyProduct_ToSemiProduct] FOREIGN KEY ([IdSemiProduct]) REFERENCES [InputData].[SemiProducts]([IdSemiProduct]),
	CONSTRAINT [FK_EntrySemyProduct_ToSemiProductEntry] FOREIGN KEY ([IdSemiProductChild]) REFERENCES [InputData].[SemiProducts]([IdSemiProduct])
)
