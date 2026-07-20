#' Render a clerk_tbl to its target output format
#'
#' @description
#' Dispatches to the correct renderer based on the `output` slot set at
#' construction time (`tbl_descriptive(..., output = "gt"|"html"|"latex")`).
#' All render arguments (`title`, `subtitle`, `footnote`) can be supplied here
#' and are forwarded to the underlying renderer.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string for the table title.
#' @param subtitle Optional character string for the table subtitle.
#' @param footnote Optional additional footnote text. Appended after any
#'   automatic footnotes (log-transform, FDR).
#' @param fdr_footnote Logical. Automatically add a source note explaining the
#'   FDR correction when a `p_fdr` column is present (default `TRUE`).
#' @param ... Passed to the underlying `render_gt()`, `render_reactable()`, or
#'   `render_latex()`.
#'
#' @return A `gt_tbl`, `htmltools::tagList`, or `knit_asis` object depending
#'   on the `output` slot of `x`.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex, output = "gt", fdr = TRUE) |>
#'   clerk_render(title = "Table 1")
#'
#' tbl_descriptive(clerk_example, group = sex, output = "html") |>
#'   clerk_render(title = "Sample characteristics")
#'
#' @importFrom utils stack
#' @importFrom rlang .data
#' @importFrom knitr asis_output
#' @importFrom reactable reactable
#' @export
clerk_render <- function(x, title = NULL, subtitle = NULL,
                         footnote = NULL, fdr_footnote = TRUE, ...) {
  UseMethod("clerk_render")
}

#' @export
clerk_render.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, fdr_footnote = TRUE, ...) {
  switch(
    x$output,
    gt    = render_gt(x,        title = title, subtitle = subtitle,
                                footnote = footnote,
                                fdr_footnote = fdr_footnote, ...),
    html  = render_reactable(x, title = title, subtitle = subtitle,
                                footnote = footnote, ...),
    latex = render_latex(x,     title = title, subtitle = subtitle,
                                footnote = footnote,
                                fdr_footnote = fdr_footnote, ...)
  )
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as a gt table (Word / PDF)
#'
#' @description
#' Renders a `clerk_tbl` as a `gt` table with clerkR styling applied via
#' `clerk_theme()`. Domain groupings become row-group labels; log-transformed
#' variables receive an automatic footnote; FDR-corrected tables receive an
#' automatic source note. Typically called indirectly via `clerk_render()`.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional table title.
#' @param subtitle Optional table subtitle.
#' @param footnote Optional additional footnote.
#' @param fdr_footnote Logical. Add an automatic FDR source note when a
#'   `p_fdr` column is present (default `TRUE`).
#' @param ... Reserved for future use.
#'
#' @return A `gt_tbl` object.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex) |>
#'   render_gt(title = "Table 1")
#'
#' @export
render_gt <- function(x, title = NULL, subtitle = NULL,
                      footnote = NULL, fdr_footnote = TRUE, ...) {
  UseMethod("render_gt")
}

#' @export
render_gt.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                footnote = NULL, fdr_footnote = TRUE, ...) {

  tbl          <- x$table
  domains      <- x$domains
  log_vars     <- x$log_vars
  domain_other <- x$domain_other %||% ""

  tbl        <- .attach_domains(tbl, domains, domain_other)
  col_labels <- .clerk_col_labels(names(tbl), x$group)

  gt_tbl <- tbl |>
    dplyr::group_by(.data[["domain"]]) |>
    gt::gt(rowname_col = "variable") |>
    gt::cols_label(.list = col_labels) |>
    gt::cols_hide("domain") |>
    clerk_theme()

  if (!is.null(title) || !is.null(subtitle))
    gt_tbl <- gt_tbl |> gt::tab_header(title = title, subtitle = subtitle)

  if (length(log_vars) > 0)
    gt_tbl <- gt_tbl |>
      gt::tab_footnote(
        footnote  = "Log-transformed variables shown on raw scale.",
        locations = gt::cells_stub(rows = log_vars)
      )

  if (isTRUE(fdr_footnote) && "p_fdr" %in% names(tbl))
    gt_tbl <- gt_tbl |>
      gt::tab_source_note(
        source_note = "p (FDR): Benjamini-Hochberg false discovery rate correction applied."
      )

  if (!is.null(footnote))
    gt_tbl <- gt_tbl |> gt::tab_source_note(source_note = footnote)

  gt_tbl
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as a LaTeX table
#'
#' @description
#' Renders a `clerk_tbl` as a LaTeX table via `gt::as_latex()`. Typically
#' called indirectly via `clerk_render()`.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional table title (used as the `\caption{}`).
#' @param subtitle Optional subtitle appended to the caption.
#' @param footnote Optional additional footnote.
#' @param fdr_footnote Logical. Add an automatic FDR source note (default
#'   `TRUE`).
#' @param ... Reserved for future use.
#'
#' @return A `knit_asis` character object containing the LaTeX table source.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex, output = "latex") |>
#'   clerk_render(title = "Sample characteristics by sex")
#'
#' @export
render_latex <- function(x, title = NULL, subtitle = NULL,
                         footnote = NULL, fdr_footnote = TRUE, ...) {
  UseMethod("render_latex")
}

#' @export
render_latex.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, fdr_footnote = TRUE, ...) {
  gt_tbl    <- render_gt(x, title = title, subtitle = subtitle,
                         footnote = footnote, fdr_footnote = fdr_footnote)
  latex_out <- gt::as_latex(gt_tbl)
  knitr::asis_output(as.character(latex_out))
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as an interactive HTML table
#'
#' @description
#' Renders a `clerk_tbl` as a `reactable` interactive HTML table with optional
#' title and subtitle rendered above the widget. Typically called indirectly
#' via `clerk_render()`.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string displayed as a heading above the
#'   table.
#' @param subtitle Optional character string displayed as a subheading.
#' @param footnote Optional character string displayed as a note below the
#'   table.
#' @param ... Passed to `reactable::reactable()`.
#'
#' @return An `htmltools::tagList` containing the title, reactable widget, and
#'   optional footnote, or a bare `reactable` if no title/subtitle/footnote
#'   are provided.
#'
#' @examples
#' tbl_correlation(clerk_cor_example, output = "html") |>
#'   clerk_render(title = "Partial correlations", subtitle = "age + sex controlled")
#'
#' @importFrom htmltools tagList tags
#' @export
render_reactable <- function(x, title = NULL, subtitle = NULL,
                             footnote = NULL, ...) {
  UseMethod("render_reactable")
}

#' @export
render_reactable.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                       footnote = NULL, ...) {
  domain_other <- x$domain_other %||% ""
  tbl          <- .attach_domains(x$table, x$domains, domain_other)

  widget <- reactable::reactable(
    tbl,
    groupBy    = if (length(x$domains) > 0) "domain" else NULL,
    searchable = TRUE,
    striped    = TRUE,
    highlight  = TRUE,
    bordered   = FALSE,
    compact    = TRUE,
    ...
  )

  has_chrome <- !is.null(title) || !is.null(subtitle) || !is.null(footnote)
  if (!has_chrome) return(widget)

  htmltools::tagList(
    if (!is.null(title))
      htmltools::tags$p(
        style = paste0(
          "font-size:14px; font-weight:600; color:#293681;",
          "margin:0 0 2px 0; font-family:'DM Sans',sans-serif;"
        ),
        title
      ),
    if (!is.null(subtitle))
      htmltools::tags$p(
        style = paste0(
          "font-size:12px; color:#4274D9;",
          "margin:0 0 8px 0; font-family:'DM Sans',sans-serif;"
        ),
        subtitle
      ),
    widget,
    if (!is.null(footnote))
      htmltools::tags$p(
        style = paste0(
          "font-size:11px; color:#888; margin:4px 0 0 0;",
          "font-family:'DM Sans',sans-serif;"
        ),
        footnote
      )
  )
}

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------

#' @keywords internal
.attach_domains <- function(tbl, domains, domain_other = "") {
  if (length(domains) > 0) {
    domain_map <- utils::stack(lapply(domains, function(v) v))
    names(domain_map) <- c("variable", "domain")
    tbl <- dplyr::left_join(tbl, domain_map, by = "variable")
    tbl[["domain"]][is.na(tbl[["domain"]])] <- domain_other
  } else {
    tbl[["domain"]] <- rep(domain_other, nrow(tbl))
  }
  tbl
}

#' @keywords internal
.clerk_col_labels <- function(nms, group_nm) {
  fixed <- list(
    variable  = "Variable",
    n         = "n",
    overall   = "Overall",
    summary   = "Summary",
    statistic = "Statistic",
    p         = "p",
    p_fdr     = "p (FDR)",
    r         = "r",
    outcome   = "Outcome",
    beta      = "\u03b2",
    se        = "SE",
    ci        = "95% CI",
    ci_95     = "95% CI",
    h2        = "h\u00b2",
    sigma2_a  = "\u03c3\u00b2a",
    sigma2_e  = "\u03c3\u00b2e"
  )
  fixed[intersect(names(fixed), nms)]
}
