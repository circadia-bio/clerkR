#' Regression coefficients table
#'
#' @description
#' Formats a tidy data frame of regression results into a publication-ready
#' table. Designed to accept output from `broom::tidy()` directly, or any
#' data frame with one row per model term.
#'
#' @param data A tidy data frame of regression results with one row per term.
#' @param term <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the model term column. Default `term`.
#' @param estimate <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name
#'   of the coefficient column. Default `estimate`.
#' @param std_error <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name
#'   of the standard error column. Default `std.error`.
#' @param conf_low <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name
#'   of the lower CI bound column. Default `conf.low`.
#' @param conf_high <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name
#'   of the upper CI bound column. Default `conf.high`.
#' @param p <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of the
#'   p-value column. Default `p.value`.
#' @param model Optional unquoted name of a column identifying multiple models.
#' @param domains A named list mapping term names to domain/section labels.
#' @param exponentiate Logical. Exponentiate estimates and CIs (default
#'   `FALSE`).
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Optional unquoted column to group FDR correction within.
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
#'   term      = term,
#'   estimate  = estimate,
#'   std_error = std.error,
#'   conf_low  = conf.low,
#'   conf_high = conf.high,
#'   p         = p.value,
#'   domains   = list(
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
                           term         = term,
                           estimate     = estimate,
                           std_error    = std.error,
                           conf_low     = conf.low,
                           conf_high    = conf.high,
                           p            = p.value,
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

  term_nm  <- rlang::as_name(rlang::enquo(term))
  est_nm   <- rlang::as_name(rlang::enquo(estimate))
  se_nm    <- rlang::as_name(rlang::enquo(std_error))
  cil_nm   <- rlang::as_name(rlang::enquo(conf_low))
  cih_nm   <- rlang::as_name(rlang::enquo(conf_high))
  p_nm     <- rlang::as_name(rlang::enquo(p))
  mod_nm   <- if (!rlang::quo_is_null(rlang::enquo(model)))
    rlang::as_name(rlang::enquo(model)) else NULL
  fw_nm    <- if (!rlang::quo_is_null(rlang::enquo(fdr_within)))
    rlang::as_name(rlang::enquo(fdr_within)) else NULL

  tbl <- data

  if (exponentiate) {
    tbl[[est_nm]] <- exp(tbl[[est_nm]])
    tbl[[cil_nm]] <- exp(tbl[[cil_nm]])
    tbl[[cih_nm]] <- exp(tbl[[cih_nm]])
  }

  if (fdr) {
    if (!is.null(fw_nm)) {
      tbl <- tbl |>
        dplyr::group_by(.data[[fw_nm]]) |>
        dplyr::mutate(p_fdr = stats::p.adjust(.data[[p_nm]], method = "BH")) |>
        dplyr::ungroup()
    } else {
      tbl <- tbl |>
        dplyr::mutate(p_fdr = stats::p.adjust(.data[[p_nm]], method = "BH"))
    }
  }

  fmt_est <- function(x) sprintf(paste0("%+.", digits, "f"), x)
  fmt_p   <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      beta  = fmt_est(.data[[est_nm]]),
      se    = sprintf(paste0("%.", digits, "f"), .data[[se_nm]]),
      ci    = paste0(
        "[",
        sprintf(paste0("%+.", digits, "f"), .data[[cil_nm]]),
        ci_sep,
        sprintf(paste0("%+.", digits, "f"), .data[[cih_nm]]),
        "]"
      ),
      p_fmt = fmt_p(.data[[p_nm]])
    )

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  keep <- c(term_nm, mod_nm, "beta", "se", "ci", "p_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl |>
    dplyr::select(dplyr::all_of(keep)) |>
    dplyr::rename(variable = dplyr::all_of(term_nm))

  names(out_tbl)[names(out_tbl) == "p_fmt"]     <- "p"
  names(out_tbl)[names(out_tbl) == "p_fdr_fmt"] <- "p_fdr"

  structure(
    list(
      table        = out_tbl,
      domains      = domains,
      log_vars     = character(0),
      type         = "regression",
      group        = mod_nm,
      exponentiate = exponentiate,
      output       = output
    ),
    class = "clerk_tbl"
  )
}
