using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

public class Globals
{
    public class Dirs
    {
        public static string Assets = "assets",
                                CSS = Assets + "/css",
                                Images = Assets + "/img",
                                Icons = Images + "/icons",
                                JS = Assets + "/js";
    }
    public static string GridName = "RadGrid1";
    // In case the SQL connection is lost, use this for a data source
    // TODO: Set up local SQL Server.
    //public static DataSet Data = Excel.GetDataSetFromFile(@"C:\Projects\Dashboard\DashboardX\etc\sampledata.xls");
}