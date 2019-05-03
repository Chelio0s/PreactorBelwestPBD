CREATE VIEW [InputData].[VI_MaterialsFromRKV_SLOW]
	AS 

SELECT	driveart.ART
		,d1.REL
		,passp.FKGR
		,passp.NORMA
		,driveart.KTOPN
		,passp.KPODTO
FROM       [$(RKV)].[$(PLANT)].dbo.DRIVE_ART AS driveart 
INNER JOIN [$(RKV)].[$(PLANT)].dbo.drive1 AS d1 ON d1.REL = driveart.REL 
INNER JOIN [$(RKV)].[$(POTREB)].dbo.passp AS passp ON passp.FKGR = d1.FKGR AND passp.ART = driveart.ART 
                
WHERE  (passp.NORMA <> 0) 
