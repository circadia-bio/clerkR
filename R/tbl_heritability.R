#' Heritability and variance components table
#'
#' @description
#' Formats a tidy data frame of narrow-sense heritability estimates (h2) into
#' a publication-ready table. Column-name defaults match the output of
#' `R-itable::herit_batch()` directly.
#'
#' Column-name arguments accept **character strings** (quoted names).
#'
#' @param data A tidy data frame with one row per trait x covariate model.
#' @param metric Character string. Name of the trait/phenotype column.
#'   Default `"trait"` (matches `herit_batch()`).
#' @param h2 Character string. Name of the h2 estimate column.
#'   Default `"h2"`.
#' @param ci_low Character string. Name of the lower 95% CI bound column.
#'   Default `"ci_lo"` (matches `herit_batch()`).
#' @param ci_high Character string. Name of the upper 95% CI bound column.
#'   Default `"ci_hi"` (matches `herit_batch()`).
#' @param p Character string. Name of the one-sided LRT p-value column.
#'   Default `"pval"` (matches `herit_batch()`).
#' @param sigma2_a Character string or `NULL`. Name of the additive genetic
#'   variance column. Default `NULL`.
#' @param sigma2_e Character string or `NULL`. Name of the residual variance
#'   column. Default `NULL`.
#' @param model Character string or `NULL`. Name of a column identifying
#'   covariate models. Pass `"covariates"` when using `herit_batch()` output.
#'   Default `NULL`.
#' @param domains A named list mapping trait names to domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column name to group FDR
#'   correction within.
#' @param digits Integer. Decimal places for h2 and variance components
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
#'   model    = "covariates",
#'   sigma2_a = "sigma2_a",
#'   sigma2_e = "sigma2_e",
#'   fdr      = TRUE,
#'   output   = "gt"
#' ) |> clerk_render(title = "Heritability estimates for cortical shape metrics")
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
                             digits     = 2,
                             p_digits   = 3,
                             output     = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

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

  fmt_h2 <- function(x) sprintf(paste0("%.", digits, "f"), x)
  fmt_p  <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      h2_fmt = fmt_h2(.data[[h2]]),
      ci_fmt = paste0(
        "[", fmt_h2(.data[[ci_low]]), ", ", fmt_h2(.data[[ci_high]]), "]"
      ),
      p_fmt  = fmt_p(.data[[p]])
    )

  if (!is.null(sigma2_a))
    tbl <- tbl |>
      dplyr::mutate(sigma2_a_fmt = fmt_h2(.data[[sigma2_a]]))

  if (!is.null(sigma2_e))
    tbl <- tbl |>
      dplyr::mutate(sigma2_e_fmt = fmt_h2(.data[[sigma2_e]]))

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  keep <- c(metric, model, "h2_fmt", "ci_fmt", "p_fmt")
  if (!is.null(sigma2_a)) keep <- c(keep, "sigma2_a_fmt")
  if (!is.null(sigma2_e)) keep <- c(keep, "sigma2_e_fmt")
  if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

  out_tbl <- tbl |> dplyr::select(dplyr::all_of(keep))
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
