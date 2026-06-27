# clerkR session options

`clerk_options()` gets or sets session-level formatting defaults used by
all `tbl_*` constructors. Defaults are loaded automatically when the
package is attached and follow biomed/APA conventions.

Call with no arguments to inspect current settings. Call with named
arguments to change one or more. Call with `reset = TRUE` to restore
factory defaults.

## Usage

``` r
clerk_options(
  digits = NULL,
  r_digits = NULL,
  p_digits = NULL,
  p_threshold = NULL,
  p_style = NULL,
  stars = NULL,
  star_thresholds = NULL,
  fdr_ns = NULL,
  fdr_alpha = NULL,
  fdr_ns_label = NULL,
  reset = FALSE
)
```

## Arguments

- digits:

  Integer. Decimal places for continuous summary statistics (default
  `2`).

- r_digits:

  Integer. Decimal places for correlation coefficients and h² estimates
  (default `3`).

- p_digits:

  Integer. Decimal places for p-values (default `3`).

- p_threshold:

  Numeric. Raw p-values below this are shown as `"< {threshold}"`
  (default `0.001`). Display only, not a significance threshold.

- p_style:

  Character string controlling p-value display style:

  `"apa"`

  :   APA format: `= 0.032`, `< 0.001` (default).

  `"plain"`

  :   Plain decimal: `0.032`, `< 0.001`.

  `"stars"`

  :   Significance stars only, no numeric p.

  `"stars_p"`

  :   Stars alongside numeric p.

- stars:

  Logical. Append significance stars (default `FALSE`).

- star_thresholds:

  Numeric vector of length 3. Cutoffs for `*`, `**`, `***` (default
  `c(0.05, 0.01, 0.001)`).

- fdr_ns:

  Logical. Replace the FDR p-value cell with `fdr_ns_label` when
  `p(FDR) >= fdr_alpha` (default `TRUE`).

- fdr_alpha:

  Numeric. Alpha applied to the BH-adjusted p-value. Cells where
  `p(FDR) >= fdr_alpha` show `fdr_ns_label` (default `0.05`).

- fdr_ns_label:

  Character string for non-surviving FDR cells (default `"ns"`).

- reset:

  Logical. Restore factory defaults (default `FALSE`).

## Value

A named list of current option values, returned invisibly.

## Examples

``` r
clerk_options()
clerk_options(p_style = "apa", stars = TRUE)
clerk_options(fdr_alpha = 0.01)
clerk_options(reset = TRUE)
```
