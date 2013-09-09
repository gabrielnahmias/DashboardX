// Only global namespace.
var DBX = {
    events: {},
    utils: {}
};

//Console.settings.debug.enabled = false;
Console.settings.stackTrace.enabled = false;

DBX.utils.closeRadWindow = function (id, jquery) {
    DBX.utils.getRadWindow(id, jquery).close();
}
DBX.utils.disableSelection = function (target) {
    Console.debug(target);

    if (typeof target.onselectstart != "undefined")             // For IE
        target.onselectstart = function () { return false };
    else if (typeof target.style.MozUserSelect != "undefined")  // For Firefox
        target.style.MozUserSelect = "none";
    else                                                        // All other routes (Opera, etc.).
        target.onmousedown = function () { return false };

    target.style.cursor = "default";
}
DBX.utils.getParameterByName = function(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=a([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
DBX.utils.getRadWindow = function (id, jquery = false) {
    var oWin = null,
        sPrefix1 = "RadWindow_",
        sPrefix2 = "RadWindowWrapper_RadWindow_",
        oExpression1 = null,
        oExpression2 = null,
        oExpression3 = null;
    if (jquery) {
        oExpression1 = $("#" + sPrefix2 + id);
        oExpression2 = $("#" + sPrefix1 + id);
        oExpression3 = $("#" + id);
        if (oExpression1.length > 0)                // If an element with the ID in combination with the second prefix exists,
            return oExpression1;                    // return this.
        else if (oExpression2.length > 0)           // Otherwise, if an element with the ID in combination with the first prefix exists,
            return oExpression2;                    // return this.
        else if (oExpression3.length > 0)           // Otherwise,
            return oExpression3;                    // return this.
    } else {
        oExpression1 = $find(sPrefix2 + id);
        oExpression2 = $find(sPrefix1 + id);
        oExpression3 = $find(id);
        if (oExpression1 != null)                   // If an element with the ID in combination with the second prefix exists,
            return oExpression1;                    // return this.
        else if (oExpression2 != null)              // Otherwise, if an element with the ID in combination with the first prefix exists,
            return oExpression2;                    // return this.
        else if (oExpression3 != null)              // Otherwise,
            return oExpression3;                    // return this.
    }
    return null;                                    // If none of these cases are true, return null.
}
DBX.utils.getRadWindowID = function (win, lower) {
    if (typeof(lower) === 'undefined') lower = true;
    var sID = win.get_id().replace("RadWindow_", "");
    if (lower)
        sID = sID.toLowerCase();
    return sID;
}
DBX.utils.showRadWindow = function (win) {
    var oWin = DBX.utils.getRadWindow(win);
    oWin.show();
    //radopen("", sWin);
}