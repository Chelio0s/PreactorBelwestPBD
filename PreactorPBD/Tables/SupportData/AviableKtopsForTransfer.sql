CREATE TABLE [InputData].[AviableKtopsForTransfer]
(
	[IdAviable] INT NOT NULL PRIMARY KEY IDENTITY,
	[AreaId]	INT NOT NULL,
	[KTOP]		INT NOT NULL, 
    CONSTRAINT [UK_AviableKtopsForTransfer_AreaIdKtop] UNIQUE ([AreaId],[KTOP]), 
    CONSTRAINT [FK_AviableKtopsForTransfer_ToArea] FOREIGN KEY (AreaId) REFERENCES [InputData].[Areas](IdArea)

)
