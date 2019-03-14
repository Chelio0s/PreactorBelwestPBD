CREATE TABLE [InputData].[EmployeesInProfession]
(
	[EmployeeId] INT NOT NULL , 
    [ProfessionId] INT NOT NULL, 
    [CategoryProfession] INT NOT NULL, 
    PRIMARY KEY ([EmployeeId], [ProfessionId]), 
    CONSTRAINT [FK_EmployeesInProfession_ToEmployee] FOREIGN KEY (EmployeeId) REFERENCES [InputData].Employees(IdEmployee)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_EmployeesInProfession_ToProfession] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession)
)
