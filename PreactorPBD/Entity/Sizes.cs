readonly struct Sizes
{
    public Sizes(decimal value, decimal count)
    {
        Value = value;
        Count = count;
    }
    public decimal Value { get; }
    public decimal Count { get; }
}