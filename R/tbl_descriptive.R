#' Descriptive summary table with group comparisons (Table 1)
#'
#' @description
#' Produces a descriptive/Table 1-style summary of a data frame, with optional
#' group comparisons. Continuous variables are summarised as mean ± SD and
#' compared with an independent-samples t-test (two groups) or one-way ANOVA
#' (three or more groups). Categorical variables are summarised as n (%) and
#' compared with a chi-squared test.
#'
#' @param data A data frame.
#' @param group <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the grouping variable. If `NULL` (default) the overall sample is
#'   summarised without a comparison column.
#' @param vars <[`tidy-select`][dplyr::dplyr_tidy_select]> Variables to
#'   include. Defaults to all columns except `group`.
#' @param domains A named list mapping variable names to domain/section labels,
#'   e.g. `list("Metabolic" = c("hdl", "glucose"), "Anthropometric" =
#'   c("bmi", "waist"))`. Variables not mentioned are placed in an "Other"
#'   section.
#' @param log_vars Character vector of variable names that were log-transformed
#'   prior to analysis. A footnote is appended noting that values are shown on
#'   the raw scale.
#' @param digits Integer. Number of decimal places for continuous variables
#'   (default `2`).
#' @param p_digits Integer. Number of decimal places for p-values (default
#'   `3`).
#' @param fdr Logical. Apply BH FDR correction to p-values across all tests
#'   (default `FALSE`).
#' @param overall Logical. Include an overall (ungrouped) column alongside
#'   group columns (default `TRUE`).
#' @param output Character string specifying the render target. One of
#'   `"gt"` (default, for Word/PDF via `gt`), `"html"` (interactive
#'   `reactable`), or `"latex"` (LaTeX via `gt::as_latex()`). This value is
#'   stored on the returned object and used by `clerk_render()` to dispatch to
#'   the correct renderer automatically.
#'
#' @return A `clerk_tbl` object (a list with class `"clerk_tbl"`) containing:
#'   \describe{
#'     \item{`table`}{A data frame with one row per variable.}
#'     \item{`domains`}{The domain list supplied by the user.}
#'     \item{`log_vars`}{The log-transformed variable names.}
#'     \item{`type`}{Character string `"descriptive"`.}
#'     \item{`group`}{Name of the grouping variable, or `NULL`.}
#'     \item{`output`}{The render target: `"gt"`, `"html"`, or `"latex"`.}
#'   }
#'
#' @examples
#' tbl_descriptive(
#'   clerk_example,
#'   group    = sex,
#'   domains  = list(
#'     "Metabolic"    = c("hdl", "glucose", "bmi"),
#'     "Cognitive"    = c("tmt_time", "verbal_fluency"),
#'     "Mental health"= c("bdi", "panas_neg")
#'   ),
#'   log_vars = "tmt_time",
#'   output   = "gt"
#' ) |> clerk_render(title = "Table 1. Sample characteristics by sex")
#'
#' @export
tbl_descriptive <- function(data,
                            group    = NULL,
                            vars     = NULL,
                            domains  = list(),
                            log_vars = character(0),
                            digits   = 2,
                            p_digits = 3,
                            fdr      = FALSE,
                            overall  = TRUE,
                            output   = c("gt", "html", "latex")) {

  output <- match.arg(output)

  group_var <- rlang::enquo(group)
  group_nm  <- if (!rlang::quo_is_null(group_var))
    rlang::as_name(group_var) else NULL

  if (rlang::quo_is_null(rlang::enquo(vars))) {
    var_nms <- setdiff(names(data), group_nm)
  } else {
    var_nms <- names(dplyr::select(data, {{ vars }}))
  }

  is_cat <- vapply(data[var_nms], function(x)
    is.factor(x) || is.character(x) || is.logical(x), logical(1))

  rows <- lapply(var_nms, function(v) {
    .summarise_var(
      x        = data[[v]],
      name     = v,
      group    = if (!is.null(group_nm)) data[[group_nm]] else NULL,
      is_cat   = is_cat[[v]],
      digits   = digits,
      p_digits = p_digits,
      overall  = overall
    )
  })

  tbl <- dplyr::bind_rows(rows)

  if (fdr && !is.null(group_nm) && "p" %in% names(tbl)) {
    tbl$p_fdr <- stats::p.adjust(tbl$p, method = "BH")
  }

  structure(
    list(
      table    = tbl,
      domains  = domains,
      log_vars = log_vars,
      type     = "descriptive",
      group    = group_nm,
      output   = output
    ),
    class = "clerk_tbl"
  )
}

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------

#' @keywords internal
.summarise_var <- function(x, name, group, is_cat, digits, p_digits, overall) {

  fmt_mean_sd <- function(v, d) {
    m <- mean(v, na.rm = TRUE)
    s <- stats::sd(v, na.rm = TRUE)
    sprintf(paste0("%.", d, "f \u00b1 %.", d, "f"), m, s)
  }

  fmt_n_pct <- function(v) {
    tab <- table(v, useNA = "no")
    paste(
      paste0(names(tab), ": ", tab,
             " (", round(tab / sum(tab) * 100, 1), "%)"),
      collapse = "; "
    )
  }

  n_obs       <- sum(!is.na(x))
  overall_str <- if (is_cat) fmt_n_pct(x) else fmt_mean_sd(x, digits)
  stat_str    <- NA_character_
  p_val       <- NA_real_

  if (!is.null(group)) {
    grp_levels <- levels(factor(group))
    grp_strs <- vapply(grp_levels, function(g) {
      xg <- x[group == g]
      if (is_cat) fmt_n_pct(xg) else fmt_mean_sd(xg, digits)
    }, character(1))

    if (is_cat) {
      ct <- tryCatch(stats::chisq.test(table(x, group)), error = function(e) NULL)
      if (!is.null(ct)) {
        stat_str <- sprintf("chi2 = %.2f", ct$statistic)
        p_val    <- ct$p.value
      }
    } else {
      if (length(grp_levels) == 2) {
        g1 <- x[group == grp_levels[1]]
        g2 <- x[group == grp_levels[2]]
        tt <- tryCatch(stats::t.test(g1, g2), error = function(e) NULL)
        if (!is.null(tt)) {
          stat_str <- sprintf("t = %.2f", tt$statistic)
          p_val    <- tt$p.value
        }
      } else {
        av <- tryCatch(
          stats::oneway.test(x ~ factor(group)), error = function(e) NULL
        )
        if (!is.null(av)) {
          stat_str <- sprintf("F = %.2f", av$statistic)
          p_val    <- av$p.value
        }
      }
    }

    out <- data.frame(variable = name, n = n_obs, stringsAsFactors = FALSE)
    if (overall) out$overall <- overall_str
    for (g in grp_levels) out[[g]] <- grp_strs[[g]]
    out$statistic <- stat_str
    out$p         <- p_val

  } else {
    out <- data.frame(
      variable = name, n = n_obs, overall = overall_str,
      stringsAsFactors = FALSE
    )
  }

  out
}
