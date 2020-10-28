using System;
using System.Collections.Generic;
using System.Text;

namespace BelwestDb
{
    internal class Order
    {
        public int OrderCode { get; set; }
        public string ArticleCode { get; set; }
        public string ArticleName { get; set; }
        public string ArticleVersion { get; set; }
        public int CountOnOrder { get; set; }
        public DateTime DateStart { get; set; }
        public DateTime DateEnd { get; set; }
        public int Priority { get; set; }
    }
}
