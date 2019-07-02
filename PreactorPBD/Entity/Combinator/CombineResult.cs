
namespace PreactorSDB
{
    public readonly struct CombineResult
    {
        public CombineResult(int idCombine, int idRule, int groupId)
        {
            IdCombine = idCombine;
            IdRule = idRule;
            GroupId = groupId;
        }
        public int IdCombine { get;  }
        public int IdRule { get;  }
        public  int GroupId { get;  }
    }
}
