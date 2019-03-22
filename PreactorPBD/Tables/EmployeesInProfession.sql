CREATE TABLE [InputData].[EmployeesInProfession]
(
	[EmployeeId] VARCHAR(15) NOT NULL , 
    [ProfessionId] INT NOT NULL, 
    [CategoryProfession] INT NOT NULL, 
    [IsPrimary] BIT NOT NULL, 
    CONSTRAINT [FK_EmployeesInProfession_ToEmployee] FOREIGN KEY (EmployeeId) REFERENCES [InputData].Employees(TabNum)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_EmployeesInProfession_ToProfession] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [PK_EmployeesInProfession] PRIMARY KEY ([EmployeeId], [ProfessionId], [CategoryProfession])
)

GO

CREATE INDEX [UK_EmployeesInProfession_EmpID_IsPrimary] ON [InputData].[EmployeesInProfession] (EmployeeId, IsPrimary)
