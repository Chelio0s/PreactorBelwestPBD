CREATE TABLE [SupportData].[CombineComposition]
(
	[IdCombineComposition]	INT NOT NULL PRIMARY KEY IDENTITY,
	[CombineRulesId]		INT	NOT NULL,
	[RuleId]				INT NOT NULL,
	[RuleIsParent]			BIT NOT NULL, 
    CONSTRAINT [FK_CombineComposition_ToCombineRules] FOREIGN KEY (CombineRulesId) 
	REFERENCES [SupportData].[CombineRules](IdCombineRules) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_CombineComposition_ToRouteRules] FOREIGN KEY (RuleId) 
	REFERENCES  [SupportData].RoutRoules(IdRule) ON DELETE CASCADE ON UPDATE CASCADE

)
