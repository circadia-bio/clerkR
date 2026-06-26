#' Heritability and variance components table
#'
#' @description
#' Formats a tidy data frame of narrow-sense heritability estimates (h²) into
#' a publication-ready table. Default column name arguments match the output of
#' `R-itable::herit_batch()` directly, so no renaming is needed in the most
#' common workflow:
#'
#' ```r
#' herit_batch(...) |>
#'   tbl_heritability(model = covariates) |>
#'   clerk_render()
#' ```
#'
#' @param data A tidy data frame with one row per trait x covariate model.
#' @param metric <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the trait/phenotype column. Default `trait` (matches `herit_batch()`).
#' @param h2 <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of the
#'   h² estimate column. Default `h2`.
#' @param ci_low <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the lower 95% CI bound column. Default `ci_lo` (matches `herit_batch()`).
#' @param ci_high <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the upper 95% CI bound column. Default `ci_hi` (matches `herit_batch()`).
#' @param p <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of the
#'   one-sided LRT p-value column. Default `pval` (matches `herit_batch()`).
#' @param sigma2_a Optional unquoted name of the additive genetic variance
#'   column (σ²a). Default `sigma2_a`.
#' @param sigma2_e Optional unquoted name of the residual variance column
#'   (σ²e). Default `sigma2_e`.
#' @param model Optional unquoted name of a column identifying covariate
#'   models. Pass `model = covariates` when using `herit_batch()` output.
#' @param domains A named list mapping trait names to domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Optional unquoted column to group FDR correction within.
#' @param digits Integer. Decimal places for h² and variance components
#'   (default `2`).
#' @param p_digits Integer. Decimal places for p-values (default `3`).
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"heritability"`.
#'
#' @examples
#' tbl_heritability(
#'   clerk_h2_example,
#'   model    = covariates,
#'   sigma2_a = sigma2_a,
#'   sigma2_e = sigma2_e,
#'   fdr      = TRUE,
#'   output   = "gt"
#' ) |> clerk_render(title = "Heritability estimates for cortical shape metrics")
#'
#' @importFrom rlang .data
#' @export
tbl_heritability <- function(data,
                             metric     = trait,
                             h2         = h2,
                             ci_low     = ci_lo,
                             ci_high    = ci_hi,
                             p          = pval,
                             sigma2_a   = NULL,
                             sigma2_e   = NULL,
                             model      = NULL,
                             domains    = list(),
                             fdr        = FALSE,
                             fdr_within = NULL,
                             digits     = 2,
                             p_digits   = 3,
                             output     = c("gt", "html", "latex")) {

  output <- match.arg(output)

  met_nm  <- rlang::as_name(rlang::enquo(metric))
  h2_nm   <- rlang::as_name(rlang::enquo(h2))
  cil_nm  <- rlang::as_name(rlang::enquo(ci_low))
  cih_nm  <- rlang::as_name(rlang::enquo(ci_high))
  p_nm    <- rlang::as_name(rlang::enquo(p))
  s2a_nm  <- if (!rlang::quo_is_null(rlang::enquo(sigma2_a)))
    rlang::as_name(rlang::enquo(sigma2_a)) else NULL
  s2e_nm  <- if (!rlang::quo_is_null(rlang::enquo(sigma2_e)))
    rlang::as_name(rlang::enquo(sigma2_e)) else NULL
  mod_nm  <- if (!rlang::quo_is_null(rlang::enquo(model)))
    rlang::as_name(rlang::enquo(model)) else NULL
  fw_nm   <- if (!rlang::quo_is_null(rlang::enquo(fdr_within)))
    rlang::as_name(rlang::enquo(fdr_within)) else NULL

  tbl <- data

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

  fmt_h2 <- function(x) sprintf(paste0("%.", digits, "f"), x)
  fmt_p  <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      h2_fmt = fmt_h2(.data[[h2_nm]]),
      ci_fmt = paste0(
        "[", fmt_h2(.data[[cil_nm]]), ", ", fmt_h2(.data[[cih_nm]]), "]"
      ),
      p_fmt  = fmt_p(.data[[p_nm]])
    )

  if (!is.null(s2a_nm))
    tbl <- tbl |>
      dplyr::mutate(sigma2_a_fmt = fmt_h2(.data[[s2a_nm]]))

  if (!is.null(s2e_nm))
    tbl <- tbl |>
      dplyr::mutate(sigma2_e_fmt = fmt_h2(.data[[s2e_nm]]))

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  keep <- c(met_nm, mod_nm, "h2_fmt", "ci_fmt", "p_fmt")
  if (!is.null(s2a_nm)) keep <- c(keep, "sigma2_a_fmt")
  if (!is.null(s2e_nm)) keep <- c(keep, "sigma2_e_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl |>
    dplyr::select(dplyr::all_of(keep)) |>
    dplyr::rename(variable = dplyr::all_of(met_nm))

  names(out_tbl)[names(out_tbl) == "h2_fmt"]      <- "h2"
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
      group    = mod_nm,
      output   = output
    ),
    class = "clerk_tbl"
  )
}
