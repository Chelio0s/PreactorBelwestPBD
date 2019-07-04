using System;
using System.Collections.Generic;
using System.Text;

namespace PreactorPBD
{
    class RoutRulesOperation
    {
        public RoutRulesOperation()
        {
            ParentOperations = new List<int>();
            ChildOperations = new List<int>();
        }
        public int IdRout { get; set; }
        public int SemiProductId { get; set; }
        public int RuleId { get; set; }
        public bool RuleIsParent { get; set; }
        public List<int> ParentOperations { get; set; }
        public List<int> ChildOperations { get; set; }
    }
}
