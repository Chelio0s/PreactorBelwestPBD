﻿CREATE TABLE [dbo].[Departments]
(
	[IdDepartment] INT NOT NULL PRIMARY KEY IDENTITY,  
    [Title] NVARCHAR(99) NOT NULL UNIQUE
)
