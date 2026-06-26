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
#' ## Options
#'
#' Formatting defaults (decimal places, p-value style, FDR display) are
#' controlled via `clerk_options()`. Biomed/APA defaults are loaded
#' automatically on package attach.
#'
#' @keywords internal
"_PACKAGE"

utils::globalVariables(".data")
