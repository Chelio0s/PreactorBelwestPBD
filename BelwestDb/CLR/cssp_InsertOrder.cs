using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using BelwestDb;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static int cssp_InsertOrder (string art)
    {
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            sqlConnection.Open();
            List<Order> articleOrders = GetArticle(art, sqlConnection);
            for (int i = 0; i < articleOrders.Count; i++) //проходимся по заказам на артикул
            {
                articleOrders[i].OrderCode = InsertOrder(articleOrders[i], sqlConnection);
                List<double> sizes = GetSizes(art, sqlConnection);
                for (int j = 0; j < sizes.Count; j++)
                {
                    Order nomenclatureOrder = GetNomenclature(art, sizes[j], sqlConnection);
                    nomenclatureOrder.OrderCode = InsertOrder(nomenclatureOrder, sqlConnection);
                    CreateRelation(articleOrders[i], nomenclatureOrder, sqlConnection);
                    List<OrderWithSp> simpleProductArticle = GetSimpleProducts(art, sizes[j], sqlConnection);
                    for (int k = 0; k < simpleProductArticle.Count; k++)
                    {
                        simpleProductArticle[k].OrderCode = InsertOrder(simpleProductArticle[k], sqlConnection);
                    }
                    FillRelationForSimpleProduct(simpleProductArticle, nomenclatureOrder, sqlConnection);
                    //выбрать ПФ, написать ф-цию в которую передам ПФ и номенклатуру, создать иерархию связей, добавить их) 
                }
            }
        }
        return 0;
    }

    private static void FillRelationForSimpleProduct(List<OrderWithSp> simpleProduct, Order nomeclature, SqlConnection sqlConnection)
    {
        List<EntrySimpleProduct> entrySimpleProducts = GetEntrySimpleProducts(sqlConnection);
        foreach (var sp in simpleProduct)
        {
            EntrySimpleProduct esp = entrySimpleProducts.Find(x => x.ChildSimpleProduct == sp.Sp);
            Order parentOrder = esp == null ? nomeclature : simpleProduct.Find(x => x.Sp == esp.ParentSimpleProduct);
            CreateRelation(parentOrder, sp, sqlConnection);
        }
    }
    /// <summary>
    /// Возращает связи полуфабрикатов
    /// </summary>
    /// <param name="sqlConnection"></param>
    /// <returns></returns>
    private static List<EntrySimpleProduct> GetEntrySimpleProducts(SqlConnection sqlConnection)
    {
        List<EntrySimpleProduct> entrySimpleProducts = new List<EntrySimpleProduct>();
        SqlCommand command = new SqlCommand(@" SELECT  [SimpleProductId]
                                                   ,[SimpleProductIdChild]
                                                   FROM [PreactorSDB].[SupportData].[EntrySimpleProduct] ", sqlConnection);
        var reader = command.ExecuteReader();
        while (reader.Read())
        {
            EntrySimpleProduct sp = new EntrySimpleProduct
            {
                ParentSimpleProduct = reader[0].ToString(),
                ChildSimpleProduct = reader[1].ToString()
            };
            entrySimpleProducts.Add(sp);
        }
        reader.Close();
        return entrySimpleProducts;
    }
    private static int InsertOrder(Order order, SqlConnection sqlConnection)
    {
        SqlCommand command = new SqlCommand("INSERT INTO [dbo].[ORDERS]" +
            "([Codeartic]" +
            ",[LIBARTIC]" +
            ",[VER_ART]" +
            ",[QTE]" +
            ",[DateStart]" +
            ",[DateEnd]" +
            ",[Priority])" +
            "VALUES (" +
            $"'{order.ArticleCode}'" +
            $",'{order.ArticleName}'" +
            $",'{order.ArticleVersion}'" +
            $",{order.CountOnOrder}" +
            $",'{order.DateStart}'" +
            $",'{order.DateEnd}'" +
            $",{order.Priority})", sqlConnection);
        command.ExecuteNonQuery();
        command = new SqlCommand("SELECT MAX(NOF) FROM [dbo].[ORDERS]", sqlConnection);
        return (int)command.ExecuteScalar();
    }
    private static List<double> GetSizes(string art, SqlConnection sqlConnection)
    {
        SqlCommand command = new SqlCommand(@"SELECT DISTINCT Size FROM
                                                [PreactorSDB].[InputData].[Article] AS art 
                                                INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.ArticleId = art.IdArticle
                                                WHERE art.Title = '" + art + "'", sqlConnection);
        var reader = command.ExecuteReader();
        List<double> sizes = new List<double>();
        while (reader.Read())
        {
            sizes.Add(Convert.ToDouble(reader[0]));
        }
        reader.Close();
        return sizes;
    }
    private static void CreateRelation(Order parent, Order child, SqlConnection sqlConnection)
    {
        SqlCommand command = new SqlCommand("INSERT INTO [dbo].[LINKS]" +
                                            "(B_P_NOF" +
                                            ",B_P_CODEATIC" +
                                            ",B_P_LIBARTIC" +
                                            ",NOF" +
                                            ",CODEARTIC" +
                                            ",LIBARTIC" +
                                            ") VALUES (" +
                                            $" {parent.OrderCode}" +
                                            $",'{parent.ArticleCode}'" +
                                            $",'{parent.ArticleName}'" +
                                            $",{child.OrderCode}" +
                                            $",'{child.ArticleCode}'" +
                                            $",'{child.ArticleName}')", sqlConnection);
        command.ExecuteNonQuery();
    }
    private static List<Order> GetArticle(string art, SqlConnection sqlConnection)
    {
        SqlCommand command = new SqlCommand(@"SELECT art.Title AS ArticleCode, 
                                                art.Title AS ArticleName, 
                                                '00' AS ArticleVersion, 
                                                p.Count AS CountOnOrder, 
                                                CAST('2020/10/01 00:00:00'AS datetime)  AS DateStart,
                                                CAST('2020/12/01 00:00:00' AS datetime) AS DateEnd,
                                                10 AS Priority
                                                FROM [PreactorSDB].[InputData].[Plan] AS p
                                                INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = p.ArticleId
                                                WHERE art.Title = '" + art + "'", sqlConnection);
        var reader = command.ExecuteReader();
        List<Order> orders = new List<Order>();
        while (reader.Read())
        {
            Order order = new Order
            {
                ArticleCode = reader[0].ToString(),
                ArticleName = reader[1].ToString(),
                ArticleVersion = reader[2].ToString(),
                CountOnOrder = Convert.ToInt32(reader[3]),
                DateStart = Convert.ToDateTime(reader[4]),
                DateEnd = Convert.ToDateTime(reader[5]),
                Priority = Convert.ToInt32(reader[6])
            };
            orders.Add(order);
        }
        reader.Close();
        return orders;
    }
    private static Order GetNomenclature(string art, double size, SqlConnection sqlConnection)
    {
        SqlCommand command = new SqlCommand(@"SELECT DISTINCT nom.Number_ AS ArticleCode, 
                                            nom.Number_ AS ArticleName, 
                                            '00' AS ArticleVersion, 
                                             [Count] * (CountPersent / 100) AS CountOnOrder, 
                                            CAST('2020/10/01 00:00:00'AS datetime)  AS DateStart,
                                            CAST('2020/12/01 00:00:00' AS datetime) AS DateEnd,
                                            10 AS Priority
                                            FROM [PreactorSDB].[InputData].[Plan] AS p
                                            INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = p.ArticleId
                                            INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.ArticleId = art.IdArticle
                                            WHERE art.Title = '" + art + "' AND nom.Size = " + size, sqlConnection);
        var reader = command.ExecuteReader();
        Order order = new Order();
        while (reader.Read())
        {
            order = new Order
            {
                ArticleCode = reader[0].ToString().Replace(' ', '_'),
                ArticleName = reader[1].ToString(),
                ArticleVersion = reader[2].ToString(),
                CountOnOrder = Convert.ToInt32(reader[3]),
                DateStart = Convert.ToDateTime(reader[4]),
                DateEnd = Convert.ToDateTime(reader[5]),
                Priority = Convert.ToInt32(reader[6])
            };
        }
        reader.Close();
        return order;
    }
    private static List<OrderWithSp> GetSimpleProducts(string art, double size, SqlConnection sqlConnection)
    {
        List<OrderWithSp> orders = new List<OrderWithSp>();
        SqlCommand command = new SqlCommand(@" SELECT DISTINCT  nom.Number_ +'_'+ Cast(sp.SimpleProductId AS varchar(20))  AS ArticleCode, 
                                                    sp.Title AS ArticleName, 
                                                    '00' AS ArticleVersion, 
                                                    p.[Count] * (CountPersent / 100) AS CountOnOrder, 
                                                    CAST('2020/10/01 00:00:00'AS datetime)  AS DateStart,
                                                    CAST('2020/12/01 00:00:00' AS datetime) AS DateEnd,
                                                    10 AS Priority,
                                                    sp.SimpleProductId
                                                    FROM [PreactorSDB].[InputData].[Plan] AS p
                                                    INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = p.ArticleId
                                                    INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.ArticleId = art.IdArticle
                                                    INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.NomenclatureID = nom.IdNomenclature
                                                    WHERE art.Title = '" + art + "' " +
                                                "AND sp.SimpleProductId > 0 " +
                                                "AND nom.Size = " + size, sqlConnection);
        var reader = command.ExecuteReader();
        while (reader.Read())
        {
            OrderWithSp order = new OrderWithSp
            {
                ArticleCode = reader[0].ToString().Replace(' ', '_'),
                ArticleName = reader[1].ToString(),
                ArticleVersion = reader[2].ToString(),
                CountOnOrder = Convert.ToInt32(reader[3]),
                DateStart = Convert.ToDateTime(reader[4]),
                DateEnd = Convert.ToDateTime(reader[5]),
                Priority = Convert.ToInt32(reader[6]),
                Sp = reader[7].ToString()
            };
            orders.Add(order);
        }
        reader.Close();
        return orders;
    }
}
