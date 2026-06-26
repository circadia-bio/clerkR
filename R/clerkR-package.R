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
#'   variance components.
#' - **Correlation** (`tbl_correlation()`): r, p, FDR-corrected p, domain
#'   grouping.
#' - **Regression** (`tbl_regression()`): beta, SE, CI, p, FDR annotation.
#' - **Simple descriptive** (`tbl_simple()`): means/SDs, no inferential test.
#'
#' ## Rendering
#'
#' All constructors return a `clerk_tbl` S3 object. Use `render_gt()` for
#' Word/PDF output and `render_reactable()` for interactive HTML.
#'
#' @keywords internal
"_PACKAGE"
