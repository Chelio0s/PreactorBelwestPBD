using System;
using System.Collections.Generic;
using System.Text;

namespace PreactorPBD
{
    readonly struct OperationData
    {
        public OperationData(int idSemiProduct, int ktop, int poneob, decimal normatime, int kob,
            int simpleProduct)
        {
            this.IdSemiProduct = idSemiProduct;
            this.PONEOB = poneob;
            this.NORMATIME = normatime;
            this.SimpleProduct = simpleProduct;
            this.Operation = new Operation(ktop, kob);
        }

        public int IdSemiProduct { get; }

        public int PONEOB { get; }
        public decimal NORMATIME { get; }

        public int SimpleProduct { get; }

        public Operation Operation { get; }

    }
}
