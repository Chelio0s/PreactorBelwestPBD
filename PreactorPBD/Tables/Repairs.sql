CREATE TABLE [SupportData].[Repairs]
(
	[IdRepairs]		INT			NOT NULL PRIMARY KEY IDENTITY,
	[DepartmentId]	INT			NOT NULL,
	[KOB]			INT			NOT NULL,
	[Count]			INT			NOT NULL,
	[DateStart]		DATETIME	NOT NULL,
	[DateEnd]		DATETIME	NOT NULL, 
	CONSTRAINT [FK_Repairs_ToDepartments] FOREIGN KEY (DepartmentId) REFERENCES [InputData].[Departments](IdDepartment)
	ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_Repairs_Dates] CHECK (DateStart < DateEnd), 
    CONSTRAINT [UK_Repairs_DepKOBDate] UNIQUE ([DepartmentId], [KOB], [DateStart], [DateEnd])
)
