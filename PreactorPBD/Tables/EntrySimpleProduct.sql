CREATE TABLE [SupportData].[EntrySimpleProduct]
(
	[SimpleProductId] INT NOT NULL , 
    [SimpleProductIdChild] INT NOT NULL, 
    CONSTRAINT [PK_EntrySimpleProduct] PRIMARY KEY ([SimpleProductId], [SimpleProductIdChild]), 
    CONSTRAINT [FK_EntrySimpleProduct_ToSimpleProduct1] FOREIGN KEY (SimpleProductId) REFERENCES [SupportData].[SimpleProduct]([IdSimpleProduct]), 
    CONSTRAINT [FK_EntrySimpleProduct_ToSimpleProduct2] FOREIGN KEY (SimpleProductIdChild) REFERENCES [SupportData].[SimpleProduct]([IdSimpleProduct])
)
