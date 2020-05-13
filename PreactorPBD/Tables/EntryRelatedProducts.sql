CREATE TABLE [InputData].[EntryRelatedProducts]
(
	[SemiProductId]            INT              NOT NULL , 
    [OperationId]              INT              NOT NULL, 
    [RelatedProductId]         INT              NOT NULL, 
    [Count]                    NUMERIC(8, 2)    NOT NULL, 
    PRIMARY KEY ([SemiProductId], [RelatedProductId], [OperationId]), 
    CONSTRAINT [FK_EntryRelatedProducts_ToSemiProducts]         FOREIGN KEY (SemiProductId) 
    REFERENCES [InputData].[SemiProducts](IdSemiProduct),
    CONSTRAINT [FK_EntryRelatedProducts_ToOperation]            FOREIGN KEY (OperationId) 
    REFERENCES [InputData].[Operations](IdOperation)            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_EntryRelatedProducts_ToRelatedProducts]      FOREIGN KEY (RelatedProductId) 
    REFERENCES [InputData].[RelatedProducts](IdRelatedProduct)  
)
