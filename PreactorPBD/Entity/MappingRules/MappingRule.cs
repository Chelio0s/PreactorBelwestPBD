namespace PreactorPBD
{
    readonly struct MappingRule
    {
        public MappingRule(int idMappingRule, int kobparent, int kobchild, int ktopparent, int ktopchild)
        {
            IdMappingRule = idMappingRule;
            ParentOperation = new Operation(ktopparent, kobparent);
            ChildOperation = new Operation(ktopchild, kobchild);
        }

        public MappingRule(int idMappingRule, Operation parentOperation, Operation childOperation)
        {
            IdMappingRule = idMappingRule;
            ParentOperation = parentOperation;
            ChildOperation = childOperation;
        }

        public int IdMappingRule { get; }
        public Operation ParentOperation { get; }
        public Operation ChildOperation { get; }
    }
}
