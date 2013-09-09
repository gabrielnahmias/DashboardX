<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Grid.ascx.cs" Inherits="DashboardX.pages.Grid" %>

<asp:SqlDataSource ID="SqlDataSource_Grid" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>">
</asp:SqlDataSource>

<script type="text/javascript">
    DBX.events.gridResize = function (e) {
        var seen = [],
            temp_e = JSON.stringify(e, function (key, val) {
                if (typeof val == "object") {
                    if (seen.indexOf(val) >= 0)
                        return;
                    seen.push(val);
                }
                return val;
            }),
            scrollArea = document.getElementById(e.ClientID + "_GridData"),
            iPadding = 280,
            iWinHeight = window.innerHeight;

        if (iWinHeight <= 500)
            iWinHeight = 500;

        scrollArea.style.height = (iWinHeight - iPadding) + "px";

        localStorage.setItem('e', temp_e);
    }
    $(window).resize(function () {
        var oGridData;
        if (typeof localStorage !== 'undefined')
            oGridData = JSON.parse(localStorage.getItem('e'));
        else
            oGridData = {};
        DBX.events.gridResize(oGridData);
    });
    $(function () {
        // Add title to download button with chosen format included. This changes whenever
        // a new format is chosen.
        var $btn = $("#download_file > .button"),
        $select = $("#download_file > select"),
        sFormat = $select.find(":selected").text();
        $btn.attr("title", "Download " + sFormat + " file of the grid");
        $select.change(function () {
            sFormat = $(this).find(":selected").text();
            $btn.attr("title", "Download " + sFormat + " file of the grid");
        });
    });
</script>

<asp:HiddenField runat="server" ID="contentHolder" />

<div id="toolbar">
    <div id="download_file">
        <asp:DropDownList ID="DropDownList1" runat="server">
            <asp:ListItem Text="CSV" Value="csv" Selected="true"></asp:ListItem>
	        <asp:ListItem Text="DOC" Value="doc"></asp:ListItem>
            <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
	        <asp:ListItem Text="XLS (HTML)" Value="xls"></asp:ListItem>
	        <asp:ListItem Text="XLS (BIFF)" Value="xls2"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="Button1" runat="server" CssClass="strong caps button" Text="Download" OnClick="Export" />
    </div>
</div>

<telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <telerik:RadAjaxPanel EnableAJAX="true" runat="server">
        <telerik:RadGrid BorderColor="White" id="RadGrid1" runat="server" DataSourceID="SqlDataSource_Grid"
         AllowPaging="True" AllowSorting="True" PageSize="50">
            <ClientSettings>
                <Resizing AllowColumnResize="true" AllowRowResize="true" />
                <Scrolling AllowScroll="true" ScrollHeight="600px" UseStaticHeaders="true" />
                <ClientEvents OnGridCreated="DBX.events.gridResize" />
            </ClientSettings>
            <ExportSettings FileName="grid"></ExportSettings>
            <MasterTableView AllowMultiColumnSorting="true" EditMode="InPlace">
                <CommandItemSettings ShowExportToWordButton="true" ShowExportToExcelButton="true"
                 ShowExportToCsvButton="true" ShowExportToPdfButton="true" />
            </MasterTableView>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
</telerik:RadCodeBlock>