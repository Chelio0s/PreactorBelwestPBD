CREATE TABLE [InputData].[EntrySemiProduct]
(
	[IdSemiProduct] INT NOT NULL , 
    [IdSemiProductChild] INT NOT NULL, 
    PRIMARY KEY ([IdSemiProduct], [IdSemiProductChild]), 
    CONSTRAINT [FK_EntrySemiProduct_ToSemiProduct] FOREIGN KEY ([IdSemiProduct]) REFERENCES [InputData].[SemiProducts]([IdSemiProduct]),
	CONSTRAINT [FK_EntrySemiProduct_ToSemiProductEntry] FOREIGN KEY ([IdSemiProductChild]) REFERENCES [InputData].[SemiProducts]([IdSemiProduct])
	
)
