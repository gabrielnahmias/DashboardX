﻿using System;
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
            string sMsg = "";
            ChartPositions cp = new ChartPositions();
            HttpContext c = HttpContext.Current;
            JavaScriptSerializer js = new JavaScriptSerializer();
            SqlComm conn = new SqlComm();

            if (c.Request["positions"] != null)
            {
                cp = js.Deserialize<ChartPositions>(c.Request["positions"]);
            }
            else
            {
                Response.Write("No positions specified.");
                return;
            }

            string sql = String.Format("update dbx.dbo.ChartPositions set Position={0} where Type='bar';" +
                                       "update dbx.dbo.ChartPositions set Position={1} where Type='column';" +
                                       "update dbx.dbo.ChartPositions set Position={2} where Type='line';" +
                                       "update dbx.dbo.ChartPositions set Position={3} where Type='pie';", cp.Bar, cp.Column, cp.Line, cp.Pie);

            sMsg = String.Format("Charts have been changed to the following positions:\n" +
                                 "  Bar: {0}\n" +
                                 "  Column: {1}\n" +
                                 "  Line: {2}\n" +
                                 "  Pie: {3}\n" +
                                 "SQL Query: {4}", cp.Bar, cp.Column, cp.Line, cp.Pie, sql);

            // Change chart positions.
            conn.Execute(sql);

            Response.Write(sMsg);
        }
    }
}