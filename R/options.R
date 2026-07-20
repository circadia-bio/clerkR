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
#' @param p_threshold Numeric. Raw p-values below this are shown as
#'   `"< {threshold}"` (default `0.001`). Display only, not a significance
#'   threshold.
#' @param p_style Character string controlling p-value display style:
#'   \describe{
#'     \item{`"apa"`}{APA format: `= 0.032`, `< 0.001` (default).}
#'     \item{`"plain"`}{Plain decimal: `0.032`, `< 0.001`.}
#'     \item{`"stars"`}{Significance stars only, no numeric p.}
#'     \item{`"stars_p"`}{Stars alongside numeric p.}
#'   }
#' @param stars Logical. Append significance stars (default `FALSE`).
#' @param star_thresholds Numeric vector of length 3. Cutoffs for `*`, `**`,
#'   `***` (default `c(0.05, 0.01, 0.001)`).
#' @param fdr_ns Logical. Replace the FDR p-value cell with `fdr_ns_label`
#'   when `p(FDR) >= fdr_alpha` (default `TRUE`).
#' @param fdr_alpha Numeric. Alpha applied to the BH-adjusted p-value.
#'   Cells where `p(FDR) >= fdr_alpha` show `fdr_ns_label` (default `0.05`).
#' @param fdr_ns_label Character string for non-surviving FDR cells
#'   (default `"ns"`).
#' @param domain_other Character string used as the domain label for variables
#'   not assigned to any domain, and for all variables when no domains are
#'   specified. Default `""` (blank — no section header shown). Set to e.g.
#'   `"Other"` to collect unassigned variables under a named section.
#' @param reset Logical. Restore factory defaults (default `FALSE`).
#'
#' @return A named list of current option values, returned invisibly.
#'
#' @examples
#' clerk_options()
#' clerk_options(p_style = "apa", stars = TRUE)
#' clerk_options(fdr_alpha = 0.01)
#' clerk_options(domain_other = "Other")
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
                          domain_other    = NULL,
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
    fdr_ns_label    = fdr_ns_label,
    domain_other    = domain_other
  )
  new_vals <- Filter(Negate(is.null), new_vals)

  if (length(new_vals) > 0) {
    if (!is.null(new_vals$p_style))
      new_vals$p_style <- match.arg(new_vals$p_style,
                                    c("apa", "plain", "stars", "stars_p"))
    options(stats::setNames(new_vals, paste0("clerkR.", names(new_vals))))
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
  fdr_ns_label    = "ns",
  domain_other    = ""
)

#' @keywords internal
.set_clerk_defaults <- function() {
  options(stats::setNames(.clerk_defaults,
                          paste0("clerkR.", names(.clerk_defaults))))
}

#' @keywords internal
.get_clerk_options <- function() {
  lapply(
    stats::setNames(names(.clerk_defaults), names(.clerk_defaults)),
    function(nm) getOption(paste0("clerkR.", nm), default = .clerk_defaults[[nm]])
  )
}

#' @keywords internal
.onLoad <- function(libname, pkgname) .set_clerk_defaults()

# ------------------------------------------------------------------------------
# Internal: null-coalescing operator
# ------------------------------------------------------------------------------

#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

# ------------------------------------------------------------------------------
# Shared formatting functions
# ------------------------------------------------------------------------------

#' Format a p-value according to current clerk_options.
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

  # p_style is scalar — use if/else, not ifelse, to avoid length-1 recycling
  formatted <- ifelse(
    is.na(x),
    NA_character_,
    ifelse(
      x < p_threshold,
      paste0("< ", threshold_str),
      if (p_style == "apa") paste0("= ", plain_str) else plain_str
    )
  )

  if (p_style == "stars") return(.p_stars(x, star_thresholds))
  if (isTRUE(stars) || p_style == "stars_p")
    formatted <- paste0(formatted, .p_stars(x, star_thresholds))

  formatted
}

#' Format a continuous statistic.
#' @keywords internal
.fmt_stat <- function(x, digits = NULL, signed = FALSE) {
  opts   <- .get_clerk_options()
  digits <- digits %||% opts$digits
  sprintf(paste0(if (isTRUE(signed)) "%+" else "%", ".", digits, "f"), x)
}

#' Format a correlation or h² coefficient.
#' @keywords internal
.fmt_r <- function(x, r_digits = NULL, signed = TRUE) {
  opts     <- .get_clerk_options()
  r_digits <- r_digits %||% opts$r_digits
  sprintf(paste0(if (isTRUE(signed)) "%+" else "%", ".", r_digits, "f"), x)
}

#' Generate significance stars for a p-value vector.
#' @keywords internal
.p_stars <- function(x, thresholds = c(0.05, 0.01, 0.001)) {
  ifelse(is.na(x), "",
  ifelse(x < thresholds[3], "***",
  ifelse(x < thresholds[2], "**",
  ifelse(x < thresholds[1], "*", ""))))
}
