namespace PreactorPBD
{
    struct MappingRuleFull
    {
        public MappingRuleFull(int areaId, int idRout, int idRule, int idSemiProduct, int kobChild, int kobParent, int ktopChild,
            int ktopParent, bool needCountDetails, decimal normaTimeNew, decimal normaTimeOld, decimal timeAddiction, decimal timeCoefficient, int simpleProductId
            ,int categoryOperation, int codeProff)
        {
            AreaId = areaId;
            IdRout = idRout;
            IdRule = idRule;
            IdSemiProduct = idSemiProduct;
            KOBChild = kobChild;
            KOBParent = kobParent;
            KTOPChild = ktopChild;
            KTOPParent = ktopParent;
            NeedCountDetails = needCountDetails;
            NormaTimeNew = normaTimeNew;
            NormaTimeOld = normaTimeOld;
            TimeAddiction = timeAddiction;
            TimeCoefficient = timeCoefficient;
            SimpleProductId = simpleProductId;
            CategoryOperation = categoryOperation;
            CodeProff = codeProff;
        }

        public int IdRule { get; }
        public int AreaId { get; }
        public decimal TimeCoefficient { get; }
        public decimal TimeAddiction { get; }
        public bool NeedCountDetails { get; }
        public int KOBParent { get; }
        public int KOBChild { get; }
        public int KTOPParent { get; }
        public int KTOPChild { get; }
        public decimal NormaTimeOld { get; }
        public decimal NormaTimeNew { get; }
        public int IdSemiProduct { get; }
        public int IdRout { get; }
        public int SimpleProductId { get; }
        public int CategoryOperation { get; }
        public int CodeProff { get; }
    }
}