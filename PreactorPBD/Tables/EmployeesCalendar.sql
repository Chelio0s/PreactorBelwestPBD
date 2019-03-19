﻿CREATE TABLE [InputData].[EmployeesCalendar]
(
	[IdEmpCalendar] INT NOT NULL PRIMARY KEY IDENTITY,
	EmployeeID VARCHAR(15) NOT NULL,
	[Start] DATETIME NOT NULL,
	[End] DATETIME NOT NULL, 
    CONSTRAINT [FK_EmployeesCalendar_ToEmployees] FOREIGN KEY (EmployeeID) REFERENCES InputData.Employees(TabNum)
	ON UPDATE CASCADE ON DELETE CASCADE
)
