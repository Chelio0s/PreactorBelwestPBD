

namespace PreactorPBD
{
    public enum OracleDataBase
    {
        SAP = 1,
        MPU = 2
    }

    public static class OracleSettings
    {
        public static string Host { get; private set; }
        public static int Port { get; private set; }
        public static string Sid { get; private set; }
        public static string User { get; private set; }
        public static string Password { get; private set; }

        static OracleSettings()
        {
           
        }

        public static string GetConnectionString(OracleDataBase dataBase)
        {
            switch (dataBase)
            {
                case OracleDataBase.SAP:
                {
                    Host = "176.60.208.2";
                    Port = 1521;
                    Sid = "ORCL";
                    User = "GUI_SAP";
                    Password = "_Gui_sap";
                    } break;
                case OracleDataBase.MPU:
                {
                    Host = "prod.vit.belwest.com";
                    Port = 1521;
                    Sid = "orcl.Belw-MPUDB";
                    User = "SergeyTrofimov";
                    Password = "jC7EGzQ1pX";
                }
                    break;
            }
            string connString = "Data Source=(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = "
                                + Host + ")(PORT = " + Port + "))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = "
                                + Sid + ")));Password=" + Password + ";User ID=" + User;
            return connString;
        }
    }
}
