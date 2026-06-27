#' Regression coefficients table
#'
#' @description
#' Formats a tidy data frame of regression results into a publication-ready
#' table. Accepts `broom::tidy()` output directly. Formatting defaults
#' inherited from `clerk_options()`.
#'
#' @param data A tidy data frame of regression results.
#' @param term Character string. Model term column. Default `"term"`.
#' @param estimate Character string. Coefficient column. Default `"estimate"`.
#' @param std_error Character string. SE column. Default `"std.error"`.
#' @param conf_low Character string. Lower CI column. Default `"conf.low"`.
#' @param conf_high Character string. Upper CI column. Default `"conf.high"`.
#' @param p Character string. P-value column. Default `"p.value"`.
#' @param model Character string or `NULL`. Multiple-model column.
#' @param domains A named list mapping term names to domain/section labels.
#' @param exponentiate Logical. Exponentiate estimates and CIs (default
#'   `FALSE`).
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column to group FDR within.
#' @param ci_sep Character string separating CI bounds (default `", "`).
#' @param digits Integer. Decimal places for estimates.
#' @param p_digits Integer. Decimal places for p-values.
#' @param p_style Character. P-value style.
#' @param stars Logical. Append significance stars.
#' @param fdr_ns Logical. Replace non-surviving FDR p-values with `"ns"`.
#' @param fdr_alpha Numeric. Alpha level for FDR survival (BH-adjusted p).
#' @param domain_other Character string. Label for variables not assigned to
#'   any domain. Default `""` (blank). Inherits from
#'   `clerk_options()$domain_other`.
#' @param output Character string. One of `"gt"`, `"html"`, or `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"regression"`.
#'
#' @examples
#' tbl_regression(
#'   clerk_reg_example,
#'   domains = list(
#'     "Cardiometabolic" = c("bmi", "waist", "systolic_bp"),
#'     "Mental health"   = c("bdi", "panas_neg")
#'   ),
#'   fdr    = TRUE,
#'   output = "gt"
#' ) |> clerk_render(title = "Linear regression: TMT completion time")
#'
#' @importFrom rlang .data
#' @export
tbl_regression <- function(data,
                           term         = "term",
                           estimate     = "estimate",
                           std_error    = "std.error",
                           conf_low     = "conf.low",
                           conf_high    = "conf.high",
                           p            = "p.value",
                           model        = NULL,
                           domains      = list(),
                           exponentiate = FALSE,
                           fdr          = FALSE,
                           fdr_within   = NULL,
                           ci_sep       = ", ",
                           digits       = NULL,
                           p_digits     = NULL,
                           p_style      = NULL,
                           stars        = NULL,
                           fdr_ns       = NULL,
                           fdr_alpha    = NULL,
                           domain_other = NULL,
                           output       = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

  opts             <- .get_clerk_options()
  fdr_ns_val       <- if (!is.null(fdr_ns)) fdr_ns else isTRUE(opts$fdr_ns)
  fdr_alpha_val    <- fdr_alpha    %||% opts$fdr_alpha
  fdr_label        <- opts$fdr_ns_label
  domain_other_val <- domain_other %||% opts$domain_other

  if (exponentiate) {
    tbl[[estimate]]  <- exp(tbl[[estimate]])
    tbl[[conf_low]]  <- exp(tbl[[conf_low]])
    tbl[[conf_high]] <- exp(tbl[[conf_high]])
  }

  if (fdr) {
    if (!is.null(fdr_within)) {
      tbl <- tbl |>
        dplyr::group_by(.data[[fdr_within]]) |>
        dplyr::mutate(p_fdr_raw = stats::p.adjust(.data[[p]], method = "BH")) |>
        dplyr::ungroup()
    } else {
      tbl[["p_fdr_raw"]] <- stats::p.adjust(tbl[[p]], method = "BH")
    }
  }

  tbl[["beta"]] <- .fmt_stat(tbl[[estimate]], digits = digits, signed = TRUE)
  tbl[["se"]]   <- .fmt_stat(tbl[[std_error]], digits = digits)
  tbl[["ci"]]   <- paste0("[",
                           .fmt_stat(tbl[[conf_low]],  digits = digits, signed = TRUE),
                           ci_sep,
                           .fmt_stat(tbl[[conf_high]], digits = digits, signed = TRUE),
                           "]")
  tbl[["p_fmt"]] <- .fmt_p(tbl[[p]], p_digits = p_digits, p_style = p_style,
                            stars = stars)

  if (fdr && "p_fdr_raw" %in% names(tbl)) {
    p_fdr_raw <- tbl[["p_fdr_raw"]]
    p_fdr_fmt <- .fmt_p(p_fdr_raw, p_digits = p_digits, p_style = p_style,
                        stars = stars)
    if (fdr_ns_val)
      p_fdr_fmt <- ifelse(!is.na(p_fdr_raw) & p_fdr_raw >= fdr_alpha_val,
                          fdr_label, p_fdr_fmt)
    tbl[["p_fdr_fmt"]] <- p_fdr_fmt
  }

  keep <- c(term, model, "beta", "se", "ci", "p_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl[, keep, drop = FALSE]
  names(out_tbl)[names(out_tbl) == term]        <- "variable"
  names(out_tbl)[names(out_tbl) == "p_fmt"]     <- "p"
  names(out_tbl)[names(out_tbl) == "p_fdr_fmt"] <- "p_fdr"

  structure(
    list(table = out_tbl, domains = domains, log_vars = character(0),
         type = "regression", group = model, exponentiate = exponentiate,
         domain_other = domain_other_val, output = output),
    class = "clerk_tbl"
  )
}
