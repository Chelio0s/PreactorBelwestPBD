CREATE TABLE [SupportData].[EntrySupportRelatedProducts]
(
	[SimpleProductId]           INT             NOT NULL , 
    [SupportRelatedProductId]   INT             NOT NULL, 
    [Count]                     NUMERIC(8, 2)   NOT NULL, 
    CONSTRAINT [FK_EntryRelatedProducts_ToSimleProduct] FOREIGN KEY (SimpleProductId) 
    REFERENCES [SupportData].[SimpleProduct]([IdSimpleProduct]),
    CONSTRAINT [FK_EntryRelatedProducts_SupportRelatedProductId] FOREIGN KEY ([SupportRelatedProductId]) 
    REFERENCES [SupportData].[SupportRelatedProducts]([IdSupportRelatedProduct]) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY ([SimpleProductId], [SupportRelatedProductId])
)
