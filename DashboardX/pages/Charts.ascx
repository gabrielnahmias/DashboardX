<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Charts.ascx.cs" Inherits="DashboardX.pages.Charts" %>

<asp:SqlDataSource ID="SqlDataSource_TotalSales" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    SelectCommand="select SUM(TransAmount) as TotalSales, Color, SubmitDate from dbx.dbo.SampleData group by Color, SubmitDate">
</asp:SqlDataSource>

<%--select CAST(REPLACE(STR(SUM(TransAmount), max(LEN(convert(varchar, TransAmount)))+1, 2), SPACE(1), '0') AS varchar) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate--%>

<script type="text/javascript">
    function getSvgContent(sender, chart) {
        // Obtain an SVG version of the chart regardless of the browser.
        var chartRendering = $find("Charts_"+chart).getSVGString();
        
        $("#overlay").fadeIn();

        // Store the SVG string in a hidden field and escape it so that the value can be posted to the server.
        $get("<%=svgHolder.ClientID %>").value = escape(chartRendering);
        // Initiate the postback from the button so that its server-side handler is executed.
        __doPostBack(sender.name, "");

        setTimeout(function () {
            $("#overlay").fadeOut();
        }, 3000);
    }
    (function() {
        var $d = $(document);
        $d.ready(function () {
            // When you hover over a chart, show the download button/dropdown
            // and unless the user hovers over that specific area, hide it
            // within 3 seconds of being shown. Also, if the user's mouse leaves
            // the chart, the download area hides immediately.
            $(".chart").mouseenter(function () {
                var $this = $(this),
                    $dl = $this.find(".download-image"),
                    timeoutID = setTimeout(function() {
                        $dl.hide();
                    }, 3000);
               $dl.show().data("timeoutID", timeoutID); 
            }).mouseleave(function () {
                $(this).find(".download-image").hide();
            }).find(".download-image").mouseenter(function() {
                //alert($(this).data("timeoutID"))
                clearTimeout($(this).data("timeoutID"));
            }).mouseleave(function() {
                var timeoutID = setTimeout(function() {
                    $(this).hide();
                }, 3000);
               $(this).data("timeoutID", timeoutID);
            });

            //$("[id*=Panel]").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all");
            
            $("#charts").sortable();
        });
    })();
</script>

<asp:HiddenField runat="server" ID="svgHolder" />

<div id="charts">
    <asp:Panel ID="Panel1" runat="server" Height="405px" Width="450px">
        <div id="column" class="chart">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList1" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button1" runat="server" CssClass="small button" Text="Download Image" OnClick="DownloadColumnChart" OnClientClick="getSvgContent(this, 'RadHtmlChart1'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart1" runat="server" DataSourceID="SqlDataSource_TotalSales">
                <PlotArea>
                    <Series>
                        <telerik:ColumnSeries DataFieldY="TotalSales">
                            <LabelsAppearance DataFormatString="{0:C}" Visible="false" />
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:ColumnSeries>
                    </Series>
                    <XAxis DataLabelsField="SubmitDate" MajorTickType="Outside" Step="1" MinorTickType="None">
                        <MinorGridLines Visible="false" />
                        <MajorGridLines Visible="false" />
                        <LabelsAppearance RotationAngle="-70" DataFormatString="{0}">
                        </LabelsAppearance>
                    </XAxis>
                    <YAxis>
                        <LabelsAppearance DataFormatString="${0}">
                        </LabelsAppearance>
                    </YAxis>
                </PlotArea>
                <Legend>
                    <Appearance Visible="false">
                    </Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Height="405px" Width="450px">
        <div id="pie" class="chart">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList2" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button2" runat="server" CssClass="small button" Text="Download Image" OnClick="DownloadPieChart" OnClientClick="getSvgContent(this, 'RadHtmlChart2'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart2" runat="server"
                Transitions="true" DataSourceID="SqlDataSource_TotalSales">
                <PlotArea>
                    <Series>
                        <telerik:PieSeries ColorField="Color" DataFieldY="TotalSales" StartAngle="90">
                            <LabelsAppearance ClientTemplate="#=dataItem.SubmitDate#" Position="Circle" 
                            DataFormatString="{0:C}">
                            </LabelsAppearance>
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:PieSeries>
                    </Series>
                    <XAxis DataLabelsField="SubmitDate" Visible="true">
                    </XAxis>
                    <YAxis>
                        <LabelsAppearance DataFormatString="{0:C}">
                        </LabelsAppearance>
                    </YAxis>
                </PlotArea>
                <Legend>
                    <Appearance Visible="false">
                    </Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </asp:Panel>
    <asp:Panel ID="Panel3" runat="server" Height="405px" Width="450px">
        <div id="bar" class="chart">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList3" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button3" runat="server" CssClass="small button" Text="Download Image" OnClick="DownloadBarChart" OnClientClick="getSvgContent(this, 'RadHtmlChart3'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart3" runat="server" DataSourceID="SqlDataSource_TotalSales">
                <PlotArea>
                    <Series>
                        <telerik:BarSeries DataFieldY="TotalSales">
                            <LabelsAppearance DataFormatString="{0:C}" Visible="false" />
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:BarSeries>
                    </Series>
                    <XAxis DataLabelsField="SubmitDate" MajorTickType="None" MinorTickType="None">
                        <MinorGridLines Visible="false" />
                        <MajorGridLines Visible="false" />
                        <LabelsAppearance RotationAngle="0" DataFormatString="{0}">
                        </LabelsAppearance>
                    </XAxis>
                    <YAxis>
                        <LabelsAppearance DataFormatString="${0}">
                        </LabelsAppearance>
                    </YAxis>
                </PlotArea>
                <Legend>
                    <Appearance Visible="false">
                    </Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </asp:Panel>
    <asp:Panel ID="Panel4" runat="server" Height="405px" Width="450px">
        <div id="line" class="chart">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList4" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button4" runat="server" CssClass="small button" Text="Download Image" OnClick="DownloadLineChart" OnClientClick="getSvgContent(this, 'RadHtmlChart4'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart4" runat="server" DataSourceID="SqlDataSource_TotalSales">
                <PlotArea>
                    <Series>
                        <telerik:LineSeries DataFieldY="TotalSales">
                            <LabelsAppearance DataFormatString="{0:C}" Visible="false" />
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:LineSeries>
                    </Series>
                    <XAxis DataLabelsField="SubmitDate" MajorTickType="Outside" MinorTickType="None">
                        <MinorGridLines Visible="false" />
                        <MajorGridLines Visible="false" />
                        <LabelsAppearance RotationAngle="-70" DataFormatString="{0}">
                        </LabelsAppearance>
                    </XAxis>
                    <YAxis>
                        <LabelsAppearance DataFormatString="${0}">
                        </LabelsAppearance>
                    </YAxis>
                </PlotArea>
                <Legend>
                    <Appearance Visible="false">
                    </Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </asp:Panel>
</div>