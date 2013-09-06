// Only global namespace.
var DBX = {
    events: {},
    utils: {}
};

//Console.settings.debug.enabled = false;
Console.settings.stackTrace.enabled = false;

DBX.utils.closeRadWindow = function (id) {
    DBX.utils.getRadWindow(id).close();
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
DBX.utils.getRadWindow = function (id) {
    var iLen = $(id).length,
        oWin = null,
        sPrefix = "#RadWindowWrapper_RadWindow_";
    if (iLen > 0)                                   // If the object exists on the page,
        oWin = $(id);                               // return this.
    else if (iLen == 0) {                           // Otherwise,
        if ($(sPrefix + id).length > 0)             // If the ID in combination with the typical prefix exists,
            oWin = $(sPrefix + id);                 // return this.
    }
    return oWin;                                    // If none of these cases are true, this returns null.
}