// Only global namespace.
var DBX = {
    console: {
        //Settings
        formatting: {
            debug: {
                showInfo: true
            },
            stackTrace: {
                ignoreDebugFuncs: true,
                spacing: false
            }
        }
    },
    events: {},
    utils: {},

    // Settings
    debugging: true,
    trace: false//true
};

// Commonly used functions
DBX.console.debug = function () {
    var args = ((typeof arguments !== 'undefined') ? Array.prototype.slice.call(arguments, 0) : []),
        aLines = DBX.console.stackTrace().split("\n"),
        aCurrentLine = aLines[2].split(/[@:]/),
        sBorder = "--------------------------------------------------------------------------------------------",
        sLines = "";

    // Show info if the setting is true and there's no extra trace (would be kind of pointless).
    if (DBX.console.formatting.debug.showInfo && !DBX.trace) {
        var sFunc = aCurrentLine[0],
            sURL = aCurrentLine[1],
            sLine = aCurrentLine[2];
        console.debug("On l
    }

    // If the setting permits, get rid of the two obvious debug functions (DBX.console.debug and DBX.console.stackTrace).
    if (DBX.console.formatting.stackTrace.ignoreDebugFuncs) {
        aLines.shift();
        aLines.shift();
    }

    sLines = aLines.join(((DBX.console.formatting.stackTrace.spacing) ? "\n\n" : "\n")).trim();

    trace = typeof trace !== 'undefined' ? trace : true;
    if (typeof console != "undefined" && DBX.debugging == true) {
        for (var arg in args)
            console.debug(args[arg]);

        if (DBX.trace) {
            console.debug(sBorder + "\nStack Trace\n" + sBorder + "\n");
            console.debug(sLines);
            console.debug(sBorder + "\n\n");
        }
    }
}
DBX.console.stackTrace = function () {
    var err = new Error();
    return err.stack;
}
DBX.utils.getParameterByName = function(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
DBX.utils.disableSelection = function(target) {
    DBX.console.debug(target);

    if (typeof target.onselectstart != "undefined")             // For IE
        target.onselectstart = function() { return false };
    else if (typeof target.style.MozUserSelect != "undefined")  // For Firefox
        target.style.MozUserSelect = "none";
    else                                                        // All other routes (Opera, etc.).
        target.onmousedown = function() { return false };
    
    target.style.cursor = "default";
}

$(function() {

    // -------------------- Log In --------------------
    
    (function () {
        var $drop = $(".drop"),
            $link = $(".loginlink"),
            bError = $("#response").text().trim().length != 0,
            iHeight = "auto"; // 135;

        // If there's an error, make it a little taller.
        if (!bError)
        //    iHeight = 175;
        //else
            $("#response").parent().remove();

        $drop.height(iHeight);

        // If the form was submitted and there's an error, reopen
        // the dropdown as soon as the page loads.
        if (DBX.utils.getParameterByName("UserName") != null && bError) {
            $link.addClass("clicked");
            $drop.show();
        }

        //$link.filter(".clicked").hide();

        $link.click(function () {
            var $this = $(this);

            if ($drop.is(":hidden")) {
                $drop.slideDown().animate({ height: iHeight/* + "px"*/ }, { queue: false, duration: 600, easing: "easeOutBounce" });
                $this.addClass("clicked");
            }
            else {
                $drop.slideUp();
                $this.removeClass("clicked");
            }
            return false;
        });

        $drop.click(function (e) {
            e.stopPropagation();
        });

        $(document).click(function () {
            $drop.fadeOut("fast");
            $link.removeClass("clicked");
        });

    // -------------------- Fading Header --------------------

        var $header = $("header"),
            fadeSpeed = 200,
            fadeTo = 0.1,
            topDistance = 30,
            showHeader = function () {
                $header.fadeTo(fadeSpeed, 1);
            }, fadeHeader = function () {
                $header.fadeTo(fadeSpeed, fadeTo);
            },
            inside = false;

        $(window).scroll(function () {
            //DBX.console.debug('scrolling');
            position = $(window).scrollTop();
            if (position >= topDistance && !inside) {
                fadeHeader();
                $header.bind('mouseenter', showHeader);
                $header.bind('mouseleave', fadeHeader);
                inside = true;
            }
            else if (position < topDistance) {
                showHeader();
                $header.unbind('mouseenter', showHeader);
                $header.unbind('mouseleave', fadeHeader);
                inside = false;
            }
        });
    })();

});