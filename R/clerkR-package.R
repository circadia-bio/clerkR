#' clerkR: Publication-Ready Tables for Biomedical Research
#'
#' @description
#' `clerkR` transforms standard R data frames into publication-ready tables
#' across a handful of common archetypes found in biomedical and neuroscience
#' manuscripts.
#'
#' ## Table archetypes
#'
#' - **Descriptive / Table 1** (`tbl_descriptive()`): sample characteristics
#'   with group comparisons, mean ± SD, t-test / chi-squared statistics.
#' - **Heritability** (`tbl_heritability()`): h2, confidence intervals, LRT p,
#'   variance components. Directly compatible with `R-itable::herit_batch()`.
#' - **Correlation** (`tbl_correlation()`): r, p, FDR-corrected p, domain
#'   grouping.
#' - **Regression** (`tbl_regression()`): beta, SE, CI, p, FDR annotation.
#' - **Simple descriptive** (`tbl_simple()`): means/SDs, no inferential test.
#'
#' ## Rendering
#'
#' All constructors return a `clerk_tbl` S3 object. Pass to `clerk_render()`
#' to dispatch to `gt` (Word/PDF), `reactable` (HTML), or LaTeX output.
#'
#' @keywords internal
"_PACKAGE"

# Declare bare names used as default arguments or in tidy-eval contexts so
# R CMD CHECK does not flag them as undefined globals.
utils::globalVariables(c(
  # tbl_correlation defaults
  "variable", "outcome", "r", "p", "n",
  # tbl_regression defaults
  "term", "estimate", "std.error", "conf.low", "conf.high", "p.value",
  # tbl_heritability defaults (matching herit_batch() output)
  "trait", "h2", "ci_lo", "ci_hi", "pval", "sigma2_a", "sigma2_e",
  "covariates",
  # tidy-eval pronoun
  ".data"
))
