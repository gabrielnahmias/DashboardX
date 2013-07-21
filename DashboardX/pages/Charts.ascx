<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Charts.ascx.cs" Inherits="DashboardX.pages.Charts" %>

<asp:SqlDataSource ID="SqlDataSource_Column" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    SelectCommand="select SUM(TransAmount) as TotalSales, SubmitDate from dbx.dbo.SampleData group by SubmitDate">
</asp:SqlDataSource>

<%--select CAST(REPLACE(STR(SUM(TransAmount), max(LEN(convert(varchar, TransAmount)))+1, 2), SPACE(1), '0') AS varchar) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate--%>

<script type="text/javascript">
    function getSvgContent(sender, chart) {
        //obtain an SVG version of the chart regardless of the browser
        var chartRendering = $find("Charts_"+chart).getSVGString();
        //store the SVG string in a hidden field and escape it so that the value can be posted to the server
        $get("<%=svgHolder.ClientID %>").value = escape(chartRendering);
        //initiate the postback from the button so that its server-side handler is executed
        __doPostBack(sender.name, "");
    }
    (function() {
        var $d = $(document);
        $d.ready(function () {
            $(".graph").hover(function () {
                $(this).find(".download-image").show();
            }, function () {
                $(this).find(".download-image").hide();
            });
            /*var $back = $("#back"),
                $graphs = $(".graph"),
                $links = $("#links"),
                oLinksStyle = {
                    left: "50%",
                    marginLeft: "-170px",
                    position: "absolute",
                    top: "50%",
                    width: "340px"
                };

            $(".graph").css("position", "absolute").hide();
            $("#links").show();

            $("#links a").click(function () {
                var $this = $(this),
                    $chart = $("#" + $this.text().toLowerCase());   // Get chart from link text.
                
                console.debug("Showing " + $chart.selector);
                
                $("#links").animate({
                    top: "+1000"
                }, 1000, "swing", function () {
                    $(this).hide();
                });

                $chart.show().animate({
                    left: "50%",
                    marginLeft: -$chart.width() / 2,
                }, 2000, "easeOutElastic", function() {
                    $("#back").slideDown().click(function() {
                        $(".graph").not($chart).hide();
                        $(this).slideUp();
                        $chart.show().animate({
                            left: "-1000",
                            marginLeft: 0
                        }, 2000, "swing", function() {
                            $(this).hide().css("left", "0");
                        });
                        $("#links").show().animate(oLinksStyle, 1000, "easeOutSine", function() {
                            $(this).css(oLinksStyle);
                        });
                    });
                });
            });*/
        });
    })();
</script>

<asp:HiddenField runat="server" ID="svgHolder" />

<div id="graphs">
    <asp:Panel ID="Panel1" runat="server" Height="450px" Width="450px" CssClass="left">
        <div id="column" class="graph">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList1" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button1" runat="server" Text="Download Image" OnClick="DownloadColumnChart" OnClientClick="getSvgContent(this, 'RadHtmlChart1'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart1" runat="server" DataSourceID="SqlDataSource_Column">
                <PlotArea>
                    <Series>
                        <telerik:ColumnSeries DataFieldY="TotalSales">
                            <LabelsAppearance DataFormatString="{0:C}" Visible="false" />
                            <TooltipsAppearance DataFormatString="{0:C}" />
                        </telerik:ColumnSeries>
                    </Series>
                    <XAxis DataLabelsField="SubmitDate" MajorTickType="None" MinorTickType="None">
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
    <asp:Panel ID="Panel2" runat="server" Height="450px" Width="450px">
        <div id="pie" class="graph">
            <div class="download-image">
                <asp:DropDownList ID="DropDownList2" runat="server">
                    <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="Button2" runat="server" Text="Download Image" OnClick="DownloadPieChart" OnClientClick="getSvgContent(this, 'RadHtmlChart2'); return false;" />
            </div>
            <telerik:RadHtmlChart ID="RadHtmlChart2" runat="server"
             Transitions="true" DataSourceID="SqlDataSource_Column">
                <PlotArea>
                    <Series>
                        <telerik:PieSeries DataFieldY="TotalSales" StartAngle="90">
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
</div>