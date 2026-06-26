#' Correlation / partial correlation table
#'
#' @description
#' Formats a tidy data frame of (partial) correlation results into a
#' publication-ready table. Expects pre-computed coefficients as a tidy data
#' frame with one row per predictor x outcome pair.
#'
#' Column-name arguments accept **character strings** (quoted names). Defaults
#' match a typical correlation results frame with columns named `variable`,
#' `outcome`, `r`, and `p`.
#'
#' @param data A tidy data frame of correlation results.
#' @param predictor Character string. Name of the predictor variable column.
#'   Default `"variable"`.
#' @param outcome Character string. Name of the outcome variable column.
#'   Default `"outcome"`.
#' @param r Character string. Name of the correlation coefficient column.
#'   Default `"r"`.
#' @param p Character string. Name of the p-value column. Default `"p"`.
#' @param n Character string or `NULL`. Name of the sample size column.
#'   Default `NULL` (omitted).
#' @param extra_cols Character vector of additional column names to carry
#'   through (e.g. `"hemisphere"`, `"lobe"`).
#' @param domains A named list mapping predictor variable names to
#'   domain/section labels.
#' @param fdr Logical. Apply BH FDR correction (default `FALSE`).
#' @param fdr_within Character string or `NULL`. Column name to group FDR
#'   correction within (e.g. `"outcome"`).
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
                            predictor  = "variable",
                            outcome    = "outcome",
                            r          = "r",
                            p          = "p",
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
  tbl    <- data

  # --- FDR correction --------------------------------------------------------
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

  # --- Format r and p --------------------------------------------------------
  fmt_r <- function(x) sprintf(paste0("%+.", digits, "f"), x)
  fmt_p <- function(x) dplyr::case_when(
    x < 0.001 ~ "<0.001",
    TRUE       ~ sprintf(paste0("%.", p_digits, "f"), x)
  )

  tbl <- tbl |>
    dplyr::mutate(
      r_fmt = fmt_r(.data[[r]]),
      p_fmt = fmt_p(.data[[p]])
    )

  if (fdr && "p_fdr" %in% names(tbl))
    tbl <- tbl |> dplyr::mutate(p_fdr_fmt = fmt_p(.data[["p_fdr"]]))

  # --- Pivot or long ---------------------------------------------------------
  if (pivot) {
    cell_col <- if (fdr && "p_fdr_fmt" %in% names(tbl)) "p_fdr_fmt" else "p_fmt"
    tbl <- tbl |>
      dplyr::mutate(
        cell = paste0(.data[["r_fmt"]], " (", .data[[cell_col]], ")")
      )

    keep_cols <- c(predictor, extra_cols, outcome, "cell")
    tbl_wide  <- tbl |>
      dplyr::select(dplyr::all_of(keep_cols)) |>
      tidyr::pivot_wider(
        names_from  = outcome,
        values_from = "cell"
      )

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

    out_tbl <- tbl |> dplyr::select(dplyr::all_of(keep))
    names(out_tbl)[names(out_tbl) == predictor]  <- "variable"
    names(out_tbl)[names(out_tbl) == "r_fmt"]    <- "r"
    names(out_tbl)[names(out_tbl) == "p_fmt"]    <- "p"
    names(out_tbl)[names(out_tbl) == "p_fdr_fmt"]<- "p_fdr"
    if (!is.null(n)) names(out_tbl)[names(out_tbl) == n] <- "n"
  }

  structure(
    list(
      table    = out_tbl,
      domains  = domains,
      log_vars = character(0),
      type     = "correlation",
      group    = NULL,
      pivot    = pivot,
      output   = output
    ),
    class = "clerk_tbl"
  )
}
