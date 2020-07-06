CREATE NONCLUSTERED INDEX IX_OperationsIdTitleRouteCategory
ON [InputData].[Operations] ([Code])
INCLUDE ([IdOperation],[Title],[RoutId],[CategoryOperation])