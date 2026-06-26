#' clerkR session options
#'
#' @description
#' `clerk_options()` gets or sets session-level formatting defaults used by all
#' `tbl_*` constructors. Defaults are loaded automatically when the package is
#' attached and follow biomed/APA conventions.
#'
#' Call with no arguments to inspect current settings. Call with named
#' arguments to change one or more. Call with `reset = TRUE` to restore factory
#' defaults.
#'
#' @param digits Integer. Decimal places for continuous summary statistics
#'   (default `2`).
#' @param r_digits Integer. Decimal places for correlation coefficients and h²
#'   estimates (default `3`).
#' @param p_digits Integer. Decimal places for p-values (default `3`).
#' @param p_threshold Numeric. Raw p-values **below** this are shown as
#'   `"< {threshold}"` rather than as a decimal (default `0.001`). This
#'   affects display only — it is not a significance threshold.
#' @param p_style Character string controlling p-value display style:
#'   \describe{
#'     \item{`"apa"`}{APA format: `= 0.032`, `< 0.001` (default).}
#'     \item{`"plain"`}{Plain decimal: `0.032`, `< 0.001`.}
#'     \item{`"stars"`}{Significance stars only, no numeric p.}
#'     \item{`"stars_p"`}{Stars alongside numeric p.}
#'   }
#' @param stars Logical. Append significance stars (`*`/`**`/`***`) to p-value
#'   cells (default `FALSE`).
#' @param star_thresholds Numeric vector of length 3. P-value cutoffs for one,
#'   two, and three stars respectively (default `c(0.05, 0.01, 0.001)`).
#' @param fdr_ns Logical. Replace the FDR-corrected p-value cell with
#'   `fdr_ns_label` when the **FDR-corrected** p-value does not survive
#'   `fdr_alpha` (default `TRUE`). The raw p-value column is unaffected.
#' @param fdr_alpha Numeric. Alpha level applied to the **FDR-corrected**
#'   p-value to determine survival. Cells where `p(FDR) >= fdr_alpha` are
#'   replaced with `fdr_ns_label` when `fdr_ns = TRUE` (default `0.05`).
#'   Compared against the BH-adjusted p-value, not the raw p.
#' @param fdr_ns_label Character string displayed when a FDR-corrected p-value
#'   does not survive `fdr_alpha` (default `"ns"`).
#' @param reset Logical. If `TRUE`, restore all options to factory defaults
#'   (default `FALSE`).
#'
#' @return A named list of current option values, returned invisibly.
#'
#' @examples
#' # Inspect current settings
#' clerk_options()
#'
#' # APA style with stars; ns where FDR does not survive at 0.05
#' clerk_options(p_style = "apa", stars = TRUE, fdr_ns = TRUE, fdr_alpha = 0.05)
#'
#' # Stricter FDR survival threshold
#' clerk_options(fdr_alpha = 0.01)
#'
#' # Restore defaults
#' clerk_options(reset = TRUE)
#'
#' @export
clerk_options <- function(digits          = NULL,
                          r_digits        = NULL,
                          p_digits        = NULL,
                          p_threshold     = NULL,
                          p_style         = NULL,
                          stars           = NULL,
                          star_thresholds = NULL,
                          fdr_ns          = NULL,
                          fdr_alpha       = NULL,
                          fdr_ns_label    = NULL,
                          reset           = FALSE) {

  if (reset) {
    .set_clerk_defaults()
    return(invisible(.get_clerk_options()))
  }

  new_vals <- list(
    digits          = digits,
    r_digits        = r_digits,
    p_digits        = p_digits,
    p_threshold     = p_threshold,
    p_style         = p_style,
    stars           = stars,
    star_thresholds = star_thresholds,
    fdr_ns          = fdr_ns,
    fdr_alpha       = fdr_alpha,
    fdr_ns_label    = fdr_ns_label
  )
  new_vals <- Filter(Negate(is.null), new_vals)

  if (length(new_vals) > 0) {
    if (!is.null(new_vals$p_style)) {
      new_vals$p_style <- match.arg(
        new_vals$p_style,
        c("apa", "plain", "stars", "stars_p")
      )
    }
    opts <- stats::setNames(new_vals, paste0("clerkR.", names(new_vals)))
    options(opts)
  }

  invisible(.get_clerk_options())
}

# ------------------------------------------------------------------------------
# Internal: defaults, get/set
# ------------------------------------------------------------------------------

#' @keywords internal
.clerk_defaults <- list(
  digits          = 2L,
  r_digits        = 3L,
  p_digits        = 3L,
  p_threshold     = 0.001,
  p_style         = "apa",
  stars           = FALSE,
  star_thresholds = c(0.05, 0.01, 0.001),
  fdr_ns          = TRUE,
  fdr_alpha       = 0.05,
  fdr_ns_label    = "ns"
)

#' @keywords internal
.set_clerk_defaults <- function() {
  opts <- stats::setNames(
    .clerk_defaults,
    paste0("clerkR.", names(.clerk_defaults))
  )
  options(opts)
}

#' Get current clerk options, falling back to built-in defaults if an option
#' has not been set (e.g. before .onLoad has run in a load_all() session).
#' @keywords internal
.get_clerk_options <- function() {
  lapply(
    stats::setNames(names(.clerk_defaults), names(.clerk_defaults)),
    function(nm) {
      getOption(paste0("clerkR.", nm), default = .clerk_defaults[[nm]])
    }
  )
}

#' @keywords internal
.onLoad <- function(libname, pkgname) {
  .set_clerk_defaults()
}

# ------------------------------------------------------------------------------
# Internal: null-coalescing operator
# ------------------------------------------------------------------------------

#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

# ------------------------------------------------------------------------------
# Shared formatting functions
# ------------------------------------------------------------------------------

#' Format a p-value according to current clerk_options
#' @keywords internal
.fmt_p <- function(x,
                   p_digits        = NULL,
                   p_threshold     = NULL,
                   p_style         = NULL,
                   stars           = NULL,
                   star_thresholds = NULL) {

  opts            <- .get_clerk_options()
  p_digits        <- p_digits        %||% opts$p_digits
  p_threshold     <- p_threshold     %||% opts$p_threshold
  p_style         <- p_style         %||% opts$p_style
  stars           <- stars           %||% opts$stars
  star_thresholds <- star_thresholds %||% opts$star_thresholds

  threshold_str <- sprintf(paste0("%.", p_digits, "f"), p_threshold)
  plain_str     <- sprintf(paste0("%.", p_digits, "f"), x)

  formatted <- ifelse(
    is.na(x),
    NA_character_,
    ifelse(
      x < p_threshold,
      paste0("< ", threshold_str),
      ifelse(
        p_style == "apa",
        paste0("= ", plain_str),
        plain_str
      )
    )
  )

  if (p_style == "stars") {
    return(.p_stars(x, star_thresholds))
  }

  if (isTRUE(stars) || p_style == "stars_p") {
    formatted <- paste0(formatted, .p_stars(x, star_thresholds))
  }

  formatted
}

#' Format a BH-adjusted p-value, replacing non-survivors with ns label.
#' x must be the BH-adjusted p-value — it is compared directly against
#' fdr_alpha, not against the raw p.
#' @keywords internal
.fmt_p_fdr <- function(x,
                       fdr_ns       = NULL,
                       fdr_alpha    = NULL,
                       fdr_ns_label = NULL,
                       ...) {

  opts         <- .get_clerk_options()
  fdr_ns       <- fdr_ns       %||% opts$fdr_ns
  fdr_alpha    <- fdr_alpha    %||% opts$fdr_alpha
  fdr_ns_label <- fdr_ns_label %||% opts$fdr_ns_label

  formatted <- .fmt_p(x, ...)

  # Replace non-surviving FDR cells: p(FDR) >= fdr_alpha → "ns"
  if (isTRUE(fdr_ns)) {
    formatted <- ifelse(
      !is.na(x) & x >= fdr_alpha,
      fdr_ns_label,
      formatted
    )
  }

  formatted
}

#' Format a continuous statistic
#' @keywords internal
.fmt_stat <- function(x, digits = NULL, signed = FALSE) {
  opts   <- .get_clerk_options()
  digits <- digits %||% opts$digits
  fmt    <- paste0(if (isTRUE(signed)) "%+" else "%", ".", digits, "f")
  sprintf(fmt, x)
}

#' Format a correlation or h² coefficient
#' @keywords internal
.fmt_r <- function(x, r_digits = NULL, signed = TRUE) {
  opts     <- .get_clerk_options()
  r_digits <- r_digits %||% opts$r_digits
  fmt      <- paste0(if (isTRUE(signed)) "%+" else "%", ".", r_digits, "f")
  sprintf(fmt, x)
}

#' Generate significance stars for a p-value vector
#' @keywords internal
.p_stars <- function(x, thresholds = c(0.05, 0.01, 0.001)) {
  ifelse(
    is.na(x), "",
    ifelse(x < thresholds[3], "***",
    ifelse(x < thresholds[2], "**",
    ifelse(x < thresholds[1], "*", "")))
  )
}
