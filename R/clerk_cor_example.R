#' Synthetic partial correlation results for clerkR examples
#'
#' @description
#' A synthetic dataset of partial correlation results (age + sex controlled)
#' between eight predictor variables and two cognitive outcomes, designed to
#' illustrate `tbl_correlation()`. All values are simulated and bear no
#' relation to any real study.
#'
#' @format A data frame with 16 rows and 5 variables:
#' \describe{
#'   \item{variable}{Predictor variable name (character).}
#'   \item{outcome}{Outcome variable name: `"tmt_time"` or
#'     `"verbal_fluency"` (character).}
#'   \item{n}{Sample size for each correlation (integer).}
#'   \item{r}{Partial correlation coefficient (numeric).}
#'   \item{p}{Two-tailed p-value (numeric).}
#' }
#' @source Simulated data generated in `data-raw/clerk_cor_example.R`.
"clerk_cor_example"
