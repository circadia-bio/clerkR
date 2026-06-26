#' Simple descriptive summary table (no inferential tests)
#'
#' @description
#' Produces a concise descriptive summary of a data frame — mean ± SD for
#' continuous variables and n (%) for categorical variables — with no group
#' comparisons or statistical tests.
#'
#' @param data A data frame.
#' @param vars <[`tidy-select`][dplyr::dplyr_tidy_select]> Variables to
#'   include. Defaults to all columns.
#' @param domains A named list mapping variable names to domain/section labels.
#' @param log_vars Character vector of log-transformed variable names.
#' @param digits Integer. Decimal places for continuous variables (default `2`).
#' @param output Character string. One of `"gt"` (default), `"html"`, or
#'   `"latex"`.
#'
#' @return A `clerk_tbl` object with type `"simple"`.
#'
#' @examples
#' tbl_simple(
#'   clerk_example,
#'   domains = list(
#'     "Metabolic"     = c("hdl", "glucose", "bmi"),
#'     "Cognitive"     = c("tmt_time", "verbal_fluency"),
#'     "Mental health" = c("bdi", "panas_neg", "life_satisfaction")
#'   ),
#'   log_vars = "tmt_time",
#'   output   = "gt"
#' ) |> clerk_render(title = "Descriptive statistics")
#'
#' @export
tbl_simple <- function(data,
                       vars     = NULL,
                       domains  = list(),
                       log_vars = character(0),
                       digits   = 2,
                       output   = c("gt", "html", "latex")) {

  output <- match.arg(output)

  if (rlang::quo_is_null(rlang::enquo(vars))) {
    var_nms <- names(data)
  } else {
    var_nms <- names(dplyr::select(data, {{ vars }}))
  }

  is_cat <- vapply(data[var_nms], function(x)
    is.factor(x) || is.character(x) || is.logical(x), logical(1))

  rows <- lapply(var_nms, function(v) {
    x     <- data[[v]]
    n_obs <- sum(!is.na(x))

    if (is_cat[[v]]) {
      tab     <- table(x, useNA = "no")
      summary <- paste(
        paste0(names(tab), ": ", tab,
               " (", round(tab / sum(tab) * 100, 1), "%)"),
        collapse = "; "
      )
    } else {
      m       <- mean(x, na.rm = TRUE)
      s       <- stats::sd(x, na.rm = TRUE)
      summary <- sprintf(paste0("%.", digits, "f \u00b1 %.", digits, "f"), m, s)
    }

    data.frame(
      variable = v, n = n_obs, summary = summary,
      stringsAsFactors = FALSE
    )
  })

  tbl <- dplyr::bind_rows(rows)

  structure(
    list(
      table    = tbl,
      domains  = domains,
      log_vars = log_vars,
      type     = "simple",
      group    = NULL,
      output   = output
    ),
    class = "clerk_tbl"
  )
}
