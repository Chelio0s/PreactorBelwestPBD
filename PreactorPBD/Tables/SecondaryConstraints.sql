﻿CREATE TABLE [InputData].[SecondaryConstraints]
(
	[IdSecondaryConstraint] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE,

)
