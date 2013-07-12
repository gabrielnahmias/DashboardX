using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DashboardX
{
    public static class Globals
    {
        public class Dirs
        {
            public static string Assets = "assets",
                                 CSS = Assets + "/css",
                                 Images = Assets + "/img",
                                 Icons = Images + "/icons",
                                 JS = Assets + "/js";
        }
        public static string GridName = "MainGrid";
    }
}