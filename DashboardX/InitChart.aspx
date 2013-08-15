<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InitChart.aspx.cs" Inherits="DashboardX.InitChart" %>

<%@ Import Namespace="System.Diagnostics" %>

<asp:SqlDataSource ID="SqlDataSource_AllStoresTotalSales" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    SelectCommand="with T as ( select (row_number() over (order by LocationID)) as RowNo, LocationID, sum(TransAmount) as TotalSales, DBAName from dbx.dbo.SampleData group by LocationID, DBAName ) select * from ( select LocationID, TotalSales, DBAName, case when RowNo=1 then 'Red' when RowNo=2 then 'Orange' when RowNo=3 then 'Yellow' when RowNo=4 then 'Green' when RowNo=5 then 'Blue' end as Color from T ) x group by LocationID, TotalSales, DBAName, Color">
</asp:SqlDataSource>

<%-- select LocationID, sum(TransAmount) as TotalSales, Color, DBAName from dbx.dbo.SampleData group by LocationID, Color, DBAName --%>

<%
   
%>

<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%=WebHelper.AddResource("styles.css", false, Globals.Dirs.CSS)%>
    <!-- Console.js -->
    <%=WebHelper.AddResource("Console.min.js", true, "Console")%>
    <!-- jQuery -->
    <%=WebHelper.AddResource("jquery-1.10.2.min.js")%>
    <!-- Proprietary -->
    <%=WebHelper.AddResource("scripts.js")%>
    <style type="text/css">
    body {
        overflow: hidden;
    }
    path {
        cursor: pointer;
    }
    text {
        font-weight: bold !important;
    }
    .k-chart {
        left: 50%;
        margin-left: -350px;
        margin-top: -200px;
        position: absolute;
        top: 50%;
        width: 700px;
    }
    </style>
</head>
<body>
    <form id="init_chart" runat="server">
	    <telerik:RadScriptManager id="RadScriptManager" runat="server">
		    <Scripts>
			    <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
		    </Scripts>
	    </telerik:RadScriptManager>
	    <telerik:RadAjaxManager id="RadAjaxManager" runat="server">
	    </telerik:RadAjaxManager>
        <script type="text/javascript">
            DBX.events.seriesClicked = function (sender, args) {
                //Console.debug(sender, args);
                var oData = args.get_dataItem(),
                    iLID = oData.LocationID;
                
                Console.debug(oData);
                
                top.location.href = "Default.aspx?lid={0}".format(iLID);
            }
        </script>
        <div id="wrapper">
            <telerik:RadHtmlChart ClientIDMode="Static" ID="RadHtmlChart_Init" runat="server"
                Transitions="true" DataSourceID="SqlDataSource_AllStoresTotalSales" OnClientSeriesClicked="DBX.events.seriesClicked">
                <PlotArea>
                    <Series>
                        <telerik:PieSeries ColorField="Color" DataFieldY="TotalSales" StartAngle="90">
                            <LabelsAppearance ClientTemplate="#=dataItem.DBAName#" Position="Circle">
                            </LabelsAppearance>
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:PieSeries>
                    </Series>
                </PlotArea>
                <Legend>
                    <Appearance Visible="false">
                    </Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </form>
</body>
</html>
