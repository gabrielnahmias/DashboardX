using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using System.IO;

/// <summary>
/// Provides the core functionality for exporting the RadHtmlChart's SVG representation
/// to an image and a helper method for sending the file to the client.
/// </summary>
public static class HtmlChartExporter
{
	/// <summary>
	/// Uses a third party library called Inkscape to create a file from the SVG representation
    /// of the RadHtmlChart (already saved as a file).
	/// </summary>
	/// <param name="settings">The current settings that are used on the page.</param>
	public static void ExportHtmlChart(HtmlChartExportSettings settings)
	{
		// The actual export takes place here
		// Full list of export options is available at
		// http://tavmjong.free.fr/INKSCAPE/MANUAL/html/CommandLine-Export.html
		Process inkscape = new Process();

        string sArgs = String.Format("--file \"{0}\" --export-{1} \"{2}\"" +
                                     ( (settings.Width != null && settings.Height!=null && settings.Width!=0 && settings.Height!=0) ?
                                     " --export-width {3} --export-height {4}" :
                                     "" ), settings.SvgFilePath, settings.Extension, settings.OutputFilePath, settings.Width, settings.Height);

        Debug.WriteLine("Inkscape Args: " + sArgs);
        
        inkscape.StartInfo.FileName = HtmlChartExportSettings.InkscapePath;
        inkscape.StartInfo.Arguments = sArgs;
		inkscape.StartInfo.UseShellExecute = true;

        try
        {
            inkscape.Start();
        }
        catch (Exception e)
        {
            throw new Exception("Inkscape path is incorrect: " + HtmlChartExportSettings.InkscapePath);
        }
		
        inkscape.WaitForExit();
	}

	/// <summary>
	/// Returns a byte[] array from the file so that it can be sent to the browser.
	/// </summary>
	/// <param name="filePath">The physical path to the file to read.</param>
	/// <returns>Returns a byte[] array</returns>
	public static byte[] ReadFile(string filePath)
	{
		byte[] buffer;
		FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read);

		try
		{
			int length = (int)fileStream.Length;  // get file length
			buffer = new byte[length];            // create buffer
			int count;                            // actual number of bytes read
			int sum = 0;                          // total number of bytes read

			// read until Read method returns 0 (end of the stream has been reached)
			while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
				sum += count;  // sum is a buffer offset for next reading
		}
		finally
		{
			fileStream.Close();
		}

		return buffer;
	}
}