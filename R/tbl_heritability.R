#' Heritability and variance components table
#'
#' @description
#' Formats a tidy data frame of narrow-sense heritability estimates (h2) into
#' a publication-ready table. Column-name defaults match
#' `R-itable::herit_batch()` output directly. Formatting defaults inherited
#' from `clerk_options()`.
#'
#' @param data A tidy data frame with one row per trait x covariate model.
#' @param metric Character string. Trait column name. Default `"trait"`.
#' @param h2 Character string. h2 estimate column. Default `"h2"`.
#' @param ci_low Character string. Lower CI column. Default `"ci_lo"`.
#' @param ci_high Character string. Upper CI column. Default `"ci_hi"`.
#' @param p Character string. P-value column. Default `"pval"`.
#' @param sigma2_a Character string or `NULL`. Additive genetic variance
#'   column.
#' @param sigma2_e Character string or `NULL`. Residual variance column.
#' @param model Character string or `NULL`. Covariate model column. Pass
#'   `"covariates"` for `herit_batch()` output.
#' @param domains A named list mapping trait names to domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column to group FDR within.
#' @param r_digits Integer. Decimal places for h2 and variance components.
#' @param p_digits Integer. Decimal places for p-values.
#' @param p_threshold Numeric. P-values below this are shown as
#'   `"< {threshold}"`. Inherits from `clerk_options()$p_threshold` if `NULL`.
#' @param p_style Character. P-value style.
#' @param stars Logical. Append significance stars.
#' @param fdr_ns Logical. Replace non-surviving FDR p-values with `"ns"`.
#' @param fdr_alpha Numeric. Alpha level for FDR survival (BH-adjusted p).
#' @param domain_other Character string. Label for variables not assigned to
#'   any domain. Default `""` (blank). Inherits from
#'   `clerk_options()$domain_other`.
#' @param output Character string. One of `"gt"`, `"html"`, or `"latex"`.
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
                             metric       = "trait",
                             h2           = "h2",
                             ci_low       = "ci_lo",
                             ci_high      = "ci_hi",
                             p            = "pval",
                             sigma2_a     = NULL,
                             sigma2_e     = NULL,
                             model        = NULL,
                             domains      = list(),
                             fdr          = FALSE,
                             fdr_within   = NULL,
                             r_digits     = NULL,
                             p_digits     = NULL,
                             p_threshold  = NULL,
                             p_style      = NULL,
                             stars        = NULL,
                             fdr_ns       = NULL,
                             fdr_alpha    = NULL,
                             domain_other = NULL,
                             output       = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

  opts              <- .get_clerk_options()
  fdr_ns_val        <- if (!is.null(fdr_ns)) fdr_ns else isTRUE(opts$fdr_ns)
  fdr_alpha_val     <- fdr_alpha    %||% opts$fdr_alpha
  fdr_label         <- opts$fdr_ns_label
  domain_other_val  <- domain_other %||% opts$domain_other
  p_threshold_val   <- p_threshold  %||% opts$p_threshold

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
  tbl[["ci_fmt"]] <- paste0("[",
                             .fmt_r(tbl[[ci_low]],  r_digits = r_digits, signed = FALSE),
                             ", ",
                             .fmt_r(tbl[[ci_high]], r_digits = r_digits, signed = FALSE),
                             "]")
  tbl[["p_fmt"]] <- .fmt_p(tbl[[p]], p_digits = p_digits,
                            p_threshold = p_threshold_val,
                            p_style = p_style, stars = stars)

  if (!is.null(sigma2_a))
    tbl[["sigma2_a_fmt"]] <- .fmt_r(tbl[[sigma2_a]], r_digits = r_digits,
                                     signed = FALSE)
  if (!is.null(sigma2_e))
    tbl[["sigma2_e_fmt"]] <- .fmt_r(tbl[[sigma2_e]], r_digits = r_digits,
                                     signed = FALSE)

  if (fdr && "p_fdr_raw" %in% names(tbl)) {
    p_fdr_raw <- tbl[["p_fdr_raw"]]
    p_fdr_fmt <- .fmt_p(p_fdr_raw, p_digits = p_digits,
                        p_threshold = p_threshold_val,
                        p_style = p_style, stars = stars)
    if (fdr_ns_val)
      p_fdr_fmt <- ifelse(!is.na(p_fdr_raw) & p_fdr_raw >= fdr_alpha_val,
                          fdr_label, p_fdr_fmt)
    tbl[["p_fdr_fmt"]] <- p_fdr_fmt
  }

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
    list(table = out_tbl, domains = domains, log_vars = character(0),
         type = "heritability", group = model,
         domain_other = domain_other_val, output = output),
    class = "clerk_tbl"
  )
}
