internal class RuleOperations
{
    public int IdRule { get; set; }
    public string Title { get; set; }
    public int KTOP { get; set; }

    protected bool Equals(RuleOperations other)
    {
        return IdRule == other.IdRule && string.Equals(Title, other.Title) && KTOP == other.KTOP;
    }
    public override bool Equals(object obj)
    {
        if (ReferenceEquals(null, obj)) return false;
        if (ReferenceEquals(this, obj)) return true;
        if (obj.GetType() != this.GetType()) return false;
        return Equals((RuleOperations)obj);
    }
    public override int GetHashCode()
    {
        unchecked
        {
            var hashCode = IdRule;
            hashCode = (hashCode * 397) ^ (Title != null ? Title.GetHashCode() : 0);
            hashCode = (hashCode * 397) ^ KTOP;
            return hashCode;
        }
    }
}