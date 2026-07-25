#' Render a clerk_tbl to its target output format
#'
#' @description
#' Dispatches to the correct renderer based on the `output` slot set at
#' construction time (`tbl_descriptive(..., output = "gt"|"html"|"latex")`).
#' All render arguments (`title`, `subtitle`, `footnote`, `footnotes`) can be
#' supplied here and are forwarded to the underlying renderer.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string for the table title.
#' @param subtitle Optional character string for the table subtitle.
#' @param footnote Optional character vector of blanket footnote text,
#'   rendered as one source note per element, below the table. Appended
#'   after any automatic footnotes (log-transform, FDR).
#' @param footnotes Optional list of targeted footnotes, each attached to
#'   specific rows or columns rather than the whole table. Each element is a
#'   list with a `text` string and either a `rows` (variable names, matched
#'   against the table stub) or `cols` (column names) character vector. See
#'   `vignette("formatting-options")` for examples.
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
#' @importFrom rlang .data
#' @importFrom knitr asis_output
#' @importFrom reactable reactable
#' @export
clerk_render <- function(x, title = NULL, subtitle = NULL,
                         footnote = NULL, footnotes = NULL,
                         fdr_footnote = TRUE, ...) {
  UseMethod("clerk_render")
}

#' @export
clerk_render.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, footnotes = NULL,
                                   fdr_footnote = TRUE, ...) {
  switch(
    x$output,
    gt    = render_gt(x,        title = title, subtitle = subtitle,
                                footnote = footnote, footnotes = footnotes,
                                fdr_footnote = fdr_footnote, ...),
    html  = render_reactable(x, title = title, subtitle = subtitle,
                                footnote = footnote, footnotes = footnotes, ...),
    latex = render_latex(x,     title = title, subtitle = subtitle,
                                footnote = footnote, footnotes = footnotes,
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
#' Domains may be nested (a named list of named lists) to express
#' sub-sections within a domain, e.g. repeated timepoints within a
#' "Mental health" domain. `gt` itself has no native support for two-level
#' row-group headers, so a nested domain renders as a single compound row
#' group: the domain and subdomain names joined with an em dash, e.g.
#' `"Mental health"` + `"Baseline"` becomes one row group labelled
#' `Mental health - Baseline` (rendered with a true em dash, not a hyphen).
#' For a table with true expandable nested groups, use `output = "html"`
#' instead (see `render_reactable()`).
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional table title.
#' @param subtitle Optional table subtitle.
#' @param footnote Optional character vector of blanket footnotes, one source
#'   note per element.
#' @param footnotes Optional list of targeted footnotes. Each element is a
#'   list with `text` and either `rows` (variable names) or `cols` (column
#'   names).
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
                      footnote = NULL, footnotes = NULL,
                      fdr_footnote = TRUE, ...) {
  UseMethod("render_gt")
}

#' @export
render_gt.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                footnote = NULL, footnotes = NULL,
                                fdr_footnote = TRUE, ...) {

  tbl          <- x$table
  domains      <- x$domains
  log_vars     <- x$log_vars
  domain_other <- x$domain_other %||% ""

  tbl        <- .attach_domains(tbl, domains, domain_other)
  col_labels <- .clerk_col_labels(names(tbl), x$group)

  gt_tbl <- tbl |>
    dplyr::group_by(.data[["domain_group"]]) |>
    gt::gt(rowname_col = "variable") |>
    gt::cols_label(.list = col_labels) |>
    gt::cols_hide(c("domain", "subdomain", "domain_group")) |>
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
    for (fn in footnote)
      gt_tbl <- gt_tbl |> gt::tab_source_note(source_note = fn)

  if (!is.null(footnotes))
    gt_tbl <- .apply_footnotes(gt_tbl, footnotes)

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
#' @param footnote Optional character vector of blanket footnotes.
#' @param footnotes Optional list of targeted footnotes (see `render_gt()`).
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
                         footnote = NULL, footnotes = NULL,
                         fdr_footnote = TRUE, ...) {
  UseMethod("render_latex")
}

#' @export
render_latex.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                   footnote = NULL, footnotes = NULL,
                                   fdr_footnote = TRUE, ...) {
  gt_tbl    <- render_gt(x, title = title, subtitle = subtitle,
                         footnote = footnote, footnotes = footnotes,
                         fdr_footnote = fdr_footnote)
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
#' Unlike `render_gt()`, nested domains (a named list of named lists) render
#' as genuine two-level expandable/collapsible row groups here, via
#' `reactable`'s `groupBy = c("domain", "subdomain")` -- this is the one
#' output format where nested domains show as an actual hierarchy rather than
#' a compound label.
#'
#' @param x A `clerk_tbl` object.
#' @param title Optional character string displayed as a heading above the
#'   table.
#' @param subtitle Optional character string displayed as a subheading.
#' @param footnote Optional character vector of blanket footnote text,
#'   displayed as a note list below the table.
#' @param footnotes Optional list of targeted footnotes (see `render_gt()`).
#'   `reactable` has no per-cell footnote-marker equivalent, so these are
#'   displayed alongside `footnote` as plain note text rather than attached
#'   to specific rows/columns.
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
                             footnote = NULL, footnotes = NULL, ...) {
  UseMethod("render_reactable")
}

#' @export
render_reactable.clerk_tbl <- function(x, title = NULL, subtitle = NULL,
                                       footnote = NULL, footnotes = NULL, ...) {
  domain_other <- x$domain_other %||% ""
  tbl          <- .attach_domains(x$table, x$domains, domain_other)
  nested       <- .has_nested_domains(x$domains)

  widget <- reactable::reactable(
    tbl,
    groupBy    = if (nested) c("domain", "subdomain")
                 else if (length(x$domains) > 0) "domain"
                 else NULL,
    searchable = TRUE,
    striped    = TRUE,
    highlight  = TRUE,
    bordered   = FALSE,
    compact    = TRUE,
    ...
  )

  note_lines <- c(footnote, vapply(footnotes, function(f) f$text, character(1)))

  has_chrome <- !is.null(title) || !is.null(subtitle) || length(note_lines) > 0
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
    if (length(note_lines) > 0)
      htmltools::tags$div(
        style = "margin:4px 0 0 0;",
        lapply(note_lines, function(nl)
          htmltools::tags$p(
            style = paste0(
              "font-size:11px; color:#888; margin:0;",
              "font-family:'DM Sans',sans-serif;"
            ),
            nl
          )
        )
      )
  )
}

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------

#' @keywords internal
#' @noRd
.has_nested_domains <- function(domains) {
  length(domains) > 0 && any(vapply(domains, is.list, logical(1)))
}

#' Attach domain (and, for nested domains, subdomain) columns to a table.
#'
#' `domains` accepts two shapes, and the two can be mixed within one list:
#'   - flat:   list("Metabolic" = c("hdl", "glucose"))
#'   - nested: list("Mental health" = list("Baseline"   = c("bdi_bl", ...),
#'                                         "Follow-up 1" = c("bdi_fu1", ...)))
#' A flat entry gets subdomain = "". A nested entry's subdomain is the name
#' of its inner list element. `domain_group` is the compound label used as
#' gt's single row-group column -- the domain and subdomain names joined
#' with an em dash when there's a subdomain, or just the domain name when
#' there isn't. reactable ignores `domain_group` and groups on
#' domain/subdomain directly for true nesting.
#' Both `domain` and `domain_group` are returned as factors with levels in
#' the order variables were supplied in `domains`, so row-group order in the
#' rendered table always matches the order the user wrote them in, rather
#' than falling back to alphabetical.
#' @keywords internal
.attach_domains <- function(tbl, domains, domain_other = "") {
  if (length(domains) == 0) {
    tbl[["domain"]]       <- rep(domain_other, nrow(tbl))
    tbl[["subdomain"]]    <- rep("", nrow(tbl))
    tbl[["domain_group"]] <- tbl[["domain"]]
    return(tbl)
  }

  rows        <- list()
  group_order <- character(0)

  for (dname in names(domains)) {
    entry <- domains[[dname]]
    if (is.list(entry)) {
      for (sname in names(entry)) {
        vars  <- entry[[sname]]
        group <- paste0(dname, " \u2014 ", sname)
        rows[[length(rows) + 1]] <- data.frame(
          variable = vars, domain = dname, subdomain = sname,
          domain_group = group, stringsAsFactors = FALSE
        )
        group_order <- c(group_order, group)
      }
    } else {
      rows[[length(rows) + 1]] <- data.frame(
        variable = entry, domain = dname, subdomain = "",
        domain_group = dname, stringsAsFactors = FALSE
      )
      group_order <- c(group_order, dname)
    }
  }

  domain_map <- dplyr::bind_rows(rows)
  tbl        <- dplyr::left_join(tbl, domain_map, by = "variable")

  tbl[["domain"]][is.na(tbl[["domain"]])]             <- domain_other
  tbl[["subdomain"]][is.na(tbl[["subdomain"]])]       <- ""
  tbl[["domain_group"]][is.na(tbl[["domain_group"]])] <- domain_other

  group_order <- unique(c(group_order, domain_other))
  tbl[["domain_group"]] <- factor(tbl[["domain_group"]], levels = group_order)
  tbl[["domain"]]       <- factor(tbl[["domain"]],
                                  levels = unique(c(names(domains), domain_other)))

  # gt (and, to a lesser extent, reactable) display row groups in the order
  # they first appear in the data, not necessarily in factor-level order --
  # so the rows themselves need physically reordering to match the order
  # `domains` was written in, not just the labels. arrange() on a factor
  # sorts by level code but is a stable sort, so within-group row order
  # (e.g. the order variables were listed within one domain/subdomain) is
  # preserved.
  tbl <- dplyr::arrange(tbl, .data[["domain_group"]])

  tbl
}

#' Attach targeted (row- or column-specific) footnotes to a gt table.
#' @keywords internal
.apply_footnotes <- function(gt_tbl, footnotes) {
  for (f in footnotes) {
    loc <- if (!is.null(f$rows)) {
      gt::cells_stub(rows = f$rows)
    } else if (!is.null(f$cols)) {
      gt::cells_column_labels(columns = dplyr::all_of(f$cols))
    } else {
      NULL
    }
    if (!is.null(loc))
      gt_tbl <- gt_tbl |> gt::tab_footnote(footnote = f$text, locations = loc)
  }
  gt_tbl
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
