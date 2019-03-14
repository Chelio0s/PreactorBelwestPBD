CREATE TABLE [InputData].[OperationInResource]
(
	[IdOpInResource] INT NOT NULL PRIMARY KEY IDENTITY, 
    [OperationId] INT NOT NULL, 
    [ResourceId] INT NOT NULL, 
    [OperateTime] FLOAT NOT NULL, 
    CONSTRAINT [FK_OperationInResource_ToOperations] FOREIGN KEY (OperationId) REFERENCES [InputData].[Operations](IdOperation)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_OperationInResource_ToResource] FOREIGN KEY (ResourceId) REFERENCES [InputData].[Resources](IdResource)
)
