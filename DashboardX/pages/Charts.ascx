<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Charts.ascx.cs" Inherits="DashboardX.pages.Charts" %>

<asp:SqlDataSource ID="SqlDataSource_Column" runat="server" 
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    SelectCommand="select SUM(TransAmount) as TotalSales, SubmitDate from dbx.dbo.SampleData group by SubmitDate">
</asp:SqlDataSource>

<%--select CAST(REPLACE(STR(SUM(TransAmount), max(LEN(convert(varchar, TransAmount)))+1, 2), SPACE(1), '0') AS varchar) as TotalSales, SubmitDate from RCDASH.dbo.SampleTable group by SubmitDate--%>

<script type="text/javascript">
    // MAYBE: Make the page simply fadeIn/Out the appropriate areas.
    (function() {
        var $d = $(document);
        $d.ready(function () {
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

<!--<a id="back" href="#">◄ Back</a>-->

<!--<div id="links">
    <a href="#">Column</a>
    <a href="#">Pie</a>
</div>-->

<telerik:RadTabStrip CssClass="_rtsLevel2" ID="RadTabStrip2" MultiPageID="RadMultiPage2" 
 OnClientTabSelected="SelectTab" runat="server" SelectedIndex="0">
    <Tabs>
        <telerik:RadTab Text="<u>C</u>olumn" NavigateUrl="/Default.aspx?tab=0" 
            AccessKey="C" ImageUrl="~/assets/img/icons/grid.png" 
            SelectedImageUrl="~/assets/img/icons/grid_selected.png" Selected="True">
        </telerik:RadTab>
        <telerik:RadTab Text="<u>P</u>ie" NavigateUrl="/Default.aspx?tab=1" AccessKey="P" ImageUrl="~/assets/img/icons/charts.png" SelectedImageUrl="~/assets/img/icons/charts_selected.png">
        </telerik:RadTab>
    </Tabs>
</telerik:RadTabStrip>
<telerik:RadMultiPage ID="RadMultiPage2" runat="server" SelectedIndex="0">
    <telerik:RadPageView ID="RadPageView1" runat="server">
        <div id="column" class="graph">
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
                    <Appearance Visible="false"></Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </telerik:RadPageView>
    <telerik:RadPageView ID="RadPageView2" runat="server">
        <script type="text/javascript">
            var addEventListener = function (obj, evt, fnc) {
                // W3C model
                if (obj.addEventListener) {
                    obj.addEventListener(evt, fnc, false);
                    return true;
                }
                // Microsoft model
                else if (obj.attachEvent) {
                    return obj.attachEvent('on' + evt, fnc);
                }
                // Browser don't support W3C or MSFT model, go on with traditional
                else {
                    evt = 'on' + evt;
                    if (typeof obj[evt] === 'function') {
                        // Object already has a function on traditional
                        // Let's wrap it with our own function inside another function
                        fnc = (function (f1, f2) {
                            return function () {
                                f1.apply(this, arguments);
                                f2.apply(this, arguments);
                            }
                        })(obj[evt], fnc);
                    }
                    obj[evt] = fnc;
                    return true;
                }
                return false;
            };
            function boldText() {
                $("#pie text").css("font-weight", "bold");
            }
            $(document).load(function () {
                $("svg").bind("endEvent", {}, function () {
                    alert('done');
                });
            });
        </script>
        <div id="pie" class="graph">
            <telerik:RadHtmlChart ID="RadHtmlChart2" runat="server" Transitions="true" DataSourceID="SqlDataSource_Column">
                <PlotArea>
                    <Series>
                        <telerik:PieSeries DataFieldY="TotalSales" StartAngle="90">
                            <LabelsAppearance ClientTemplate="#=dataItem.SubmitDate#" Position="Circle" DataFormatString="{0:C}">
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
                    <Appearance Visible="false"></Appearance>
                </Legend>
            </telerik:RadHtmlChart>
        </div>
    </telerik:RadPageView>
</telerik:RadMultiPage>

<div id="graphs">

</div>