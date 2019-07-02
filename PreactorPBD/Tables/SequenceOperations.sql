CREATE TABLE [SupportData].[SequenceOperations]
(
	[IdSeqOperation] INT NOT NULL PRIMARY KEY IDENTITY, 
    [OperOrder] INT NOT NULL, 
    [KTOP] INT NOT NULL, 
    [Title] NVARCHAR(99) NOT NULL, 
    [SimpleProductId] INT NOT NULL, 
    [Changed] DATETIME NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_SequenceOperations_ToSimpleProduct] FOREIGN KEY (SimpleProductId) REFERENCES [SupportData].[SimpleProduct](IdSimpleProduct)
	ON UPDATE CASCADE
)
