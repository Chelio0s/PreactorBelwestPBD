CREATE TABLE [SupportData].[MappingOperationComposition]
(
   IdMappingComposition		 INT PRIMARY KEY IDENTITY,
   MappingComposeOperationId INT  NOT NULL,
   KTOP						 INT  NOT NULL
   CONSTRAINT FK_MAPPINGO_REFERENCE_MAPPINGC FOREIGN KEY (MappingComposeOperationId)
      REFERENCES [SupportData].MappingComposeOperation (IdMappingComposeOperation)
	  ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_MappingOperationComposition_Column] UNIQUE(MappingComposeOperationId, KTOP)
)
