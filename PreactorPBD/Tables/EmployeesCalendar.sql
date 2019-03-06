CREATE TABLE [InputData].[EmployeesCalendar]
(
	[IdEmpCalendar] INT NOT NULL PRIMARY KEY IDENTITY,
	EmployeeID INT NOT NULL,
	[Start] DATETIME NOT NULL,
	[End] DATETIME NOT NULL, 
    CONSTRAINT [FK_EmployeesCalendar_ToEmployees] FOREIGN KEY (EmployeeID) REFERENCES InputData.Employees(IdEmployee)
)
