using System.Collections.Generic;

namespace PreactorPBD
{
    /// <summary>
    /// Метод комбинирования двух послеовательностей закрытых типом CombineData<T>
    /// </summary>
    static class CombineExtension
    {
        public static IEnumerable<CombineData<T>> Combine<T>(this IEnumerable<CombineData<T>> firstSeq, 
            IEnumerable<CombineData<T>> secondSeq)
        {
            var res = new List<CombineData<T>>();
            foreach (var f in firstSeq)
            {
                foreach (var s in secondSeq)
                {
                    var r = CombineData<T>.GetCombine(f, s);
                    res.Add(r);
                }
            }
            return res;
        }
    }
}

