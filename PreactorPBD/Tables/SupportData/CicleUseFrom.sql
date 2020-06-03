CREATE TABLE [SupportData].[CicleUseFrom]
(
	[IdCicleUseFrom] INT NOT NULL           PRIMARY KEY IDENTITY, 
    [CicleId] INT NOT NULL, 
    [StartUseFrom] DATE NOT NULL, 
    [SpecificOrgUnit] INT NULL, 
    [DateChanged] DATE NOT NULL             DEFAULT getdate(), 
    [User] NCHAR(50) NOT NULL               DEFAULT suser_sname(), 
    
    CONSTRAINT [FK_Cicle_ToCicleUseFrom]    FOREIGN KEY (CicleId) 
    REFERENCES [SupportData].[Cicle]([IdCicle])
	ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT [FK_CicleUseFrom_ToOrgUnit] FOREIGN KEY (SpecificOrgUnit) 
    REFERENCES [SupportData].[OrgUnit](OrgUnit)
)
