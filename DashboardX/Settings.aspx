<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="DashboardX.InitChart" %>

<%@ Import Namespace="System.Diagnostics" %>

<asp:SqlDataSource ID="SqlDataSource_AllStoresTotalSales" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    SelectCommand="with T as ( select (row_number() over (order by LocationID)) as RowNo, LocationID, sum(TransAmount) as TotalSales, DBAName from dbx.dbo.SampleData group by LocationID, DBAName ) select * from ( select LocationID, TotalSales, DBAName, case when RowNo=1 then 'Red' when RowNo=2 then 'Orange' when RowNo=3 then 'Yellow' when RowNo=4 then 'Green' when RowNo=5 then 'Blue' end as Color from T ) x group by LocationID, TotalSales, DBAName, Color">
</asp:SqlDataSource>

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
        margin: 5px;
        overflow: hidden;
        text-align: center;
        width: 100%;
    }
    label {
        margin-right: 10px;
    }
    .save {
        bottom: 0;
        left: 50%;
        position: absolute;
    }
    </style>
</head>
<body>
    <form id="settings_window" runat="server">
	    <telerik:RadScriptManager id="RadScriptManager" runat="server">
		    <Scripts>
			    <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
		    </Scripts>
	    </telerik:RadScriptManager>
	    <telerik:RadAjaxManager id="RadAjaxManager" runat="server">
	    </telerik:RadAjaxManager>
        <script type="text/javascript">
            /*DBX.events.xxx = function (sender, args) {
            }*/
        </script>
        <div id="wrapper">
            <label for="source">Data Source:</label>
            <select id="source">
                <option>Taco Bell</option>
                <option>Dodge's</option>
            </select>
            <input class="strong spaced caps save button" type="submit" value="Save" />
        </div>
    </form>
</body>
</html>
