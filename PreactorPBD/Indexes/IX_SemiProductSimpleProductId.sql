CREATE NONCLUSTERED INDEX IX_SemiProductSimpleProductId
ON [InputData].[SemiProducts] ([SimpleProductId])
INCLUDE ([IdSemiProduct])