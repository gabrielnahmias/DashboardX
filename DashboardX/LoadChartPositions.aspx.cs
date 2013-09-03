using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DashboardX
{
    public partial class LoadChartPositions : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            Response.AddHeader("Content-type", "text/json");
            Response.AddHeader("Content-type", "application/json");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int i = 1;

            string sql = "select Type, Position from dbx.dbo.ChartPositions group by Position, Type";

            SqlHandler conn = new SqlHandler();

            //Response.Write(String.Format("SQL Query: {0}\n", sql));

            //Response.Write("Result:\n");
            
            // Load chart positions.
            conn.GetResult(sql);

            Response.Write("{");

            foreach (object[] o in conn.Result)
            {
                string sKey = o[0].ToString();
                int iPlace = int.Parse(o[1].ToString());
                Response.Write(String.Format("\"{0}\": {1}{2}", sKey, iPlace, ((i < conn.Result.Count) ? "," : "") ));
                i++;
            }

            Response.Write("}");
        }
    }
}