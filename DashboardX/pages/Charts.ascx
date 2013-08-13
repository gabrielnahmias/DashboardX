<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Charts.ascx.cs" Inherits="DashboardX.pages.Charts" %>

<asp:SqlDataSource ID="SqlDataSource_TotalSales" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>">
</asp:SqlDataSource>

<%--select CAST(REPLACE(STR(SUM(TransAmount), max(LEN(convert(varchar, TransAmount)))+1, 2), SPACE(1), '0') AS varchar) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate--%>

<script type="text/javascript">
    var DBX = DBX || {};

    // TODO: Save every position and run that as query.
    //       Maybe use master site file for this so charts can be sorted server-side.
    DBX.events.dockPositionChanged = function (sender, e) {
        DBX.console.debug(sender, e);
        var /*$dock = $(sender._element),
            $chart = $dock.find(".chart"),
            sChart = $chart.attr("id"),
            iPlace = $dock.index() + 1,*/
            oPositions = {},
            sPositions = "";

        // Go through each dock and account for its position.
        $("#charts .RadDockZone").find(".RadDock:not(.rdPlaceHolder)").each(function (i, v) {
            var $this = $(this),
                sType = $this.find(".chart").attr("id");

            oPositions[sType] = i + 1;
        });

        // Ensure JSON works with a conditional polyfill.
        Modernizr.load({
            test: !!window.JSON && !!JSON.stringify,
            nope: "<%=Globals.Dirs.JS%>/json3.min.js",
            complete: function (e) {
                $.post("UpdateChartPositions.aspx", {
                    positions: JSON.stringify(oPositions)//"{Position:" + iPlace + ", Type:'" + sChart + "}'"
                }, function (data) {
                    DBX.console.debug(data);
                });
            }
        });
    }
    $(function () {
        // This needs to be wrapped inside a $(document).ready() for $find() to work.. why?
        DBX.utils.getSvgContent = function (sender, chart) {
            // Obtain an SVG version of the chart regardless of the browser.
            DBX.console.debug($find("RadHtmlChart1"));
            var chartRendering = $find(chart).getSVGString();
            $("#overlay").find("#message").html("Generating chart...").end().fadeIn();

            // Store the SVG string in a hidden field and escape it so that the value can be posted to the server.
            $get("<%=svgHolder.ClientID %>").value = escape(chartRendering);
            // Initiate the postback from the button so that its server-side handler is executed.
            __doPostBack(sender.name, "");

            setTimeout(function () {
                $("#overlay").fadeOut(400, function () {
                    $(this).find("#message").html("");
                });
            }, 3000);
        }
    });
    (function ($) {
        //var $d = $(document);
        $(function () {
            $("tr.rdGripTop").attr("title", "Grab and drag to move this chart.");
            
            $(".download-image > .button").attr("title", "Download image of the chart");
            
            // When you hover over a chart, show the download button/dropdown
            // and unless the user hovers over that specific area, hide it
            // within 3 seconds of being shown. Also, if the user's mouse leaves
            // the chart, the download area hides immediately.
            $(".chart").mouseenter(function () {
                var $this = $(this),
                    $dl = $this.find(".download-image"),
                    timeoutID = setTimeout(function () {
                        $dl.hide();
                    }, 3000);
                $dl.show().data("timeoutID", timeoutID);
            }).mouseleave(function () {
                $(this).find(".download-image").hide();
            }).find(".download-image").mouseenter(function (e) {
                //DBX.console.debug(e);
                //alert($(this).data("timeoutID"))
                clearTimeout($(this).data("timeoutID"));
            }).mouseleave(function () {
                var timeoutID = setTimeout(function () {
                    $(this).hide();
                }, 3000);
                $(this).data("timeoutID", timeoutID);
            });

            $("#charts").css("visibility", "hidden");

            $("#overlay").find("#message").html("Loading chart positions...").end().fadeIn();

            $.ajax("LoadChartPositions.aspx", {
                dataType: "json",
                success: function (data) {
                    //DBX.console.debug("Data:",data);
                    $("#overlay").fadeOut(400, function () {
                        $(this).find("#message").html("");
                    });
                    for (chartType in data) {
                        // The positions are received sorted by position, so we just go through
                        // and prepend() them all.
                        var $chart = $("#" + chartType),
                            $dock = $chart.parents(".RadDock"),
                            iPlace = data[chartType],
                            sDockID = $dock.attr("id"),
                            oDock = $find(sDockID),
                            oDockZone = oDock.get_parent();

                        DBX.console.debug("Undocking " + chartType + " chart.");
                        oDock.undock();
                        DBX.console.debug("Docking " + chartType + " chart at position " + iPlace + ".");
                        oDockZone.dock(oDock, iPlace - 1);
                    }

                    $("#charts").hide().css("visibility", "visible").fadeIn();
                }
            });

            //$("[id*=Panel]").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all");
        });
    })(jQuery);
</script>

<asp:HiddenField runat="server" ID="svgHolder" />

<div id="charts">
    <telerik:RadDockLayout runat="server" ID="RadDockLayout1">
        <telerik:RadDockZone runat="server" ID="RadDockZoneHorizontal1" Orientation="Horizontal"
        Height="881px" Width="920px">
            <telerik:RadDock OnClientDockPositionChanged="DBX.events.dockPositionChanged" runat="server" ID="RadDock1" DockHandle="Grip" Title="" Text="" Height="440px" Width="460px">
                <ContentTemplate>
                    <div id="column" class="chart">
                        <div class="download-image">
                            <asp:DropDownList ID="DropDownList1" runat="server">
                                <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                            <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="Button1" runat="server" CssClass="strong caps button" Text="Download" OnClick="DownloadColumnChart" OnClientClick="DBX.utils.getSvgContent(this, 'RadHtmlChart1'); return false;" />
                        </div>
                        <telerik:RadHtmlChart ClientIDMode="Static" ID="RadHtmlChart1" runat="server" DataSourceID="SqlDataSource_TotalSales">
                            <PlotArea>
                                <Series>
                                    <telerik:ColumnSeries ColorField="Color" DataFieldY="TotalSales">
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
                </ContentTemplate>
            </telerik:RadDock>
            <telerik:RadDock OnClientDockPositionChanged="DBX.events.dockPositionChanged" runat="server" ID="RadDock2" DockHandle="Grip" Title="" Text="" Height="440px" Width="460px">
                <ContentTemplate>
                    <div id="pie" class="chart">
                        <div class="download-image">
                            <asp:DropDownList ID="DropDownList2" runat="server">
                                <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                            <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="Button2" runat="server" CssClass="strong caps button" Text="Download" OnClick="DownloadPieChart" OnClientClick="DBX.utils.getSvgContent(this, 'RadHtmlChart2'); return false;" />
                        </div>
                        <telerik:RadHtmlChart ClientIDMode="Static" ID="RadHtmlChart2" runat="server"
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
                </ContentTemplate>
            </telerik:RadDock>
            <telerik:RadDock OnClientDockPositionChanged="DBX.events.dockPositionChanged" runat="server" ID="RadDock3" DockHandle="Grip" Title="" Text="" Height="440px" Width="460px">
                <ContentTemplate>
                    <div id="bar" class="chart">
                        <div class="download-image">
                            <asp:DropDownList ID="DropDownList3" runat="server">
                                <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                            <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="Button3" runat="server" CssClass="strong caps button" Text="Download" OnClick="DownloadBarChart" OnClientClick="DBX.utils.getSvgContent(this, 'RadHtmlChart3'); return false;" />
                        </div>
                        <telerik:RadHtmlChart ClientIDMode="Static" ID="RadHtmlChart3" runat="server" DataSourceID="SqlDataSource_TotalSales">
                            <PlotArea>
                                <Series>
                                    <telerik:BarSeries ColorField="Color" DataFieldY="TotalSales">
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
                </ContentTemplate>
            </telerik:RadDock>
            <telerik:RadDock OnClientDockPositionChanged="DBX.events.dockPositionChanged" runat="server" ID="RadDock4" DockHandle="Grip" Title="" Text="" Height="440px" Width="460px">
                <ContentTemplate>
                    <div id="line" class="chart">
                        <div class="download-image">
                            <asp:DropDownList ID="DropDownList4" runat="server">
                                <asp:ListItem Text="PNG" Value="png" Selected="true"></asp:ListItem>
	                            <asp:ListItem Text="PDF" Value="pdf"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="Button4" runat="server" CssClass="strong caps button" Text="Download" OnClick="DownloadLineChart" OnClientClick="DBX.utils.getSvgContent(this, 'RadHtmlChart4'); return false;" />
                        </div>
                        <telerik:RadHtmlChart ClientIDMode="Static" ID="RadHtmlChart4" runat="server" DataSourceID="SqlDataSource_TotalSales">
                            <PlotArea>
                                <Series>
                                    <telerik:LineSeries ColorField="Color" DataFieldY="TotalSales">
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
                </ContentTemplate>
            </telerik:RadDock>
        </telerik:RadDockZone>
    </telerik:RadDockLayout>
</div>