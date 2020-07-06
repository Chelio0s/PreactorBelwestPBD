CREATE NONCLUSTERED INDEX IX_TempOperationIdNomenclature
ON [SupportData].[TempOperations] ([KTOPN])
INCLUDE ([IdNomenclature])