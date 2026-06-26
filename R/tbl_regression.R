#' Regression coefficients table
#'
#' @description
#' Formats a tidy data frame of regression results into a publication-ready
#' table. Designed to accept `broom::tidy()` output directly. Column-name
#' arguments accept character strings; defaults match `broom::tidy()`.
#'
#' Formatting defaults are inherited from `clerk_options()` and can be
#' overridden per call.
#'
#' @param data A tidy data frame of regression results.
#' @param term Character string. Model term column. Default `"term"`.
#' @param estimate Character string. Coefficient column. Default `"estimate"`.
#' @param std_error Character string. Standard error column. Default
#'   `"std.error"`.
#' @param conf_low Character string. Lower CI bound column. Default
#'   `"conf.low"`.
#' @param conf_high Character string. Upper CI bound column. Default
#'   `"conf.high"`.
#' @param p Character string. P-value column. Default `"p.value"`.
#' @param model Character string or `NULL`. Column identifying multiple models.
#' @param domains A named list mapping term names to domain/section labels.
#' @param exponentiate Logical. Exponentiate estimates and CIs (default
#'   `FALSE`).
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column to group FDR within.
#' @param ci_sep Character string separating CI bounds (default `", "`).
#' @param digits Integer. Decimal places for estimates. Inherits from
#'   `clerk_options()$digits` if `NULL`.
#' @param p_digits Integer. Decimal places for p-values. Inherits from
#'   `clerk_options()$p_digits` if `NULL`.
#' @param p_style Character. P-value style. Inherits from
#'   `clerk_options()$p_style` if `NULL`.
#' @param stars Logical. Append significance stars. Inherits from
#'   `clerk_options()$stars` if `NULL`.
#' @param fdr_ns Logical. Replace non-surviving FDR values with `"ns"`.
#'   Inherits from `clerk_options()$fdr_ns` if `NULL`.
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
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
                           output       = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

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

  # Direct assignment avoids dplyr eval environment issues
  tbl[["beta"]] <- .fmt_stat(tbl[[estimate]], digits = digits, signed = TRUE)
  tbl[["se"]]   <- .fmt_stat(tbl[[std_error]], digits = digits)
  tbl[["ci"]]   <- paste0(
    "[",
    .fmt_stat(tbl[[conf_low]],  digits = digits, signed = TRUE),
    ci_sep,
    .fmt_stat(tbl[[conf_high]], digits = digits, signed = TRUE),
    "]"
  )
  tbl[["p_fmt"]] <- .fmt_p(tbl[[p]], p_digits = p_digits, p_style = p_style,
                            stars = stars)

  if (fdr && "p_fdr_raw" %in% names(tbl))
    tbl[["p_fdr_fmt"]] <- .fmt_p_fdr(tbl[["p_fdr_raw"]], fdr_ns = fdr_ns,
                                      p_digits = p_digits, p_style = p_style,
                                      stars = stars)

  keep <- c(term, model, "beta", "se", "ci", "p_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl[, keep, drop = FALSE]
  names(out_tbl)[names(out_tbl) == term]        <- "variable"
  names(out_tbl)[names(out_tbl) == "p_fmt"]     <- "p"
  names(out_tbl)[names(out_tbl) == "p_fdr_fmt"] <- "p_fdr"

  structure(
    list(
      table        = out_tbl,
      domains      = domains,
      log_vars     = character(0),
      type         = "regression",
      group        = model,
      exponentiate = exponentiate,
      output       = output
    ),
    class = "clerk_tbl"
  )
}
