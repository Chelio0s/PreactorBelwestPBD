using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;
using PreactorSDB;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillCombineCombines", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = "IDRoutRule int " +
                          ",IdCombine int"+
                          ",IsParent bit")]
    public static IEnumerable ctvf_CombineCombines(int IdSemiProduct)
    {
        var resultList = new List<CombineItemResult>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            SqlCommand command = new SqlCommand($"SELECT * FROM [InputData].[ctvf_CombineRules] " +
                                                     $"({IdSemiProduct})", sqlConnection);
            sqlConnection.Open();
            var reader = command.ExecuteReader();
            List<CombineResult> list = new List<CombineResult>();
            while (reader.Read())
            {
                list.Add(new CombineResult(
                    Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[0]),
                    Convert.ToInt32(reader[2])));
            }
     
            //Группируем все по группам и помещаем в спец. листы

            var groups = list.GroupBy(x => x.GroupId);

            List<List<CombineData<CombineItem>>> dataList = new List<List<CombineData<CombineItem>>>();
            foreach (var gr in groups)
            {
                var combineDatas = new List<CombineData<CombineItem>>();

                foreach (var d2 in gr)
                {
                    var cd = new CombineData<CombineItem>();
                    cd.Data.Add(new CombineItem()
                    {
                        IdRoutRule = d2.IdRule,
                        IsParent = false,
                        IdCombine = d2.IdCombine
                    });
                    combineDatas.Add(cd);
                    cd = new CombineData<CombineItem>();
                    cd.Data.Add(new CombineItem()
                    {
                        IdRoutRule = d2.IdRule,
                        IsParent = true,
                        IdCombine = d2.IdCombine
                    });
                    combineDatas.Add(cd);

                }

                dataList.Add(combineDatas);

            }

            if (dataList.Count == 0)
            {
                return null;
            }

            List<CombineData<CombineItem>> finalCombine;

            if (dataList.Count > 1)
            {
                List<CombineData<CombineItem>> tempCombine = null;
                for (int i = 0; i < dataList.Count; i++)
                {
                    if (i < dataList.Count - 1)
                    {
                        tempCombine = i == 0
                            ? dataList[i].Combine(dataList[i + 1]).ToList()
                            : tempCombine.Combine(dataList[i + 1]).ToList();
                    }
                }

                finalCombine = tempCombine;
            }
            else finalCombine = dataList[0];

            int counter = 0;
            foreach (var f in finalCombine)
            {
                counter++;
                foreach (var data in f.Data)
                {

                    resultList.Add(new CombineItemResult()
                    {
                        IdCombine = counter,
                        IdRule = data.IdRoutRule,
                        IsParent = data.IsParent
                    });
                }
            }


            return resultList;
        }
    }


    public static void FillCombineCombines(object obj, out SqlInt32 IdRule, out SqlInt32 IdCombine, out SqlBoolean IsParent)
    {
        var resObj = obj as CombineItemResult;
        IdRule = resObj.IdRule;
        IdCombine = resObj.IdCombine;
        IsParent = resObj.IsParent;
    }
}
