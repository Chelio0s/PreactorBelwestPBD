CREATE TRIGGER [tgr_restrictionDeleteOrgUnit]
ON  [SupportData].[OrgUnit] INSTEAD OF DELETE
AS
RAISERROR ('Удаление данных из таблицы [SupportData].[OrgUnit] запрещено. Талица содержит настроечные данные.
Удаление может привести к нарушению целостности базы данных', 16, -1)
RETURN