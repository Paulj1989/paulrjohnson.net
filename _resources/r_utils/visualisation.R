#' Load and configure brand fonts for visualisation
#'
#' Loads Poppins and Lora fonts from Google Fonts and enables automatic text rendering
#' via the showtext package
#'
#' @return NULL (called for side effects)
#' @export
load_fonts <- function() {
  # Load fonts from Google
  sysfonts::font_add_google("Poppins")
  sysfonts::font_add_google("Lora")
  showtext::showtext_auto()
}

#' Configure custom minimal ggplot theme with brand styling
#'
#' Creates a clean, minimal theme with Poppins as the base font and Lora
#' for titles, with tuned spacing and typography
#'
#' @param base_size Base font size (default: 20)
#' @param title_family Font for titles (default: "Lora")
#' @param text_family Font for text elements (default: "Poppins")
#' @return NULL (called for side effects by setting theme)
#' @export
create_plot_theme <- function(
  base_size = 20,
  title_family = "Lora",
  text_family = "Poppins"
) {
  ggplot2::theme_set(ggplot2::theme_minimal(
    base_size = base_size,
    base_family = text_family
  ))

  ggplot2::theme_update(
    panel.grid.major = ggplot2::element_line(color = "grey90", linewidth = .4),
    panel.grid.minor = ggplot2::element_blank(),
    panel.spacing.x = ggplot2::unit(.65, units = "cm"),
    panel.spacing.y = ggplot2::unit(.3, units = "cm"),

    # Axis styling
    axis.title.x = ggplot2::element_text(
      color = "grey30",
      margin = ggplot2::margin(t = 5),
      size = ggplot2::rel(1.05),
      lineheight = 0.55
    ),
    axis.title.y = ggplot2::element_text(
      color = "grey30",
      margin = ggplot2::margin(r = 5),
      size = ggplot2::rel(1.05),
      lineheight = 0.55
    ),
    axis.text = ggplot2::element_text(color = "grey50", size = ggplot2::rel(1)),
    axis.ticks = ggplot2::element_line(color = "grey90", linewidth = .4),
    axis.ticks.length = ggplot2::unit(.2, "lines"),

    # Legend styling
    legend.position = "top",
    legend.title = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = ggplot2::rel(.9)),
    legend.box.margin = ggplot2::margin(0, 0, -10, 0),
    legend.key.width = ggplot2::unit(1, units = "cm"),

    # Title and caption styling
    plot.title = ggplot2::element_text(
      hjust = 0,
      color = "black",
      family = title_family,
      size = ggplot2::rel(1.5),
      margin = ggplot2::margin(t = 5, b = 5)
    ),
    plot.subtitle = ggplot2::element_text(
      hjust = 0,
      color = "grey30",
      family = title_family,
      lineheight = 0.55,
      size = ggplot2::rel(1.1),
      margin = ggplot2::margin(5, 0, 15, 0)
    ),
    plot.title.position = "plot",
    plot.caption = ggplot2::element_text(
      color = "grey50",
      size = ggplot2::rel(0.8),
      hjust = 1,
      margin = ggplot2::margin(10, 0, 0, 0)
    ),
    plot.caption.position = "plot",
    plot.margin = ggplot2::margin(rep(10, 4)),

    # Facet label styling
    strip.text = ggplot2::element_text(
      size = ggplot2::rel(1),
      margin = ggplot2::margin(0, 0, 5, 0)
    ),
    strip.clip = "off"
  )
}

#' Format GT tables with consistent styling
#'
#' Creates a clean, consistent look for GT tables that matches the
#' plot styling, with configurable width and alignment options
#'
#' @param data A GT table object to style
#' @param width Table width as percentage (default: 100)
#' @param alignment Table alignment (default: "center")
#' @param source_note Optional source note text (default: NULL)
#' @param font_family Font family for table text (default: "Poppins")
#' @return A styled GT table
#' @export
table_theme <- function(
  data,
  width = 100,
  alignment = "center",
  source_note = NULL,
  font_family = "Poppins"
) {
  # Start with the data
  styled_table <- data

  # Add source note if provided
  if (!is.null(source_note)) {
    styled_table <- styled_table |>
      gt::tab_source_note(source_note = source_note)
  }

  # Apply table options
  styled_table <- styled_table |>
    gt::tab_options(
      footnotes.marks = "standard",
      footnotes.spec_ref = "^i",
      footnotes.spec_ftr = "()",
      table.width = gt::pct(width),
      table.align = alignment,
      table.font.names = font_family
    ) |>
    gt::tab_style(
      style = gt::cell_text(align = "left"),
      locations = list(gt::cells_source_notes(), gt::cells_footnotes())
    )

  return(styled_table)
}

#' Initialize complete visualisation environment
#'
#' One-step function to configure both fonts and plot theme
#'
#' @param base_size Base font size for plots (default: 20)
#' @return NULL (called for side effects)
#' @export
set_plot_theme <- function(base_size = 20) {
  load_fonts()
  create_plot_theme(base_size = base_size)
}
