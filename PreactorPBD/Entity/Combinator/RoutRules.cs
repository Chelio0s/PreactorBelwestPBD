
namespace PreactorSDB
{
    readonly struct RoutRules
    {
        public  RoutRules(int idRoutRules, int ruleGroupId)
        {
            IdRoutRule = idRoutRules;
            RuleGroupId = ruleGroupId;
        }
        public int IdRoutRule { get; }
        public  int RuleGroupId { get;  }
    }
}
