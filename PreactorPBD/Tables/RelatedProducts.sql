CREATE TABLE [InputData].[RelatedProducts]
(
	[IdRelatedProduct]  INT             NOT NULL PRIMARY KEY IDENTITY, 
    [Title]             NVARCHAR(99)    NOT NULL UNIQUE, 
    [Count ]            NUMERIC(8, 2)   NOT NULL, 
    [SemiProductId]     INT             NOT NULL, 
    [OperationId]       INT             NOT NULL, 
    CONSTRAINT [FK_RelatedProducts_ToSemiProducts]          FOREIGN KEY (SemiProductId) 
    REFERENCES [InputData].[SemiProducts](IdSemiProduct),
    CONSTRAINT [FK_RelatedProducts_ToOperation]             FOREIGN KEY (OperationId) 
    REFERENCES [InputData].[Operations](IdOperation)        ON DELETE CASCADE ON UPDATE CASCADE
)
