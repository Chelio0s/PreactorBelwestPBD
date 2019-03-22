CREATE TABLE [InputData].[EmployeesCalendar]
(
	[IdEmpCalendar] INT NOT NULL PRIMARY KEY IDENTITY,
	[OrgUnit] INT NOT NULL,
	[Start] DATETIME NOT NULL,
	[End] DATETIME NOT NULL, 
    CONSTRAINT [FK_EmployeesCalendar_ToEmployees] FOREIGN KEY ([OrgUnit]) REFERENCES [SupportData].[Orgunit]([OrgUnit])
	ON UPDATE CASCADE ON DELETE CASCADE
)
