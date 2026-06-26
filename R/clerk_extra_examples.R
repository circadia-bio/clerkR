#' Synthetic regression results for clerkR examples
#'
#' @description
#' A synthetic data frame of linear regression results (outcome: log TMT
#' completion time) designed to illustrate `tbl_regression()`. Mimics the
#' output of `broom::tidy(lm(...), conf.int = TRUE)`. All values are simulated.
#'
#' @format A data frame with 7 rows and 6 variables:
#' \describe{
#'   \item{term}{Model term / predictor name (character).}
#'   \item{estimate}{Regression coefficient β (numeric).}
#'   \item{std.error}{Standard error of the estimate (numeric).}
#'   \item{conf.low}{Lower 95% confidence interval bound (numeric).}
#'   \item{conf.high}{Upper 95% confidence interval bound (numeric).}
#'   \item{p.value}{Two-tailed p-value (numeric).}
#' }
#' @source Simulated data generated in `data-raw/clerk_reg_example.R`.
"clerk_reg_example"

#' Synthetic heritability estimates for clerkR examples
#'
#' @description
#' A synthetic data frame of narrow-sense heritability (h²) estimates for
#' three cortical shape metrics across four covariate models, designed to
#' illustrate `tbl_heritability()`. Column names match the output of
#' `R-itable::herit_batch()` for direct compatibility. All values are
#' simulated.
#'
#' @format A data frame with 12 rows and 7 variables:
#' \describe{
#'   \item{trait}{Phenotype name (character).}
#'   \item{covariates}{Covariate model label (character).}
#'   \item{h2}{Narrow-sense heritability point estimate (numeric).}
#'   \item{ci_lo}{Lower 95% profile-likelihood CI bound (numeric).}
#'   \item{ci_hi}{Upper 95% profile-likelihood CI bound (numeric).}
#'   \item{pval}{One-sided LRT p-value (numeric).}
#'   \item{sigma2_a}{Additive genetic variance component (numeric).}
#'   \item{sigma2_e}{Residual variance component (numeric).}
#' }
#' @source Simulated data generated in `data-raw/clerk_h2_example.R`.
"clerk_h2_example"
