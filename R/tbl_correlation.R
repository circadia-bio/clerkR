#' Correlation / partial correlation table
#'
#' @description
#' Formats a tidy data frame of (partial) correlation results into a
#' publication-ready table. Column-name arguments accept character strings.
#' Defaults match a typical correlation results frame with columns named
#' `variable`, `outcome`, `r`, and `p`.
#'
#' Formatting defaults are inherited from `clerk_options()` and can be
#' overridden per call.
#'
#' @param data A tidy data frame of correlation results.
#' @param predictor Character string. Predictor column name. Default
#'   `"variable"`.
#' @param outcome Character string. Outcome column name. Default `"outcome"`.
#' @param r Character string. Correlation coefficient column. Default `"r"`.
#' @param p Character string. P-value column. Default `"p"`.
#' @param n Character string or `NULL`. Sample size column. Default `NULL`.
#' @param extra_cols Character vector of additional columns to carry through.
#' @param domains A named list mapping predictor names to domain/section
#'   labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column to group FDR within.
#' @param r_digits Integer. Decimal places for r.
#' @param p_digits Integer. Decimal places for p-values.
#' @param p_style Character. P-value style.
#' @param stars Logical. Append significance stars.
#' @param fdr_ns Logical. Replace non-surviving FDR p-values with `"ns"`.
#' @param fdr_alpha Numeric. Alpha level for FDR survival (BH-adjusted p).
#' @param domain_other Character string. Label for variables not assigned to
#'   any domain. Default `""` (blank). Inherits from
#'   `clerk_options()$domain_other`.
#' @param pivot Logical. Pivot to wide format (default `FALSE`).
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"correlation"`.
#'
#' @examples
#' tbl_correlation(
#'   clerk_cor_example,
#'   domains = list(
#'     "Metabolic"      = c("hdl", "glucose", "bmi"),
#'     "Anthropometric" = c("waist", "systolic_bp"),
#'     "Mental health"  = c("bdi", "panas_neg")
#'   ),
#'   fdr    = TRUE,
#'   output = "gt"
#' ) |> clerk_render(title = "Partial correlations (age + sex controlled)")
#'
#' @importFrom rlang .data
#' @export
tbl_correlation <- function(data,
                            predictor    = "variable",
                            outcome      = "outcome",
                            r            = "r",
                            p            = "p",
                            n            = NULL,
                            extra_cols   = NULL,
                            domains      = list(),
                            fdr          = FALSE,
                            fdr_within   = NULL,
                            r_digits     = NULL,
                            p_digits     = NULL,
                            p_style      = NULL,
                            stars        = NULL,
                            fdr_ns       = NULL,
                            fdr_alpha    = NULL,
                            domain_other = NULL,
                            pivot        = FALSE,
                            output       = c("gt", "html", "latex")) {

  output <- match.arg(output)
  tbl    <- data

  opts             <- .get_clerk_options()
  fdr_ns_val       <- if (!is.null(fdr_ns)) fdr_ns else isTRUE(opts$fdr_ns)
  fdr_alpha_val    <- fdr_alpha    %||% opts$fdr_alpha
  fdr_label        <- opts$fdr_ns_label
  domain_other_val <- domain_other %||% opts$domain_other

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

  tbl[["r_fmt"]] <- .fmt_r(tbl[[r]], r_digits = r_digits)
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

  if (pivot) {
    cell_col <- if (fdr && "p_fdr_fmt" %in% names(tbl)) "p_fdr_fmt" else "p_fmt"
    tbl[["cell"]] <- paste0(tbl[["r_fmt"]], " (", tbl[[cell_col]], ")")

    keep_cols <- c(predictor, extra_cols, outcome, "cell")
    tbl_wide  <- tbl |>
      dplyr::select(dplyr::all_of(keep_cols)) |>
      tidyr::pivot_wider(names_from = outcome, values_from = "cell")

    if (!is.null(n)) {
      n_tbl <- tbl |>
        dplyr::group_by(.data[[predictor]]) |>
        dplyr::summarise(
          n = round(mean(.data[[n]], na.rm = TRUE)), .groups = "drop"
        )
      tbl_wide <- dplyr::left_join(tbl_wide, n_tbl, by = predictor)
    }

    out_tbl <- tbl_wide
    names(out_tbl)[names(out_tbl) == predictor] <- "variable"

  } else {
    keep <- c(predictor, extra_cols, outcome)
    if (!is.null(n)) keep <- c(keep, n)
    keep <- c(keep, "r_fmt", "p_fmt")
    if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

    out_tbl <- tbl[, keep, drop = FALSE]
    names(out_tbl)[names(out_tbl) == predictor]   <- "variable"
    names(out_tbl)[names(out_tbl) == "r_fmt"]     <- "r"
    names(out_tbl)[names(out_tbl) == "p_fmt"]     <- "p"
    names(out_tbl)[names(out_tbl) == "p_fdr_fmt"] <- "p_fdr"
    if (!is.null(n)) names(out_tbl)[names(out_tbl) == n] <- "n"
  }

  structure(
    list(table = out_tbl, domains = domains, log_vars = character(0),
         type = "correlation", group = NULL, pivot = pivot,
         domain_other = domain_other_val, output = output),
    class = "clerk_tbl"
  )
}
