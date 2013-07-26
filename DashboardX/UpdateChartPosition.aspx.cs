using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DashboardX
{
    public partial class UpdateChartPosition : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Chart cp = new Chart();
            HttpContext c = HttpContext.Current;
            JavaScriptSerializer js = new JavaScriptSerializer();
            SqlComm conn = new SqlComm();

            if (c.Request["change"] != null)
                cp = js.Deserialize<Chart>(c.Request["change"]);

            string sql = String.Format("declare @oldchartname varchar(50), @movedchartoldpos int;" +
                                       "set @oldchartname = (select Type from dbx.dbo.ChartPositions where Position={0});" +
                                       "set @movedchartoldpos = (select Position from dbx.dbo.ChartPositions where Type='{1}');" +
                                       "update dbx.dbo.ChartPositions set Position={0} where Type='{1}';" +
                                       "update dbx.dbo.ChartPositions set Position=@movedchartoldpos where Type=@oldchartname;", cp.Position, cp.Type);

            // Switch chart positions.
            conn.Execute(sql);

            Response.Write(cp.Type[0].ToString().ToUpper() + cp.Type.Substring(1) + " chart has been changed to position " + cp.Position + ".");
            Response.Write("\nSQL Query: " + sql);
        }
    }
}