CREATE TABLE [dbo].[ProfessionsInGroup]
(
	[ProfessionId] INT NOT NULL , 
    [ProfessionGroupId] INT NOT NULL, 
    PRIMARY KEY ([ProfessionGroupId], [ProfessionId]), 
    CONSTRAINT [FK_ProfessionsInGroup_ToTable] FOREIGN KEY (ProfessionId) REFERENCES Professions(IdProfession), 
    CONSTRAINT [FK_ProfessionsInGroup_ToTable_1] FOREIGN KEY ([ProfessionGroupId]) REFERENCES ProfessionGroups(IdProfessionGroups)

)
