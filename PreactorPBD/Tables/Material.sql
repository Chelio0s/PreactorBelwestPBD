﻿CREATE TABLE [InputData].[Material]
(
	[IdMaterial] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [Attribute] NVARCHAR(99) NOT NULL
)
