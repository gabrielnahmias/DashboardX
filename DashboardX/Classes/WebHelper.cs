using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

public class WebHelper
{
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
    }
}