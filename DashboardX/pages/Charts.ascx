<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Charts.ascx.cs" Inherits="DashboardX.pages.Charts" %>

<asp:SqlDataSource ID="SqlDataSource_Columns" runat="server" 
    ConnectionString="<%$ ConnectionStrings:RCDASHConnectionString %>"
    SelectCommand="select SUM(TransAmount) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate">
</asp:SqlDataSource>

<%--select CAST(REPLACE(STR(SUM(TransAmount), max(LEN(convert(varchar, TransAmount)))+1, 2), SPACE(1), '0') AS varchar) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate--%>

<script type="text/javascript">
    // MAYBE: Make the page simply fadeIn/Out the appropriate areas.
    (function() {
        var $d = $(document);
        $d.ready(function () {
            var $back = $("#back"),
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
            });
        });

        /*setTimeout(function () {
        ChartResize()
        }, 500);

        $(window).resize(function() {
        ChartResize();
        });

        function ChartResize() {
        var charts = {
        "bar": $find("<%=RadHtmlChart1.ClientID%>"),
        "pie": $find("<%=RadHtmlChart1.ClientID%>")
        },
        iPadding = 270,
        iWinHeight = window.innerHeight,
        iWinWidth = window.innerWidth;

        if (iWinHeight <= 500)
        iWinHeight = 500;
        //if (iWinWidth <= 300)
        //    iWinWidth = 500;

        //console.debug(chart);
        chart.set_height(iWinHeight - 140);
        chart.set_width(iWinWidth - 30);
        }*/
    })();
</script>

<a id="back" href="#">◄ Back</a>

<div id="links">
    <a href="#">Columns</a>
    <a href="#">Pie</a>
</div>

<div id="columns" class="graph">
    <telerik:RadHtmlChart ID="RadHtmlChart1" runat="server" DataSourceID="SqlDataSource_Columns">
        <PlotArea>
            <Series>
                <telerik:ColumnSeries DataFieldY="TotalSales">
                    <LabelsAppearance DataFormatString="${0}" Visible="false" />
                    <TooltipsAppearance DataFormatString="${0}" />
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
            <Appearance Visible="false"></Appearance>
        </Legend>
    </telerik:RadHtmlChart>
</div>

<div id="pie" class="graph">
    <telerik:RadHtmlChart ID="RadHtmlChart2" runat="server" Transitions="true" DataSourceID="SqlDataSource_Columns">
        <PlotArea>
            <Series>
                <telerik:PieSeries DataFieldY="TotalSales" StartAngle="90">
                    <LabelsAppearance ClientTemplate="#=dataItem.SubmitDate#" Position="Circle" DataFormatString="${0}">
                    </LabelsAppearance>
                    <TooltipsAppearance ClientTemplate="$#=dataItem.TotalSales#"  DataFormatString="${0}" />
                </telerik:PieSeries>
            </Series>
            <XAxis DataLabelsField="SubmitDate" Visible="true">
            </XAxis>
            <YAxis>
                <LabelsAppearance DataFormatString="${0}">
                </LabelsAppearance>
            </YAxis>
        </PlotArea>
        <Legend>
            <Appearance Visible="false"></Appearance>
        </Legend>
    </telerik:RadHtmlChart>
</div>