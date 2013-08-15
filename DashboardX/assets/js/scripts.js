// Only global namespace.
var DBX = {
    events: {},
    utils: {}
};

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
            //Console.debug('scrolling');
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