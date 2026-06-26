#' Heritability and variance components table
#'
#' @description
#' Formats a tidy data frame of narrow-sense heritability estimates (h2) into
#' a publication-ready table. Column-name defaults match
#' `R-itable::herit_batch()` output directly.
#'
#' Formatting defaults are inherited from `clerk_options()` and can be
#' overridden per call.
#'
#' @param data A tidy data frame with one row per trait x covariate model.
#' @param metric Character string. Trait column name. Default `"trait"`.
#' @param h2 Character string. h2 estimate column. Default `"h2"`.
#' @param ci_low Character string. Lower CI bound column. Default `"ci_lo"`.
#' @param ci_high Character string. Upper CI bound column. Default `"ci_hi"`.
#' @param p Character string. P-value column. Default `"pval"`.
#' @param sigma2_a Character string or `NULL`. Additive genetic variance
#'   column. Default `NULL`.
#' @param sigma2_e Character string or `NULL`. Residual variance column.
#'   Default `NULL`.
#' @param model Character string or `NULL`. Covariate model column. Pass
#'   `"covariates"` for `herit_batch()` output. Default `NULL`.
#' @param domains A named list mapping trait names to domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column to group FDR within.
#' @param r_digits Integer. Decimal places for h2 and variance components.
#'   Inherits from `clerk_options()$r_digits` if `NULL`.
#' @param p_digits Integer. Decimal places for p-values. Inherits from
#'   `clerk_options()$p_digits` if `NULL`.
#' @param p_style Character. P-value style. Inherits from
#'   `clerk_options()$p_style` if `NULL`.
#' @param stars Logical. Append significance stars. Inherits from
#'   `clerk_options()$stars` if `NULL`.
#' @param fdr_ns Logical. Replace non-surviving FDR p-values with `"ns"`.
#'   Inherits from `clerk_options()$fdr_ns` if `NULL`.
#' @param fdr_alpha Numeric. Alpha level applied to the BH-adjusted p-value to
#'   determine survival. Inherits from `clerk_options()$fdr_alpha` if `NULL`.
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"heritability"`.
#'
#' @examples
#' tbl_heritability(
#'   clerk_h2_example,
#'   model    = "covariates",
#'   sigma2_a = "sigma2_a",
#'   sigma2_e = "sigma2_e",
#'   fdr      = TRUE,
#'   output   = "gt"
#' ) |> clerk_render(title = "Heritability estimates")
#'
#' @importFrom rlang .data
#' @export
tbl_heritability <- function(data,
                             metric     = "trait",
                             h2         = "h2",
                             ci_low     = "ci_lo",
                             ci_high    = "ci_hi",
                             p          = "pval",
                             sigma2_a   = NULL,
                             sigma2_e   = NULL,
                             model      = NULL,
                             domains    = list(),
                             fdr        = FALSE,
                             fdr_within = NULL,
                             r_digits   = NULL,
                             p_digits   = NULL,
                             p_style    = NULL,
                             stars      = NULL,
                             fdr_ns     = NULL,
                             fdr_alpha  = NULL,
                             output     = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

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

  tbl[["h2_fmt"]] <- .fmt_r(tbl[[h2]], r_digits = r_digits, signed = FALSE)
  tbl[["ci_fmt"]] <- paste0(
    "[",
    .fmt_r(tbl[[ci_low]],  r_digits = r_digits, signed = FALSE),
    ", ",
    .fmt_r(tbl[[ci_high]], r_digits = r_digits, signed = FALSE),
    "]"
  )
  tbl[["p_fmt"]] <- .fmt_p(tbl[[p]], p_digits = p_digits, p_style = p_style,
                            stars = stars)

  if (!is.null(sigma2_a))
    tbl[["sigma2_a_fmt"]] <- .fmt_r(tbl[[sigma2_a]], r_digits = r_digits,
                                     signed = FALSE)

  if (!is.null(sigma2_e))
    tbl[["sigma2_e_fmt"]] <- .fmt_r(tbl[[sigma2_e]], r_digits = r_digits,
                                     signed = FALSE)

  if (fdr && "p_fdr_raw" %in% names(tbl))
    tbl[["p_fdr_fmt"]] <- .fmt_p_fdr(tbl[["p_fdr_raw"]], fdr_ns = fdr_ns,
                                      fdr_alpha = fdr_alpha,
                                      p_digits = p_digits, p_style = p_style,
                                      stars = stars)

  keep <- c(metric, model, "h2_fmt", "ci_fmt", "p_fmt")
  if (!is.null(sigma2_a)) keep <- c(keep, "sigma2_a_fmt")
  if (!is.null(sigma2_e)) keep <- c(keep, "sigma2_e_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl[, keep, drop = FALSE]
  names(out_tbl)[names(out_tbl) == metric]         <- "variable"
  names(out_tbl)[names(out_tbl) == "h2_fmt"]       <- "h2"
  names(out_tbl)[names(out_tbl) == "ci_fmt"]       <- "ci_95"
  names(out_tbl)[names(out_tbl) == "p_fmt"]        <- "p"
  names(out_tbl)[names(out_tbl) == "p_fdr_fmt"]    <- "p_fdr"
  names(out_tbl)[names(out_tbl) == "sigma2_a_fmt"] <- "sigma2_a"
  names(out_tbl)[names(out_tbl) == "sigma2_e_fmt"] <- "sigma2_e"

  structure(
    list(
      table    = out_tbl,
      domains  = domains,
      log_vars = character(0),
      type     = "heritability",
      group    = model,
      output   = output
    ),
    class = "clerk_tbl"
  )
}
