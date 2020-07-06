CREATE NONCLUSTERED INDEX IX_EntrySemiProductsSemiProdChild
ON [InputData].[EntrySemiProduct] ([IdSemiProductChild])
INCLUDE ([IdSemiProduct])
