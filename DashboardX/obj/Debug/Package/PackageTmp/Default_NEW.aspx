<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<asp:Content ID="Main" ContentPlaceHolderID="Content" runat="server">
    <telerik:RadGrid id="MainGrid" runat="server" OnNeedDataSource="MainGrid_NeedData"
        AllowPaging="True" AllowSorting="True" AllowMultiRowEdit="true" PageSize="50">
        <ClientSettings>
            <Resizing AllowColumnResize="true" AllowRowResize="true" />
            <Scrolling AllowScroll="true" ScrollHeight="600px" UseStaticHeaders="true" />
            <ClientEvents OnGridCreated="GridResize" />
        </ClientSettings>
        <MasterTableView EditMode="InPlace">
        </MasterTableView>
    </telerik:RadGrid>
</asp:Content>