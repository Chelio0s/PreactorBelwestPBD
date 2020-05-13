﻿CREATE TABLE [dbo].[passp]
(
	[FKGR] INT NOT NULL PRIMARY KEY, 
    [ART] NCHAR(10) NOT NULL, 
    [NORMA] DECIMAL(8, 2) NOT NULL, 
    [KPODTO] NCHAR(10) NULL, 
    [REL] INT NOT NULL, 
    [DOP] NCHAR(10) NULL, 
    [DOPN] NCHAR(10) NULL, 
    [TOL] NCHAR(10) NULL, 
    [KC] NCHAR(10) NULL, 
    [NC] NCHAR(10) NULL, 
    [FNGR] INT NULL, 
    [PR_MAT] NCHAR(10) NULL, 
    [KEI] NCHAR(10) NULL
)
