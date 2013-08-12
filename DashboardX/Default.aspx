<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Default.aspx.cs" Inherits="Default" %>

<%@ Import Namespace="DashboardX" %>
<%@ Import Namespace="System.Data" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="~/pages/Grid.ascx" TagPrefix="uc1" TagName="Grid" %>
<%@ Register Src="~/pages/Charts.ascx" TagPrefix="uc1" TagName="Charts" %>

<asp:SqlDataSource ID="SqlDataSource_Stores" runat="server"
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    DataSourceMode="DataSet"
    SelectCommand="select distinct LocationID, DBAName from dbx.dbo.SampleData">
</asp:SqlDataSource>
<asp:SqlDataSource ID="SqlDataSource_SelectedStore" runat="server"
    ConnectionString="<%$ ConnectionStrings:LocalConnectionString %>"
    DataSourceMode="DataSet"
    SelectCommand="select distinct DBAName from dbx.dbo.SampleData where LocationID=@lid">
</asp:SqlDataSource>

<%--

TODO:
 - Use Sessions and such to make storing the selected store and other related data easier.
 - Persist the current tab with sessions or the popstate functionality.
 - Use parameters instead of String.Format() for SQL queries and also consolidate SQL into a one liner instead of conditional (ternary).
 - Use LocationID in conjunction with DBAName to make a less error prone system.
 - Maybe even concoct a way to retreieve data from a master set using a class (getStore(), getID(), etc.).
 - Get all data at once at beginning.
--%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%=AppInfo.Title%></title>
    <link href="favicon.ico" rel="shortcut icon" />
    <telerik:RadStyleSheetManager id="RadStyleSheetManager" runat="server" />
    <link href="<%=Globals.Dirs.CSS%>/styles.css" rel="stylesheet" type="text/css" />
    <!-- jQuery -->
    <script src="<%=Globals.Dirs.JS%>/jquery-1.10.2.min.js" type="text/javascript"></script>
    <!-- jQuery UI -->
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/redmond/jquery-ui.min.css" rel="stylesheet" type="text/css" />
    <script src="<%=Globals.Dirs.JS%>/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
    <!-- Modernizr -->
    <script src="<%=Globals.Dirs.JS%>/modernizr.min.js" type="text/javascript"></script>
    <!-- jQuery Easing -->
    <script src="<%=Globals.Dirs.JS%>/jquery.easing.min.js" type="text/javascript"></script>
    <!-- Dropdown -->
    <link href="<%=Globals.Dirs.JS%>/dropdown/jquery.dropdown.css" rel="stylesheet" type="text/css" />
    <script src="<%=Globals.Dirs.JS%>/dropdown/jquery.dropdown.js" type="text/javascript"></script>
    <!-- Proprietary -->
    <script src="<%=Globals.Dirs.JS%>/scripts.js" type="text/javascript"></script>
    <% if (IsMobile) { %><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" /><% } %>
</head>
<body>
    <form id="main" runat="server">
        <telerik:RadFormDecorator ID="QsfFormDecorator" runat="server" DecoratedControls="Zone" EnableRoundedCorners="false" />
	    <telerik:RadScriptManager id="RadScriptManager" runat="server">
		    <Scripts>
			    <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
		    </Scripts>
	    </telerik:RadScriptManager>
	    <telerik:RadAjaxManager id="RadAjaxManager" runat="server">
	    </telerik:RadAjaxManager>        
        <telerik:RadWindowManager ID="RadWindowManager" runat="server" OnClientPageLoad="DBX.Events.WindowShown" MinimizeZoneID="tools" KeepInScreenBounds="true">
        </telerik:RadWindowManager>
        <script type="text/javascript">
            // TODO: Add popstate, etc.
            /*window.onpopstate = function () {
                var iIndex = history.state.tab;

                //DBX.Events.TabSelected();
            }*/
            DBX.Utils.OpenWindow = function (sWin) {
                //Get RadWindow's element
                var oWin = $find(sWin); //.get_element();
                oWin.show();
            }
            DBX.Events.TabSelected = function (sender, e) {
                var tab = e.get_tab(),
                    iIndex = tab.get_index(),
                    tabStrip = tab.get_parent(),
                    multiPage = tabStrip.get_multiPage();

                //console.debug("Multipage:", multiPage);

                tabStrip.set_selectedIndex(iIndex);
                multiPage.set_selectedIndex(iIndex);

                var oData = { tab: iIndex },
                    sPushTitle = "tab_state",
                    sQuery = "?tab=1";

                //localStorage['tab'] = iIndex;
                //history.pushstate({ tab: iIndex }, "tab_state", "?tab=" + iIndex);
                /*if (history.state.tab != null)
                    history.replaceState(oData, sPushTitle, sQuery);
                else
                    history.pushState(oData, sPushTitle, sQuery);*/

                console.debug(sender, e);
            }
            DBX.Events.WindowShown = function (sender, args) {
                //Get RadWindow's element
                var oWin = sender.get_element();
                console.debug(oWin);
                //Get attribute's value
                //var atributeValue = oWin.getAttribute("myAttribute");
                //alert(atributeValue); 
            }
            $(function () {
                // Remove the HREF for all tabs (we are handling it with JavaScript)
                // and make title element show the keyboard shortcut (cannot set with
                // server-side tag).
                $(".rtsLink").each(function(i, v) {
                    var $this = $(this);
                    $this.attr({
                        href: "",
                        title: "Shortcut: Alt(+Shift)+" + $this.attr("accesskey")
                    });
                });

                $(".rtsLI").disableSelection();
            });
        </script>
        <div id="overlay">
            <div id="loading_container">
                <img src="<%=Globals.Dirs.Images%>/loading.gif" />
                <div id="message"></div>
            </div>
        </div>
	    <div id="wrapper">
            <header>
                <div class="left">
                    <img id="logo" alt="" class="left" src="<%=Globals.Dirs.Images%>/logo.png" />
                    <div class="title"><%=AppInfo.Title%></div>
                </div>
                <div id="tools">
                    <div id="store" title="Select store" data-dropdown="#dd_store"></div>
                    <div id="controls" title="Controls" data-dropdown="#dd_controls"></div>
                    <section id="dd_container">
                        <div id="dd_store" class="dropdown dropdown-relative dropdown-scroll dropdown-tip">
                            <ul class="dropdown-menu">
                                <li class="dropdown-menu-title">Select Store</li>
                                <%
                                    DataView dv = (DataView)SqlDataSource_Stores.Select(DataSourceSelectArguments.Empty);
                                    HttpContext c = HttpContext.Current;
                                    
                                    for (int i = 0; i < dv.Table.Rows.Count; i++)
                                    {
                                        object[] row = dv.Table.Rows[i].ItemArray;
                                        
                                        string sSID = row[0].ToString(),
                                               sSelectedSID = null,
                                               sStore = row[1].ToString();

                                        if (c.Request["lid"] != null)
                                            sSelectedSID = c.Request["lid"];

                                        bool bSelected = (sSelectedSID != null && sSID.Equals(sSelectedSID));

                                        Response.Write(String.Format("<li{0}><a href=\"?lid={1}\"{2}>{3}</a></li>", (bSelected ? " class=\"checked\" title=\"Currently selected store\"" : ""), sSID, (bSelected ? " onclick=\"return false;\"" : ""), sStore));
                                    }
                                %>
                                <li class="dropdown-divider"></li>
                                <li class="center<% if (c.Request["lid"] == null) Response.Write(" checked\" title=\"All stores are currently selected\""); else Response.Write("\""); %>><a href="Default.aspx">All</a></li>
                            </ul>
                        </div>
                        <div id="dd_controls" class="dropdown dropdown-relative dropdown-tip">
                            <ul class="dropdown-menu">
                                <li><a href="#">Theme</a></li>
                                <li class="dropdown-divider"></li>
                                <li><a href="#">Settings</a></li>
                            </ul>
                        </div>
                    </section>
                </div>
                <div id="info">
                    <% if (c.Request["lid"] != null)
                       { %>
                    <strong>Store:</strong> <span><%
                        //c.Request["lid"]
                        dv = (DataView)SqlDataSource_SelectedStore.Select(DataSourceSelectArguments.Empty);
                        
                        for (int i = 0; i < dv.Table.Rows.Count; i++)
                        {
                            object[] row = dv.Table.Rows[i].ItemArray;

                            string sStore = row[0].ToString();

                            Response.Write(sStore);
                        }
                    %></span>
                    <% } %>
                </div>
                <div id="login_container">
                    <a class="loginlink" href="#">Log In </a>
                    <div class="drop">
                        <asp:Login id="Login" runat="server">
                            <LayoutTemplate>
                                <table cellpadding="0">
                                    <tr>
                                        <td id="response" colspan="2" align="center">
                                            <div class="ui-state-error ui-corner-all">
                                                <span class="ui-icon ui-icon-alert" style="float: left; margin-right:.3em;"></span>
                                                <asp:Literal id="FailureText" runat="server"></asp:Literal>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <label for="UserName">Username:</label>
                                        </td>
                                        <td>
                                            <asp:TextBox id="UserName" runat="server"></asp:TextBox>
                                            <asp:requiredfieldvalidator id="UserNameRequired" runat="server" ControlToValidate="UserName" Text="*"></asp:requiredfieldvalidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <label for="Password">Password:</label>
                                        </td>
                                        <td>
                                            <asp:TextBox id="Password" runat="server" textMode="Password"></asp:TextBox>
                                            <asp:requiredfieldvalidator id="PasswordRequired" runat="server" ControlToValidate="Password" Text="*"></asp:requiredfieldvalidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Checkbox id="RememberMe" runat="server" Text="Remember me"></asp:Checkbox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:button id="Login" CommandName="Login" runat="server" Text="Login"></asp:button>
                                        </td>
                                    </tr>
                                </table>
                                <div class="login-links">
                                    <a href="/Register.aspx">Register</a>
                                    <a href="/Forgot.aspx">Forgot password?</a>
                                </div>
                            </LayoutTemplate>
                        </asp:Login>
                    </div>
                </div>
            </header>
            <section id="content">
                <telerik:RadTabStrip ID="RadTabStrip1" MultiPageID="RadMultiPage1" 
                 OnClientTabSelected="DBX.Events.TabSelected" runat="server">
                    <Tabs>
                        <telerik:RadTab Text="<u>G</u>rid" NavigateUrl="/Default.aspx?tab=0" 
                         AccessKey="G" ImageUrl="~/assets/img/icons/grid.png" 
                         SelectedImageUrl="~/assets/img/icons/grid_selected.png">
                        </telerik:RadTab>
                        <telerik:RadTab Text="<u>C</u>harts" NavigateUrl="/Default.aspx?tab=1"
                         AccessKey="C" ImageUrl="~/assets/img/icons/charts.png"
                         SelectedImageUrl="~/assets/img/icons/charts_selected.png">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0">
                    <telerik:RadPageView ID="RadPageView1" runat="server">
                        <uc1:Grid runat="server" ID="Grid" />
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView2" runat="server">
                        <uc1:Charts runat="server" ID="Charts" />
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
            </section>
	    </div>
	</form>
</body>
</html>
