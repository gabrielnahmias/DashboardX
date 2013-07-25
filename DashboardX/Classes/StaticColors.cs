using System.Drawing;

/// <summary>
/// A Class that provides functionality for using a custom list of predefined list of colors
/// </summary>
public static class StaticColors
{
    /// <summary>
    /// Gets the color corrsponding to the passed index.
    /// </summary>
    /// <param name="index">The index in the array of predefined colors</param>
    /// <returns>The color corresponding to the passed index. Useful for programmatic creation of charts, for example.</returns>
    public static Color GetColor(int index)
    {
        return colors[index % colors.Length];
    }

    /// <summary>
    /// The list of hardcoded colors.
    /// </summary>
    /// <remarks>
    /// Can be extended manually by the developer or the class can be modified so that the property can be modified during runtime.
    /// </remarks>
    private static readonly Color[] colors = 
    {
        Color.Red,
        Color.Blue,
        Color.Green,
        Color.Yellow,
        Color.Purple,
        Color.Orange,
        Color.Violet,
        Color.NavajoWhite,
        Color.MediumSeaGreen,
        Color.HotPink
    };
}