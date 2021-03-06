﻿CREATE TABLE [InputData].[ResourcesGroup]
(
	[IdResourceGroup]	INT						NOT NULL PRIMARY KEY IDENTITY, 
    [Title]				NVARCHAR(99)			NOT NULL UNIQUE, 
    [ChangeDate]		DATETIME				NOT NULL DEFAULT(GETDATE()), 
    [User]				NVARCHAR(99)			NOT NULL DEFAULT(SUSER_SNAME())
)
