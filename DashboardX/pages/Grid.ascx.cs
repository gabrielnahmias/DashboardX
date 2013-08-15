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
            HttpContext c = HttpContext.Current;
            string sql = "",
                   sLID = null;

            if (c.Request["lid"] != null)
                sLID = c.Request["lid"].ToString();

            // If a store is specified, use it in the query (LocationID), otherwise use default query.
            sql = String.Format("select [LocationID], [ExternalMerchantNumber], [DBAName], [CurrencyCode], [Description], [SubmitDate], [TransCount], [TransAmount], [InterchangeExpense], [Rate] from [dbx].[dbo].[SampleData]{0}", ((sLID != null) ? String.Format(" where LocationID={0}", sLID) : ""));

            // Assign to proper SelectCommand.
            SqlDataSource_Grid.SelectCommand = sql;

            DataBind();
        }

        public void Export(object sender, EventArgs e)
        {
            string sFormat = DropDownList1.SelectedValue.ToLower();

            switch (sFormat)
            {
                case "csv":
                    RadGrid1.MasterTableView.ExportToCSV();
                    break;
                case "doc":
                    RadGrid1.MasterTableView.ExportToWord();
                    break;
                case "pdf":
                    RadGrid1.MasterTableView.ExportToPdf();
                    break;
                case "xls":
                    RadGrid1.MasterTableView.ExportToExcel();
                    break;
                case "xls2":
                    RadGrid1.ExportSettings.Excel.Format = Telerik.Web.UI.GridExcelExportFormat.Biff;
                    RadGrid1.MasterTableView.ExportToExcel();
                    break;
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