using System.Security.Principal;

namespace PreactorPBD
{
    public readonly struct OperationWithTimeAndProffs
    {
        public OperationWithTimeAndProffs(int ktop, int kob, decimal time, int category, int codeProff, int rel)
        {
            KTOP = ktop;
            KOB = kob;
            Time = time;
            Category = category;
            CodeProff = codeProff;
            REL = rel;
        }
        public int KTOP { get; }
        public int KOB { get; }
        public decimal Time { get; }
        public int Category { get; }
        public int CodeProff { get; }
        public int REL { get; }
    }
}
