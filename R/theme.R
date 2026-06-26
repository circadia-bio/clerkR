#' clerkR colour palette
#'
#' @description
#' Returns the named clerkR colour palette as a character vector of hex codes.
#' Individual colours can be accessed by name via `clerk_colour()`.
#'
#' The palette pairs a formal cool-blue range (navy → light teal → near-white)
#' with a dusty terracotta warm pole for diverging scales.
#'
#' @return A named character vector of hex codes.
#'
#' @examples
#' clerk_palette()
#' clerk_palette()[["header_bg"]]
#'
#' @export
clerk_palette <- function() {
  c(
    navy          = "#293681",
    mid_blue      = "#4274D9",
    light_teal    = "#95CCDD",
    near_white    = "#D0E7E6",
    terracotta    = "#D4907E",
    # Semantic aliases
    header_bg     = "#95CCDD",
    header_text   = "#293681",
    row_group_bg  = "#D0E7E6",
    body_text     = "#293681",
    positive      = "#293681",
    negative      = "#D4907E",
    neutral       = "#F0EEEC"
  )
}

#' Access a single clerkR colour by name
#'
#' @description
#' Convenience accessor for a single named colour from the clerkR palette.
#'
#' @param name Character string. One of the named entries in `clerk_palette()`.
#'
#' @return A single hex colour string.
#'
#' @examples
#' clerk_colour("navy")
#' clerk_colour("header_bg")
#'
#' @export
clerk_colour <- function(name) {
  pal <- clerk_palette()
  if (!name %in% names(pal)) {
    stop(
      sprintf(
        "'%s' is not a valid clerkR colour. Available names: %s",
        name,
        paste(names(pal), collapse = ", ")
      ),
      call. = FALSE
    )
  }
  unname(pal[[name]])
}

#' Build a clerkR diverging colour scale
#'
#' @description
#' Returns a vector of `n` hex colours interpolated along the clerkR diverging
#' scale: dusty terracotta (`#D4907E`) — neutral off-white (`#F0EEEC`) — navy
#' (`#293681`). Suitable for use with `gt::data_color()` or
#' `scales::col_numeric()`.
#'
#' @param n Integer. Number of colour steps (default `9`). Use an odd number to
#'   include the neutral midpoint.
#' @param reverse Logical. Reverse the scale direction (default `FALSE`,
#'   terracotta = low, navy = high).
#'
#' @return A character vector of `n` hex colour codes.
#'
#' @examples
#' clerk_diverging()
#' clerk_diverging(n = 5)
#' clerk_diverging(n = 11, reverse = TRUE)
#'
#' @export
clerk_diverging <- function(n = 9, reverse = FALSE) {
  ramp <- grDevices::colorRampPalette(
    c("#D4907E", "#F0EEEC", "#293681")
  )
  cols <- ramp(n)
  if (reverse) rev(cols) else cols
}

#' Build a clerkR sequential colour scale
#'
#' @description
#' Returns a vector of `n` hex colours interpolated along the clerkR sequential
#' scale: near-white (`#D0E7E6`) → navy (`#293681`). Suitable for shading
#' columns by magnitude (e.g. heritability h², correlation r).
#'
#' @param n Integer. Number of colour steps (default `7`).
#' @param reverse Logical. Reverse the scale direction (default `FALSE`,
#'   light = low, dark = high).
#'
#' @return A character vector of `n` hex colour codes.
#'
#' @examples
#' clerk_sequential()
#' clerk_sequential(n = 5, reverse = TRUE)
#'
#' @export
clerk_sequential <- function(n = 7, reverse = FALSE) {
  ramp <- grDevices::colorRampPalette(
    c("#D0E7E6", "#95CCDD", "#4274D9", "#293681")
  )
  cols <- ramp(n)
  if (reverse) rev(cols) else cols
}

#' Apply the clerkR gt theme to a gt table
#'
#' @description
#' Applies the clerkR visual style to an existing `gt_tbl` object: light teal
#' column headers with navy text, near-white row group bars, clean borders, and
#' consistent typography. Can be applied after any `gt` pipeline.
#'
#' This function is called automatically by `render_gt()` and `render_latex()`;
#' you only need it directly if you are building a `gt` table outside of the
#' `tbl_*` constructors.
#'
#' @param gt_tbl A `gt_tbl` object.
#'
#' @return A `gt_tbl` object with clerkR styling applied.
#'
#' @examples
#' \dontrun{
#' gt::gt(mtcars) |> clerk_theme()
#' }
#'
#' @export
clerk_theme <- function(gt_tbl) {

  pal <- clerk_palette()

  gt_tbl |>
    # --- Column header --------------------------------------------------------
    gt::tab_style(
      style = list(
        gt::cell_fill(color = pal[["header_bg"]]),
        gt::cell_text(color = pal[["header_text"]], weight = "bold")
      ),
      locations = gt::cells_column_labels()
    ) |>
    # --- Row group labels -----------------------------------------------------
    gt::tab_style(
      style = list(
        gt::cell_fill(color = pal[["row_group_bg"]]),
        gt::cell_text(color = pal[["body_text"]], weight = "bold")
      ),
      locations = gt::cells_row_groups()
    ) |>
    # --- Stub (row names) -----------------------------------------------------
    gt::tab_style(
      style = gt::cell_text(color = pal[["body_text"]], style = "italic"),
      locations = gt::cells_stub()
    ) |>
    # --- Body text ------------------------------------------------------------
    gt::tab_style(
      style = gt::cell_text(color = pal[["body_text"]]),
      locations = gt::cells_body()
    ) |>
    # --- Borders & options ----------------------------------------------------
    gt::tab_options(
      table.font.size                   = gt::px(12),
      heading.title.font.size           = gt::px(13),
      heading.subtitle.font.size        = gt::px(11),
      column_labels.border.top.style    = "solid",
      column_labels.border.top.color    = pal[["navy"]],
      column_labels.border.top.width    = gt::px(2),
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.color = pal[["navy"]],
      column_labels.border.bottom.width = gt::px(1),
      table.border.top.style            = "hidden",
      table.border.bottom.style         = "solid",
      table.border.bottom.color         = pal[["navy"]],
      table.border.bottom.width         = gt::px(1),
      row_group.border.top.style        = "hidden",
      row_group.border.bottom.style     = "hidden",
      stub.border.style                 = "hidden",
      data_row.padding                  = gt::px(4)
    )
}
