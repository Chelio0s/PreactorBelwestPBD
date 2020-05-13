CREATE TABLE [SupportData].[DepartComposition]
(
	[IdDepComposition]			INT				NOT NULL		PRIMARY KEY IDENTITY, 
    [DepartmentId]				INT				NOT NULL, 
    [ResourcesGroupId]			INT				NOT NULL, 
	[ChangeDate]				DateTime		NOT NULL		DEFAULT(GETDATE()),
	[User]						NVARCHAR(99)	NOT NULL		DEFAULT (SUSER_SNAME())
    CONSTRAINT [FK_DepartComposition_ToDepartments] FOREIGN KEY ([DepartmentId]) REFERENCES [InputData].[Departments]([IdDepartment])
	ON UPDATE CASCADE, 
    CONSTRAINT [FK_DepartComposition_ToResourcesGroup] FOREIGN KEY (ResourcesGroupId) REFERENCES [InputData].[ResourcesGroup](IdResourceGroup)
	ON DELETE CASCADE ON UPDATE CASCADE
)
