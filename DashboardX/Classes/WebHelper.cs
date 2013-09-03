using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// A class that assists with various aspects of website creation.
/// </summary>
public class WebHelper
{
    private static HttpContext web = HttpContext.Current;

    /// <summary>
    /// Adds a reference to a file (JavaScript, CSS, etc.), automatically detecting the file type.
    /// </summary>
    /// <param name="file">Path to file to which to add.</param>
    /// <param name="inScriptDir">In main script directory? Defaults to true.</param>
    /// <param name="parentDir">The parent directory of the resource.</param>
    public static string AddResource(string file, bool inScriptDir = true, string parentDir = "", string id = "")
    {
        string sExt = Path.GetExtension(file).Replace(".", "").ToLower(),
               sFormat = "";

        if (!parentDir.Equals("") && !parentDir.EndsWith("/"))
            parentDir += "/";

        switch (sExt)
        {
            case "css":
                sFormat = "<link{0} href=\"{1}\" rel=\"stylesheet\" type=\"text/css\" />";
                break;
            case "js":
                sFormat = "<script{0} src=\"{1}\" type=\"text/javascript\"></script>";
                break;
        }

        return String.Format(sFormat, ((!String.IsNullOrEmpty(id)) ? " id=\"" + id + "\"" : ""), ((inScriptDir) ? Globals.Dirs.JS + "/" : "") + parentDir + file);
    }

    /*
    public static string[] ProcessRequest(HttpContext context)
    {
        List<string> aResult = new List<string>();
        
        using (var reader = new StreamReader(context.Request.InputStream))
        {
            string postedData = reader.ReadToEnd();
            foreach (var item in postedData.Split(new [] { '&' }, StringSplitOptions.RemoveEmptyEntries))
            {
                var tokens = item.Split(new [] { '=' }, StringSplitOptions.RemoveEmptyEntries);
                if (tokens.Length < 2)
                {
                    continue;
                }
                var paramName = tokens[0];
                var paramValue = tokens[1];
                var values = paramValue.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var value in values)
                {
                    var decodedValue = context.Server.UrlDecode(value);
                    aResult.Add(decodedValue);
                }
            }
        }

        return aResult.ToArray();
    }*/
}