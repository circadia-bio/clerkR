#' Render a clerk_tbl as a gt table
#'
#' @description
#' Renders a `clerk_tbl` object as a `gt` table suitable for Word or PDF
#' export. Domain groupings are rendered as row group labels; log-transformed
#' variables receive an automatic footnote.
#'
#' @param x A `clerk_tbl` object produced by any `tbl_*` constructor.
#' @param title Optional character string for the table title.
#' @param subtitle Optional character string for the table subtitle.
#' @param footnote Optional additional footnote appended after any
#'   auto-generated notes.
#' @param ... Reserved for future use.
#'
#' @return A `gt_tbl` object.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex) |> render_gt(title = "Table 1")
#'
#' @importFrom utils stack
#' @importFrom rlang .data
#' @export
render_gt <- function(x, title = NULL, subtitle = NULL, footnote = NULL, ...) {
  UseMethod("render_gt")
}

#' @export
render_gt.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                footnote = NULL, ...) {

  tbl      <- x$table
  domains  <- x$domains
  log_vars <- x$log_vars

  # --- Attach domain labels ---------------------------------------------------
  if (length(domains) > 0) {
    domain_map <- utils::stack(lapply(domains, function(v) v))
    names(domain_map) <- c("variable", "domain")
    tbl <- dplyr::left_join(tbl, domain_map, by = "variable")
    tbl[["domain"]][is.na(tbl[["domain"]])] <- "Other"
  } else {
    tbl[["domain"]] <- "All variables"
  }

  # --- Pretty column labels ---------------------------------------------------
  col_labels <- .clerk_col_labels(names(tbl), x$group)

  # --- Build gt ---------------------------------------------------------------
  gt_tbl <- tbl |>
    dplyr::group_by(.data[["domain"]]) |>
    gt::gt(rowname_col = "variable") |>
    gt::cols_label(.list = col_labels) |>
    gt::tab_style(
      style     = gt::cell_text(weight = "bold"),
      locations = gt::cells_row_groups()
    ) |>
    gt::tab_style(
      style     = gt::cell_text(style = "italic"),
      locations = gt::cells_stub()
    ) |>
    gt::tab_options(
      table.font.size                   = gt::px(12),
      heading.title.font.size           = gt::px(13),
      row_group.font.weight             = "bold",
      column_labels.font.weight         = "bold",
      table.border.top.style            = "solid",
      table.border.bottom.style         = "solid",
      column_labels.border.bottom.style = "solid"
    ) |>
    gt::cols_hide("domain")

  # --- Title / subtitle -------------------------------------------------------
  if (!is.null(title) || !is.null(subtitle)) {
    gt_tbl <- gt_tbl |> gt::tab_header(title = title, subtitle = subtitle)
  }

  # --- Log-transform footnote -------------------------------------------------
  if (length(log_vars) > 0) {
    gt_tbl <- gt_tbl |>
      gt::tab_footnote(
        footnote  = "Log-transformed variables shown on raw scale.",
        locations = gt::cells_stub(rows = log_vars)
      )
  }

  # --- User footnote ----------------------------------------------------------
  if (!is.null(footnote)) {
    gt_tbl <- gt_tbl |> gt::tab_source_note(source_note = footnote)
  }

  gt_tbl
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as a reactable table
#'
#' @description
#' Renders a `clerk_tbl` object as a `reactable` interactive HTML table.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string displayed above the table.
#' @param ... Passed to `reactable::reactable()`.
#'
#' @return A `reactable` htmlwidget.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex) |> render_reactable()
#'
#' @export
render_reactable <- function(x, title = NULL, ...) {
  UseMethod("render_reactable")
}

#' @export
render_reactable.clerk_tbl <- function(x, title = NULL, ...) {

  tbl <- x$table

  reactable::reactable(
    tbl,
    groupBy    = if (length(x$domains) > 0) "domain" else NULL,
    searchable = TRUE,
    striped    = TRUE,
    highlight  = TRUE,
    bordered   = FALSE,
    compact    = TRUE,
    ...
  )
}

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------

#' @keywords internal
.clerk_col_labels <- function(nms, group_nm) {
  fixed <- list(
    variable  = "Variable",
    n         = "n",
    overall   = "Overall",
    statistic = "Statistic",
    p         = "p",
    p_fdr     = "p (FDR)"
  )
  fixed[intersect(names(fixed), nms)]
}
