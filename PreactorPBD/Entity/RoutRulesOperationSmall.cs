
struct RoutRulesOperationSmall
{
    public RoutRulesOperationSmall(int IdRout, int SemiProductId, int RuleId, bool RuleIsParent)
    {
        this.IdRout = IdRout;
        this.SemiProductId = SemiProductId;
        this.RuleId = RuleId;
        this.RuleIsParent = RuleIsParent;
    }
    public int IdRout { get; set; }
    public int SemiProductId { get; set; }
    public int RuleId { get; set; }
    public bool RuleIsParent { get; set; }
}

