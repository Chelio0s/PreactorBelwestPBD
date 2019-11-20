namespace PreactorPBD
{
    public struct OperationWithTimeAndProffs
    {
        public OperationWithTimeAndProffs(int ktop, int kob, decimal time, int category, int codeProff)
        {
            KTOP = ktop;
            KOB = kob;
            Time = time;
            Category = category;
            CodeProff = codeProff;
        }
        public int KTOP { get; }
        public int KOB { get; }
        public decimal Time { get; }
        public int Category { get; }
        public int CodeProff { get; }
    }
}
