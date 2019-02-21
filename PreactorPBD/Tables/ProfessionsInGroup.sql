CREATE TABLE [InputData].[ProfessionsInGroup]
(
	[ProfessionId] INT NOT NULL , 
    [ProfessionGroupId] INT NOT NULL, 
    PRIMARY KEY ([ProfessionGroupId], [ProfessionId]), 
    CONSTRAINT [FK_ProfessionsInGroup_ToTable] FOREIGN KEY (ProfessionId) REFERENCES [InputData].Professions(IdProfession), 
    CONSTRAINT [FK_ProfessionsInGroup_ToTable_1] FOREIGN KEY ([ProfessionGroupId]) REFERENCES [InputData].ProfessionGroups(IdProfessionGroups)

)
