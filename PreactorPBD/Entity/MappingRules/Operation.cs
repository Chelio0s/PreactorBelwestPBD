namespace PreactorPBD
{
    readonly struct Operation
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
    }

}
