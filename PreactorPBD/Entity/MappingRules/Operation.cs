namespace PreactorPBD
{
    internal readonly struct Operation
    {
        public Operation(int ktop, int kob)
        {
            KTOP = ktop;
            KOB = kob;
        }
        public int KTOP { get; }
        public int KOB { get; }

        public static bool operator ==(Operation operFirst, Operation operSecond)
        {
            if (operFirst.KTOP == operSecond.KTOP && operFirst.KOB == operSecond.KOB)
            {
                return true;
            }

            return false;
        }

        public static bool operator !=(Operation operFirst, Operation operSecond)
        {
            return !(operFirst == operSecond);
        }

        public override bool Equals(object obj)
        {
            if (obj is Operation operation)
            {
                return this.KTOP == operation.KTOP && this.KOB == operation.KOB;
            }
            return false;
        }

        public override int GetHashCode()
        {
            return int.Parse(KTOP.ToString() + KOB.ToString());
        }
    }
}
