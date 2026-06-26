#' Regression coefficients table
#'
#' @description
#' Formats a tidy data frame of regression results into a publication-ready
#' table. Designed to accept the output of `broom::tidy()` directly.
#'
#' Column-name arguments accept **character strings** (quoted names). Defaults
#' match `broom::tidy(model, conf.int = TRUE)` output.
#'
#' @param data A tidy data frame of regression results with one row per term.
#' @param term Character string. Name of the model term column.
#'   Default `"term"`.
#' @param estimate Character string. Name of the coefficient column.
#'   Default `"estimate"`.
#' @param std_error Character string. Name of the standard error column.
#'   Default `"std.error"`.
#' @param conf_low Character string. Name of the lower CI bound column.
#'   Default `"conf.low"`.
#' @param conf_high Character string. Name of the upper CI bound column.
#'   Default `"conf.high"`.
#' @param p Character string. Name of the p-value column.
#'   Default `"p.value"`.
#' @param model Character string or `NULL`. Name of a column identifying
#'   multiple models. Default `NULL`.
#' @param domains A named list mapping term names to domain/section labels.
#' @param exponentiate Logical. Exponentiate estimates and CIs (default
#'   `FALSE`).
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column name to group FDR
#'   correction within.
#' @param ci_sep Character string separating CI bounds (default `", "`).
#' @param digits Integer. Decimal places for estimates (default `3`).
#' @param p_digits Integer. Decimal places for p-values (default `3`).
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
                           digits       = 3,
                           p_digits     = 3,
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
        dplyr::mutate(p_fdr = stats::p.adjust(.data[[p]], method = "BH")) |>
        dplyr::ungroup()
    } else {
      tbl <- tbl |>
        dplyr::mutate(p_fdr = stats::p.adjust(.data[[p]], method = "BH"))
    }
  }

  fmt_est <- function(x) sprintf(paste0("%+.", digits, "f"), x)
  fmt_p   <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      beta  = fmt_est(.data[[estimate]]),
      se    = sprintf(paste0("%.", digits, "f"), .data[[std_error]]),
      ci    = paste0(
        "[",
        sprintf(paste0("%+.", digits, "f"), .data[[conf_low]]),
        ci_sep,
        sprintf(paste0("%+.", digits, "f"), .data[[conf_high]]),
        "]"
      ),
      p_fmt = fmt_p(.data[[p]])
    )

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  keep <- c(term, model, "beta", "se", "ci", "p_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl |> dplyr::select(dplyr::all_of(keep))
  names(out_tbl)[names(out_tbl) == term]       <- "variable"
  names(out_tbl)[names(out_tbl) == "p_fmt"]    <- "p"
  names(out_tbl)[names(out_tbl) == "p_fdr_fmt"]<- "p_fdr"

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
