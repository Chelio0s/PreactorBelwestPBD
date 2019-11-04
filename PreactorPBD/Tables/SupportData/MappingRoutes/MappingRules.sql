CREATE TABLE [SupportData].[MappingRules]
(
	IdRule							INT  PRIMARY KEY IDENTITY,
	AreaId							INT                  NOT NULL,
	OperationMappingParentId		INT                  NOT NULL,
	OperationMappingChildId			INT                  NOT NULL,
	MappingComposeResourceParentId	INT                  NOT NULL,
	MappingComposeResourceChildId	INT                  NOT NULL,
	TimeCoefficient					DECIMAL(3,2)         NOT NULL	DEFAULT(1), 
    [AddDate]						DATETIME			 NOT NULL	DEFAULT(Getdate()), 
    [TimeAddiction]					DECIMAL(3, 2)			NOT NULL	DEFAULT (0), 
    [NeedCountDetails] BIT NOT NULL DEFAULT (0), 
    CONSTRAINT [CK_MappingRules_MappingKTOP] 
		UNIQUE (OperationMappingParentId, OperationMappingChildId, MappingComposeResourceParentId, MappingComposeResourceChildId, AreaId),
	CONSTRAINT FK_MAPPINGR_REFERENCE_COMPOSEPARENT	FOREIGN KEY (OperationMappingParentId)
		REFERENCES [SupportData].[MappingComposeOperation] (IdMappingComposeOperation),
	CONSTRAINT FK_MAPPINGR_REFERENCE_COMPOSECHILD	FOREIGN KEY (OperationMappingChildId)
		REFERENCES [SupportData].MappingComposeOperation (IdMappingComposeOperation),
	CONSTRAINT FK_MAPPINGR_REFERENCE_RESPARENT		FOREIGN KEY (MappingComposeResourceParentId)
		REFERENCES [SupportData].MappingComposeResource (IdMappingComposeResource),
	CONSTRAINT FK_MAPPINGR_REFERENCE_RESCHILD		FOREIGN KEY (MappingComposeResourceChildId)
		 REFERENCES [SupportData].MappingComposeResource (IdMappingComposeResource),
	CONSTRAINT FK_MAPPINGR_REFERENCE_DEPART			FOREIGN KEY (AreaId)
		REFERENCES [InputData].[Areas] (IdArea)
)
