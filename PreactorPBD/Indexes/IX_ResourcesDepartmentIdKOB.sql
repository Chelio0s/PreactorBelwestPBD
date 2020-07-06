CREATE NONCLUSTERED INDEX IX_ResourcesDepartmentIdKOB
ON [InputData].[Resources] ([DepartmentId],[KOB])
INCLUDE ([IdResource],[TitleWorkPlace])