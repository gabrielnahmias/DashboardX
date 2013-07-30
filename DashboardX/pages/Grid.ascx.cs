using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
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

        public void Export(object sender, EventArgs e)
        {
            string sFormat = DropDownList1.SelectedValue;
            
            if (sFormat.Equals("csv"))
            {
                RadGrid1.MasterTableView.ExportToCSV();
            }
            else if (sFormat.Equals("doc"))
            {
                RadGrid1.MasterTableView.ExportToWord();
            }
            else if (sFormat.Equals("pdf"))
            {
                RadGrid1.MasterTableView.ExportToPdf();
            }
            else if (sFormat.Equals("xls"))
            {
                RadGrid1.MasterTableView.ExportToExcel();
            }
            else if (sFormat.Equals("xls2"))
            {
                RadGrid1.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Biff;
                RadGrid1.MasterTableView.ExportToExcel();
            }
        }

        protected void RadGrid1_PreRender(object sender, EventArgs e)
        {
            foreach (GridColumn col in RadGrid1.MasterTableView.RenderColumns)
            {
                foreach (GridHeaderItem header in RadGrid1.MasterTableView.GetItems(GridItemType.Header))
                {
                    header[col.UniqueName].Attributes.Add("OnClick", "return SortColumn('" + col.UniqueName + "');");
                }
            }
        } 
    }
}