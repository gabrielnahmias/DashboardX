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
            HttpContext c = HttpContext.Current;
            JavaScriptSerializer js = new JavaScriptSerializer();
            Chart cp = new Chart();

            if (c.Request["change"] != null)
                cp = js.Deserialize<Chart>(c.Request["change"]);
            
            Response.Write(cp.Type[0].ToString().ToUpper() + cp.Type.Substring(1) + " chart has been changed to position " + cp.Position + ".");

            SqlComm conn = new SqlComm();

            //conn.getResult("update dbx.dbo.ChartPosition set ");
        }
    }
}