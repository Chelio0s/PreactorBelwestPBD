using System.Collections.Generic;
using System.Linq;

namespace PreactorPBD
{
    /// <summary>
    /// Тип для хранения комбинированных данных
    /// </summary>
    /// <typeparam name="T"></typeparam>
    class CombineData<T>
    {
        public CombineData()
        {
            Data = new List<T>();
        }
        public List<T> Data { get; set; }

        public static CombineData<T> GetCombine(CombineData<T> combineDataFirst,
            CombineData<T> combineDataSecond)
        {
            var c = new CombineData<T>();
            foreach (var sec in combineDataSecond.Data)
            {
                var secondList = combineDataFirst.Data.ToList();
                secondList.Add(sec);
                c.Data = secondList;
            }
            return c;
        }
    }
}
