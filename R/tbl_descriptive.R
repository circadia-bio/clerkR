#' Descriptive summary table with group comparisons (Table 1)
#'
#' @description
#' Produces a descriptive/Table 1-style summary of a data frame, with optional
#' group comparisons. Formatting defaults are inherited from `clerk_options()`.
#'
#' @param data A data frame.
#' @param group <[`tidy-select`][dplyr::dplyr_tidy_select]> Grouping variable.
#' @param vars <[`tidy-select`][dplyr::dplyr_tidy_select]> Variables to
#'   include. Defaults to all columns except `group`.
#' @param domains A named list mapping variable names to domain/section labels.
#' @param log_vars Character vector of log-transformed variable names.
#' @param digits Integer. Decimal places for continuous variables.
#' @param p_digits Integer. Decimal places for p-values.
#' @param p_style Character. P-value style (`"apa"`, `"plain"`, `"stars"`,
#'   `"stars_p"`).
#' @param stars Logical. Append significance stars.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_ns Logical. Replace non-surviving FDR p-values with `"ns"`.
#' @param fdr_alpha Numeric. Alpha level for FDR survival (BH-adjusted p).
#' @param domain_other Character string. Label for variables not assigned to
#'   any domain, and for all variables when `domains = list()`. Default `""`
#'   (blank — no section header). Inherits from `clerk_options()$domain_other`.
#' @param overall Logical. Include an overall column (default `TRUE`).
#' @param output Character string. One of `"gt"`, `"html"`, or `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"descriptive"`.
#'
#' @examples
#' tbl_descriptive(
#'   clerk_example,
#'   group   = sex,
#'   domains = list(
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
                            group        = NULL,
                            vars         = NULL,
                            domains      = list(),
                            log_vars     = character(0),
                            digits       = NULL,
                            p_digits     = NULL,
                            p_style      = NULL,
                            stars        = NULL,
                            fdr          = FALSE,
                            fdr_ns       = NULL,
                            fdr_alpha    = NULL,
                            domain_other = NULL,
                            overall      = TRUE,
                            output       = c("gt", "html", "latex")) {

  output    <- match.arg(output)
  group_var <- rlang::enquo(group)
  group_nm  <- if (!rlang::quo_is_null(group_var))
    rlang::as_name(group_var) else NULL

  opts             <- .get_clerk_options()
  fdr_ns_val       <- if (!is.null(fdr_ns)) fdr_ns else isTRUE(opts$fdr_ns)
  fdr_alpha_val    <- fdr_alpha    %||% opts$fdr_alpha
  fdr_label        <- opts$fdr_ns_label
  domain_other_val <- domain_other %||% opts$domain_other

  if (rlang::quo_is_null(rlang::enquo(vars))) {
    var_nms <- setdiff(names(data), group_nm)
  } else {
    var_nms <- names(dplyr::select(data, {{ vars }}))
  }

  is_cat <- vapply(data[var_nms], function(x)
    is.factor(x) || is.character(x) || is.logical(x), logical(1))

  rows <- lapply(var_nms, function(v) {
    .summarise_var(
      x = data[[v]], name = v,
      group = if (!is.null(group_nm)) data[[group_nm]] else NULL,
      is_cat = is_cat[[v]], digits = digits, p_digits = p_digits,
      p_style = p_style, stars = stars, overall = overall
    )
  })

  tbl <- dplyr::bind_rows(rows)

  if (fdr && !is.null(group_nm) && "p_raw" %in% names(tbl)) {
    p_fdr_raw <- stats::p.adjust(tbl[["p_raw"]], method = "BH")
    p_fdr_fmt <- .fmt_p(p_fdr_raw, p_digits = p_digits, p_style = p_style,
                        stars = stars)
    if (fdr_ns_val)
      p_fdr_fmt <- ifelse(!is.na(p_fdr_raw) & p_fdr_raw >= fdr_alpha_val,
                          fdr_label, p_fdr_fmt)
    tbl[["p_fdr"]] <- p_fdr_fmt
  }

  tbl[["p_raw"]] <- NULL

  structure(
    list(table = tbl, domains = domains, log_vars = log_vars,
         type = "descriptive", group = group_nm,
         domain_other = domain_other_val, output = output),
    class = "clerk_tbl"
  )
}

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------

#' @keywords internal
.summarise_var <- function(x, name, group, is_cat, digits, p_digits,
                           p_style, stars, overall) {

  fmt_mean_sd <- function(v) {
    paste0(.fmt_stat(mean(v, na.rm = TRUE), digits), " \u00b1 ",
           .fmt_stat(stats::sd(v, na.rm = TRUE), digits))
  }

  fmt_n_pct <- function(v) {
    tab <- table(v, useNA = "no")
    paste(paste0(names(tab), ": ", tab,
                 " (", round(tab / sum(tab) * 100, 1), "%)"),
          collapse = "; ")
  }

  n_obs <- sum(!is.na(x))
  overall_str <- if (is_cat) fmt_n_pct(x) else fmt_mean_sd(x)
  stat_str <- NA_character_; p_raw <- NA_real_; p_fmt <- NA_character_

  if (!is.null(group)) {
    grp_levels <- levels(factor(group))
    grp_strs <- vapply(grp_levels, function(g) {
      xg <- x[group == g]
      if (is_cat) fmt_n_pct(xg) else fmt_mean_sd(xg)
    }, character(1))

    if (is_cat) {
      ct <- tryCatch(stats::chisq.test(table(x, group)), error = function(e) NULL)
      if (!is.null(ct)) {
        stat_str <- sprintf("chi2 = %.2f", ct$statistic)
        p_raw    <- ct$p.value
        p_fmt    <- .fmt_p(p_raw, p_digits = p_digits, p_style = p_style,
                           stars = stars)
      }
    } else {
      if (length(grp_levels) == 2) {
        tt <- tryCatch(
          stats::t.test(x[group == grp_levels[1]], x[group == grp_levels[2]]),
          error = function(e) NULL)
        if (!is.null(tt)) {
          stat_str <- sprintf("t = %.2f", tt$statistic)
          p_raw    <- tt$p.value
          p_fmt    <- .fmt_p(p_raw, p_digits = p_digits, p_style = p_style,
                             stars = stars)
        }
      } else {
        av <- tryCatch(stats::oneway.test(x ~ factor(group)),
                       error = function(e) NULL)
        if (!is.null(av)) {
          stat_str <- sprintf("F = %.2f", av$statistic)
          p_raw    <- av$p.value
          p_fmt    <- .fmt_p(p_raw, p_digits = p_digits, p_style = p_style,
                             stars = stars)
        }
      }
    }

    out <- data.frame(variable = name, n = n_obs, stringsAsFactors = FALSE)
    if (overall) out[["overall"]] <- overall_str
    for (g in grp_levels) out[[g]] <- grp_strs[[g]]
    out[["statistic"]] <- stat_str
    out[["p_raw"]]     <- p_raw
    out[["p"]]         <- p_fmt
  } else {
    out <- data.frame(variable = name, n = n_obs, overall = overall_str,
                      stringsAsFactors = FALSE)
  }
  out
}
