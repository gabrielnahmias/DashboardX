$(function () {

    // -------------------- Log In --------------------

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
    if (getParameterByName("UserName") != null && bError) {
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

    $(document).ready(function () {
        (function () {
            var $header = $("header"),
                fadeSpeed = 200,
                fadeTo = 0.1,
                topDistance = 10,
                showHeader = function () {
                    $header.fadeTo(fadeSpeed, 1);
                }, fadeHeader = function () {
                    $header.fadeTo(fadeSpeed, fadeTo);
                },
                inside = false;

            $(window).scroll(function () {
                //console.debug('scrolling');
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

});

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}