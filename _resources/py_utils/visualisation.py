import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib as mpl
from matplotlib.font_manager import FontProperties
from contextlib import contextmanager
import os
from pathlib import Path

# Font settings
FONTS = {
    "title": "Lora",
    "title_fallback": "serif",
    "body": "Poppins",
    "body_fallback": "sans-serif",
}


def is_font_available(font_name):
    """Check if a font is available"""
    try:
        FontProperties(family=font_name)
        return True
    except:
        return False


def find_style_file():
    """Find the style file in the styles/ folder at the project root"""
    # Get the current file's directory
    current_dir = Path(__file__).resolve().parent

    # Navigate to project root (assuming _resources/py_utils/ structure)
    project_root = current_dir.parent.parent

    # Style file is located in styles/ at the project root
    style_path = project_root / "styles" / "plot_theme.mplstyle"

    # Verify the file exists
    if not style_path.exists():
        print(f"Warning: Style file not found at {style_path}")
        # Fallback to default style
        return "default"

    return str(style_path)


@contextmanager
def blog_style():
    """Apply the blog style and reset afterward"""
    # Save current rcParams
    original_rc = plt.rcParams.copy()

    try:
        # Find and apply style file
        style_path = find_style_file()
        plt.style.use(style_path)

        # Check fonts and set appropriate fallbacks
        title_font = (
            FONTS["title"]
            if is_font_available(FONTS["title"])
            else FONTS["title_fallback"]
        )
        body_font = (
            FONTS["body"]
            if is_font_available(FONTS["body"])
            else FONTS["body_fallback"]
        )

        # Set body font as default if available
        if is_font_available(FONTS["body"]):
            plt.rcParams["font.family"] = FONTS["body"]

        yield
    finally:
        # Restore original rcParams
        plt.rcParams.update(original_rc)


def finalize_plot(fig, ax, title=None, subtitle=None, caption=None):
    """Apply final touches to make plots blog-ready

    Parameters:
    -----------
    fig : matplotlib figure
    ax : matplotlib axes
    title : str, optional
        Main plot title
    subtitle : str, optional
        Subtitle text
    caption : str, optional
        Caption text for figure
    """
    # Determine best fonts
    title_font = (
        FONTS["title"] if is_font_available(FONTS["title"]) else FONTS["title_fallback"]
    )
    body_font = (
        FONTS["body"] if is_font_available(FONTS["body"]) else FONTS["body_fallback"]
    )

    # Set title with left alignment like ggplot
    if title:
        title_y_pos = 1.05
        if subtitle:
            title_y_pos = 1.10

        title_obj = ax.text(
            -0.08,
            title_y_pos,
            title,
            transform=ax.transAxes,
            ha="left",
            va="bottom",
            fontsize=18,
            fontweight="normal",
            fontfamily=title_font,
        )

        # Add subtitle if provided
        if subtitle:
            ax.text(
                -0.08,
                1.03,
                subtitle,
                transform=ax.transAxes,
                ha="left",
                va="bottom",
                fontsize=14,
                fontweight="normal",
                fontfamily=title_font,
                color="#555555",
            )

    # Add caption if provided
    if caption:
        fig.text(
            0.98,
            -0.025,
            caption,
            ha="right",
            va="bottom",
            fontsize=10,
            color="#808080",
            fontfamily=body_font,
        )

    # Remove legend title if it exists
    legend = ax.get_legend()
    if legend:
        legend.set_title("")

    # Apply styling to spines and ticks if not already applied
    for spine in ax.spines.values():
        spine.set_edgecolor("#e6e6e6")
        spine.set_linewidth(0.4)

    ax.tick_params(
        axis="both", which="major", color="#e6e6e6", width=0.4, length=2.8, pad=2.0
    )

    # Ensure tight layout while preserving space for title
    top_margin = 0.9
    if subtitle:
        top_margin = 0.88
    fig.subplots_adjust(top=top_margin)


def example_plot():
    """An example using the blog style"""
    # Sample data
    data = [10, 15, 7, 12, 9]
    categories = ["A", "B", "C", "D", "E"]

    # Create plot with blog style
    with blog_style():
        fig, ax = plt.subplots()

        # Standard matplotlib code that readers will recognize
        bars = ax.bar(categories, data, color="#7AB5CC")

        # Highlight a specific bar - use specific colors instead of from a dictionary
        bars[1].set_color("#D93649")

        # Standard matplotlib labeling
        ax.set_xlabel("Category")
        ax.set_ylabel("Value")

        # Apply final styling touches
        finalize_plot(
            fig,
            ax,
            title="Sample Bar Chart",
            subtitle="Showing basic data distribution",
            caption="Data is for illustration purposes only",
        )

        return fig, ax
