using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;

namespace DashboardX.pages
{
    public partial class Grid : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        public void MainGrid_NeedData(object sender, EventArgs e)
        {
            DataSet ds = Excel.GetDataSetFromFile(Server.MapPath("etc/sampledata.xls"));
            (sender as RadGrid).DataSource = ds;
        }
    }
}