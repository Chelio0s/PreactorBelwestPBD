internal readonly struct RoutRule
{
    public RoutRule(int IdRoutRule, int GroupId)
    {
        this.IdRoutRule = IdRoutRule;
        this.GroupId = GroupId;
    }
    public  int IdRoutRule { get;  }
    public  int GroupId { get;  }
}