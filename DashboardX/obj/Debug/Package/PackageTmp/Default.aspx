<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Default.aspx.cs" Inherits="Default" %>

<%@ Import Namespace="DashboardX" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Src="~/pages/Grid.ascx" TagPrefix="uc1" TagName="Grid" %>
<%@ Register Src="~/pages/Charts.ascx" TagPrefix="uc1" TagName="Charts" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%=AppInfo.Title%></title>
    <link href="favicon.ico" rel="shortcut icon" />
    <telerik:RadStyleSheetManager id="RadStyleSheetManager" runat="server" />
    <link href="<%=Globals.Dirs.CSS%>/styles.css" rel="stylesheet" type="text/css" />
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/redmond/jquery-ui.min.css" rel="stylesheet" type="text/css" />
    <script src="<%=Globals.Dirs.JS%>/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="<%=Globals.Dirs.JS%>/jquery-ui-1.10.3.min.js" type="text/javascript"></script>
    <script src="<%=Globals.Dirs.JS%>/jquery.easing.min.js" type="text/javascript"></script>
    <script src="<%=Globals.Dirs.JS%>/scripts.js" type="text/javascript"></script>
    <% if (IsMobile) { %><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" /><% } %>
</head>
<body>
    <form id="main" runat="server">
	<telerik:RadScriptManager id="RadScriptManager" runat="server">
		<Scripts>
			<asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
		</Scripts>
	</telerik:RadScriptManager>
	<telerik:RadAjaxManager id="RadAjaxManager" runat="server">
	</telerik:RadAjaxManager>
    <script type="text/javascript">
        $(function () {
            // Remove the HREF for all tabs (we are handling it with JavaScript).
            $(".rtsLink").attr("href", "");
        });
        /*
        function SetTabOnLoad(sender, args) {
            console.debug(sender.get_multiPage());
            console.debug(sender, args); //iIndex, tabStrip, multiPage
            var iIndex = parseInt(localStorage['tab']),
                tabStrip = sender,
                multiPage = tabStrip.get_multiPage();
            
            tabStrip.set_selectedIndex(iIndex);
            multiPage.set_selectedIndex(iIndex);
        };
        */
        function SelectTab(sender, e) {
            var tab = e.get_tab(),
                iIndex = tab.get_index(),
                tabStrip = tab.get_parent(),
                multiPage = tabStrip.get_multiPage();

            tabStrip.set_selectedIndex(iIndex);
            multiPage.set_selectedIndex(iIndex);

            localStorage['tab'] = iIndex;

            console.debug(sender, e);
        }
    </script>
	<div id="wrapper">
        <header>
            <img id="logo" alt="" class="left" src="<%=Globals.Dirs.Images%>/logo.png" />
            <div class="title"><%=AppInfo.Title%></div>
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
            <telerik:RadTabStrip ID="RadTabStrip1" MultiPageID="RadMultiPage1" OnClientTabSelected="SelectTab" runat="server">
                <Tabs>
                    <telerik:RadTab Text="Grid" NavigateUrl="/Default.aspx?tab=0" ImageUrl="~/assets/img/icons/grid.png" SelectedImageUrl="~/assets/img/icons/grid_selected.png">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Charts" NavigateUrl="/Default.aspx?tab=1" ImageUrl="~/assets/img/icons/charts.png" SelectedImageUrl="~/assets/img/icons/charts_selected.png">
                        <Tabs>
                            <telerik:RadTab Text="Bar">
                            </telerik:RadTab>
                            <telerik:RadTab Text="Pie">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" runat="server">
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
