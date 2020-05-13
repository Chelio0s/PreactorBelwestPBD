using System;
using System.Collections.Generic;
using System.Text;

namespace PreactorPBD
{
    readonly struct FilteredRoutRule
    {
        public FilteredRoutRule(int groupId, int ruleId, int parentKtop, int childKtop, int priority)
        {
            GroupId = groupId;
            RuleId = ruleId;
            ParentKTOP = parentKtop;
            ChildKTOP = childKtop;
            Priority = priority;
        }
        public int GroupId { get; }
        public int RuleId { get; }
        public int ParentKTOP { get; }
        public int ChildKTOP { get; }
        public int Priority { get; }
    } 
}
