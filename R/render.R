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
#' @param footnote Optional additional footnote text.
#' @param ... Passed to the underlying `render_gt()`, `render_reactable()`, or
#'   `render_latex()`.
#'
#' @return A `gt_tbl`, `reactable`, or `knit_asis` object depending on the
#'   `output` slot of `x`.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex, output = "gt") |>
#'   clerk_render(title = "Table 1")
#'
#' tbl_descriptive(clerk_example, group = sex, output = "html") |>
#'   clerk_render()
#'
#' @importFrom utils stack
#' @importFrom rlang .data
#' @importFrom knitr asis_output
#' @importFrom reactable reactable
#' @export
clerk_render <- function(x, title = NULL, subtitle = NULL,
                         footnote = NULL, ...) {
  UseMethod("clerk_render")
}

#' @export
clerk_render.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, ...) {
  switch(
    x$output,
    gt    = render_gt(x,        title = title, subtitle = subtitle,
                                footnote = footnote, ...),
    html  = render_reactable(x, title = title, ...),
    latex = render_latex(x,     title = title, subtitle = subtitle,
                                footnote = footnote, ...)
  )
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as a gt table (Word / PDF)
#'
#' @description
#' Renders a `clerk_tbl` as a `gt` table with clerkR styling applied via
#' `clerk_theme()`. Domain groupings become row-group labels; log-transformed
#' variables receive an automatic footnote. Typically called indirectly via
#' `clerk_render()`.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional table title.
#' @param subtitle Optional table subtitle.
#' @param footnote Optional additional footnote.
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
                      footnote = NULL, ...) {
  UseMethod("render_gt")
}

#' @export
render_gt.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                footnote = NULL, ...) {

  tbl      <- x$table
  domains  <- x$domains
  log_vars <- x$log_vars

  tbl <- .attach_domains(tbl, domains)
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
                         footnote = NULL, ...) {
  UseMethod("render_latex")
}

#' @export
render_latex.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, ...) {
  gt_tbl    <- render_gt(x, title = title, subtitle = subtitle,
                         footnote = footnote)
  latex_out <- gt::as_latex(gt_tbl)
  knitr::asis_output(as.character(latex_out))
}

# ------------------------------------------------------------------------------

#' Render a clerk_tbl as an interactive HTML table
#'
#' @description
#' Renders a `clerk_tbl` as a `reactable` interactive HTML table. Typically
#' called indirectly via `clerk_render()`.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string displayed above the table.
#' @param ... Passed to `reactable::reactable()`.
#'
#' @return A `reactable` htmlwidget.
#'
#' @examples
#' tbl_descriptive(clerk_example, group = sex, output = "html") |>
#'   clerk_render()
#'
#' @export
render_reactable <- function(x, title = NULL, ...) {
  UseMethod("render_reactable")
}

#' @export
render_reactable.clerk_tbl <- function(x, title = NULL, ...) {
  reactable::reactable(
    x$table,
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
.attach_domains <- function(tbl, domains) {
  if (length(domains) > 0) {
    domain_map <- utils::stack(lapply(domains, function(v) v))
    names(domain_map) <- c("variable", "domain")
    tbl <- dplyr::left_join(tbl, domain_map, by = "variable")
    tbl[["domain"]][is.na(tbl[["domain"]])] <- "Other"
  } else {
    tbl[["domain"]] <- "All variables"
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
