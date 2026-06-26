#' Correlation / partial correlation table
#'
#' @description
#' Formats a tidy data frame of (partial) correlation results into a
#' publication-ready table. Expects pre-computed coefficients — typically the
#' output of `stats::cor.test()`, `ppcor::pcor.test()`, or a custom loop — as
#' a tidy data frame with one row per variable pair.
#'
#' @param data A tidy data frame of correlation results with one row per
#'   predictor x outcome pair.
#' @param predictor <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name
#'   of the column identifying the predictor variable.
#' @param outcome <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of
#'   the column identifying the outcome variable.
#' @param r <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of the
#'   correlation coefficient column.
#' @param p <[`tidy-select`][dplyr::dplyr_tidy_select]> Unquoted name of the
#'   p-value column.
#' @param n Optional unquoted name of the sample size column.
#' @param extra_cols Optional character vector of additional column names to
#'   carry through (e.g. hemisphere, lobe).
#' @param domains A named list mapping predictor names to domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Optional unquoted column to group FDR correction within.
#' @param digits Integer. Decimal places for r (default `3`).
#' @param p_digits Integer. Decimal places for p-values (default `3`).
#' @param pivot Logical. Pivot to wide format with one column per outcome
#'   (default `FALSE`).
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"correlation"`.
#'
#' @examples
#' tbl_correlation(
#'   clerk_cor_example,
#'   predictor = variable,
#'   outcome   = outcome,
#'   r         = r,
#'   p         = p,
#'   n         = n,
#'   domains   = list(
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
                            predictor  = variable,
                            outcome    = outcome,
                            r          = r,
                            p          = p,
                            n          = NULL,
                            extra_cols = NULL,
                            domains    = list(),
                            fdr        = FALSE,
                            fdr_within = NULL,
                            digits     = 3,
                            p_digits   = 3,
                            pivot      = FALSE,
                            output     = c("gt", "html", "latex")) {

  output <- match.arg(output)

  pred_nm <- rlang::as_name(rlang::enquo(predictor))
  out_nm  <- rlang::as_name(rlang::enquo(outcome))
  r_nm    <- rlang::as_name(rlang::enquo(r))
  p_nm    <- rlang::as_name(rlang::enquo(p))
  n_nm    <- if (!rlang::quo_is_null(rlang::enquo(n)))
    rlang::as_name(rlang::enquo(n)) else NULL
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

  fmt_r <- function(x) sprintf(paste0("%+.", digits, "f"), x)
  fmt_p <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      r_fmt = fmt_r(.data[[r_nm]]),
      p_fmt = fmt_p(.data[[p_nm]])
    )

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  if (pivot) {
    cell_col <- if (fdr && "p_fdr" %in% names(tbl)) "p_fdr_fmt" else "p_fmt"
    tbl <- tbl |>
      dplyr::mutate(
        cell = paste0(.data[["r_fmt"]], " (", .data[[cell_col]], ")")
      )

    keep_cols <- c(pred_nm, extra_cols, out_nm, "cell")
    tbl_wide  <- tbl |>
      dplyr::select(dplyr::all_of(keep_cols)) |>
      tidyr::pivot_wider(
        names_from  = dplyr::all_of(out_nm),
        values_from = "cell"
      )

    if (!is.null(n_nm)) {
      n_tbl <- tbl |>
        dplyr::group_by(.data[[pred_nm]]) |>
        dplyr::summarise(
          n = round(mean(.data[[n_nm]], na.rm = TRUE)), .groups = "drop"
        )
      tbl_wide <- dplyr::left_join(tbl_wide, n_tbl, by = pred_nm)
    }

    out_tbl <- tbl_wide |>
      dplyr::rename(variable = dplyr::all_of(pred_nm))

  } else {
    keep <- c(pred_nm, extra_cols, out_nm)
    if (!is.null(n_nm)) keep <- c(keep, n_nm)
    keep <- c(keep, "r_fmt", "p_fmt")
    if (fdr && "p_fdr_fmt" %in% names(tbl)) keep <- c(keep, "p_fdr_fmt")

    out_tbl <- tbl |>
      dplyr::select(dplyr::all_of(keep)) |>
      dplyr::rename(variable = dplyr::all_of(pred_nm))

    names(out_tbl)[names(out_tbl) == "r_fmt"]     <- "r"
    names(out_tbl)[names(out_tbl) == "p_fmt"]     <- "p"
    names(out_tbl)[names(out_tbl) == "p_fdr_fmt"] <- "p_fdr"
  }

  structure(
    list(
      table    = out_tbl,
      domains  = domains,
      log_vars = character(0),
      type     = "correlation",
      group    = NULL,
      pivot    = pivot,
      outcomes = if (pivot) unique(tbl[[out_nm]]) else NULL,
      output   = output
    ),
    class = "clerk_tbl"
  )
}
