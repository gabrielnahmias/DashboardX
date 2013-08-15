using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;

namespace DashboardX.pages
{
    public partial class Charts : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            HttpContext c = HttpContext.Current;
            string sql = "",
                   sLID = null;

            if (c.Request["lid"] != null)
                sLID = c.Request["lid"].ToString();

            // If a store is specified, use it in the query (LocationID), otherwise use default query.
            if (sLID != null)
                sql = String.Format("with T as (select (row_number() over (order by SubmitDate)) as RowNo, sum(TransAmount) as TotalSales, SubmitDate, Color from dbx.dbo.SampleData where LocationID={0} group by Color, SubmitDate ) select * from ( select SubmitDate, TotalSales, case when RowNo=1 or RowNo=6 or RowNo=11 then 'Red' when RowNo=2 or RowNo=7 or RowNo=12 then 'Orange' when RowNo=3 or RowNo=8 or RowNo=13 then 'Yellow' when RowNo=4 or RowNo=9 or RowNo=14 then 'Green' when RowNo=5 or RowNo=10 or RowNo=15 then 'Blue' end as Color from T ) x group by SubmitDate, Color, TotalSales", sLID);
            else
                sql = "select sum(TransAmount) as TotalSales, Color, SubmitDate from dbx.dbo.SampleData group by Color, SubmitDate";

            // Assign to proper SelectCommand.
            SqlDataSource_TotalSales.SelectCommand = sql;
            
            DataBind();
        }

        public void DownloadColumnChart(object sender, EventArgs e)
        {
            DownloadImage(sender, e, RadHtmlChart1, DropDownList1);
        }

        public void DownloadPieChart(object sender, EventArgs e)
        {
            DownloadImage(sender, e, RadHtmlChart2, DropDownList2);
        }

        public void DownloadBarChart(object sender, EventArgs e)
        {
            DownloadImage(sender, e, RadHtmlChart3, DropDownList3);
        }

        public void DownloadLineChart(object sender, EventArgs e)
        {
            DownloadImage(sender, e, RadHtmlChart4, DropDownList4);
        }

        /// <summary>
        /// Downloads an image of the given RadHtmlChart (with the given dropdown
        /// providing the format specification [PNG/PDF]) by launching Inkscape and
        /// passing some command line arguments.
        /// </summary>
        /// <param name="sender">Who ran this function?</param>
        /// <param name="e">Event data.</param>
        /// <param name="chart">The chart of which to generate an image.</param>
        /// <param name="ddl">The dropdown list with the format desired selected (PNG/PDF).</param>
        public void DownloadImage(object sender, EventArgs e, RadHtmlChart chart, DropDownList ddl)
        {
            //obtain the necessary settings for exporting the chart
            HtmlChartExportSettings currentSettings = new HtmlChartExportSettings();

            if (chart.Height != null && chart.Width != null)
            {
                currentSettings.Height = (int)chart.Height.Value;
                currentSettings.Width = (int)chart.Width.Value;
            }

            //decodes the SVG string saved from the client
            string svgText = HttpUtility.UrlDecode(svgHolder.Value);

            //create a temporary SVG file that Inkscape will use
            currentSettings.SvgFilePath = Server.MapPath("~/App_Data/temp.svg");
            System.IO.File.WriteAllText(currentSettings.SvgFilePath, svgText);

            //get the export format - png or pdf
            currentSettings.Extension = ddl.SelectedValue;

            //the output file Inkscape will use, hardcoded to use App_Data as a temporary folder
            currentSettings.OutputFilePath = (@"C:\chart." + currentSettings.Extension);

            //you can change the name of the file the user will receive here. Extension is automatically added
            currentSettings.ClientFileName = "chart";

            //the actual file is created
            HtmlChartExporter.ExportHtmlChart(currentSettings);

            //read the exported file and send it to the client
            byte[] fileForClient = HtmlChartExporter.ReadFile(currentSettings.OutputFilePath);
            Response.ContentType = HtmlChartExportSettings.ContentTypeList[currentSettings.Extension];
            Response.AddHeader("Content-Disposition", "attachment;filename=" + currentSettings.ClientFileName);
            Response.BinaryWrite(fileForClient);

            //delete the temporary files to avoid flooding the server
            File.Delete(currentSettings.OutputFilePath);
            File.Delete(currentSettings.SvgFilePath);

            svgHolder.Value = "";
        }
    }
}