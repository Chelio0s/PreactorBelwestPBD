CREATE TABLE [SupportData].[MappingResourceComposition]
(
   IdMappingComposition		INT PRIMARY KEY IDENTITY,
   MappingComposeResourceId INT NOT NULL,
   KOB						INT NOT NULL
   constraint FK_MAPPINGR_REFERENCE_MAPPINGC foreign key (MappingComposeResourceId)
      references [SupportData].MappingComposeResource (IdMappingComposeResource)
	  ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_MappingResourceComposition_Column] UNIQUE (MappingComposeResourceId, KOB)
)
