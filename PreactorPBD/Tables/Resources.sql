﻿CREATE TABLE [InputData].[Resources]
(
	[IdResource] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [TitleWorkPlace] NVARCHAR(99) NOT NULL, 
    [DepartmentId] INT NOT NULL, 
    [EmployeeId] INT NOT NULL, 
    CONSTRAINT [FK_Resources_ToDepartment] FOREIGN KEY ([DepartmentId]) REFERENCES [InputData].[Departments](IdDepartment),
	  CONSTRAINT [FK_Resources_ToEmployees] FOREIGN KEY ([EmployeeId]) REFERENCES [InputData].Employees(IdEmployee)

)
