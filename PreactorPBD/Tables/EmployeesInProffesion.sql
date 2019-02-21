CREATE TABLE [InputData].[EmployeesInProffesion]
(
	[EmployeeId] INT NOT NULL , 
    [ProfessionId] INT NOT NULL, 
    PRIMARY KEY ([EmployeeId], [ProfessionId]), 
    CONSTRAINT [FK_EmployeesInProffesion_ToEmployee] FOREIGN KEY (EmployeeId) REFERENCES [InputData].Employees(IdEmployee), 
    CONSTRAINT [FK_EmployeesInProffesion_ToProfession] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession)
)
