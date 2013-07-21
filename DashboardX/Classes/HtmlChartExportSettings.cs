using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;

/// <summary>
/// The settings needed for exporting the RadHtmlChart
/// </summary>
public class HtmlChartExportSettings
{
	private int _Height;
	private int _Width;
	private string _SvgFilePath;
	private string _OutputFilePath;
	private string _Extension;
	private string _ClientFileName;

	public HtmlChartExportSettings()
	{
        
	}

	/// <summary>
	/// The path to the Inkscape executable on the server.
	/// </summary>
    public const string InkscapePath = @"C:\Projects\Dashboard\DashboardX\etc\inkscape\InkscapePortable.exe";//the path to the Inkscape executable on your machine

	/// <summary>
	/// A list with the appropriate content-type values for the file formats.
	/// </summary>
	public static readonly Dictionary<string, string> ContentTypeList = new Dictionary<string, string>
		{
			{"png", "image/png"},
			{"pdf", "application/pdf"}
		};

	/// <summary>
	/// The height of the exported file, usually the height of the chart.
	/// </summary>
	public int Height
	{
		get { return _Height; }
		set { _Height = value; }
	}

	/// <summary>
	/// The width of the exported file, usually the width of the chart.
	/// </summary>
	public int Width
	{
		get { return _Width; }
		set { _Width = value; }
	}

	/// <summary>
	/// The path to the SVG file that will be passed to Inkscape.
	/// </summary>
	public string SvgFilePath
	{
		get { return _SvgFilePath; }
		set { _SvgFilePath = value; }
	}

	/// <summary>
	/// The paht to the file created by Inkscape that will be sent to the client.
	/// </summary>
	public string OutputFilePath
	{
		get { return _OutputFilePath; }
		set { _OutputFilePath = value; }
	}

	/// <summary>
	/// The format in which the chart will be exported.
	/// </summary>
	public string Extension
	{
		get { return _Extension; }
		set { _Extension = value; }
	}

	/// <summary>
	/// The file name the client will receive for the file.
	/// </summary>
	public string ClientFileName
	{
		get { return _ClientFileName; }
		set { _ClientFileName = value +"." + this.Extension; }
	}
}