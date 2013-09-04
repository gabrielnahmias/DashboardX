// Only global namespace.
var DBX = {
    events: {},
    utils: {}
};

//Console.settings.debug.enabled = false;
Console.settings.stackTrace.enabled = false;

DBX.utils.getParameterByName = function(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
DBX.utils.disableSelection = function(target) {
    Console.debug(target);

    if (typeof target.onselectstart != "undefined")             // For IE
        target.onselectstart = function() { return false };
    else if (typeof target.style.MozUserSelect != "undefined")  // For Firefox
        target.style.MozUserSelect = "none";
    else                                                        // All other routes (Opera, etc.).
        target.onmousedown = function() { return false };
    
    target.style.cursor = "default";
}