﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Grid.ascx.cs" Inherits="DashboardX.pages.Grid" %>

<script type="text/javascript">
    $(window).resize(function () {
        GridResize(JSON.parse(localStorage.getItem('e')));
    });
    function GridResize(e) {
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
            iPadding = 270,
            iWinHeight = window.innerHeight;

        if (iWinHeight <= 500)
            iWinHeight = 500;

        scrollArea.style.height = (iWinHeight - iPadding) + "px";

        localStorage.setItem('e', temp_e);
    }
</script>
<telerik:RadGrid id="MainGrid" runat="server" OnNeedDataSource="MainGrid_NeedData"
    AllowPaging="True" AllowSorting="True" PageSize="50">
    <ClientSettings>
        <Resizing AllowColumnResize="true" AllowRowResize="true" />
        <Scrolling AllowScroll="true" ScrollHeight="600px" UseStaticHeaders="true" />
        <ClientEvents OnGridCreated="GridResize" />
    </ClientSettings>
    <MasterTableView EditMode="InPlace">
    </MasterTableView>
</telerik:RadGrid>