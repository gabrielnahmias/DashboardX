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
        oExpression1 = $(id);
        oExpression2 = $("#" + sPrefix1 + id);
        oExpression3 = $("#" + sPrefix2 + id);
        if (oExpression1.length > 0)                // If the object exists on the page,
            return oExpression1;                    // return this.
        else if (oExpression2.length > 0)           // Otherwise, if an element with the ID in combination with the first prefix exists,
            return oExpression2;                    // return this.
        else if (oExpression3.length > 0)           // Otherwise, if an element with the ID in combination with the second prefix exists,
            return oExpression3;                    // return this.
    } else {
        oExpression1 = $find(id);
        oExpression2 = $find(sPrefix1 + id);
        oExpression3 = $find(sPrefix2 + id);
        if (oExpression1 != null)                   // If the object exists on the page,
            return oExpression1;                    // return this.
        else if (oExpression2 != null)              // Otherwise, if an element with the ID in combination with the first prefix exists,
            return oExpression2;                    // return this.
        else if (oExpression3 != null)              // Otherwise, if an element with the ID in combination with the second prefix exists,
            return oExpression3;                    // return this.
    }
    return null;                                    // If none of these cases are true, return null.
}