﻿CREATE TABLE [dbo].[Employees]
(
	[IdEmployee] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(99) NOT NULL, 
    [TabNum] NVARCHAR(99) NOT NULL UNIQUE
)
