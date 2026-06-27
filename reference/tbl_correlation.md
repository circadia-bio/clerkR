# Correlation / partial correlation table

Formats a tidy data frame of (partial) correlation results into a
publication-ready table. Column-name arguments accept character strings.
Defaults match a typical correlation results frame with columns named
`variable`, `outcome`, `r`, and `p`.

Formatting defaults are inherited from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md)
and can be overridden per call.

## Usage

``` r
tbl_correlation(
  data,
  predictor = "variable",
  outcome = "outcome",
  r = "r",
  p = "p",
  n = NULL,
  extra_cols = NULL,
  domains = list(),
  fdr = FALSE,
  fdr_within = NULL,
  r_digits = NULL,
  p_digits = NULL,
  p_threshold = NULL,
  p_style = NULL,
  stars = NULL,
  fdr_ns = NULL,
  fdr_alpha = NULL,
  domain_other = NULL,
  pivot = FALSE,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame of correlation results.

- predictor:

  Character string. Predictor column name. Default `"variable"`.

- outcome:

  Character string. Outcome column name. Default `"outcome"`.

- r:

  Character string. Correlation coefficient column. Default `"r"`.

- p:

  Character string. P-value column. Default `"p"`.

- n:

  Character string or `NULL`. Sample size column. Default `NULL`.

- extra_cols:

  Character vector of additional columns to carry through.

- domains:

  A named list mapping predictor names to domain/section labels.

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column to group FDR within.

- r_digits:

  Integer. Decimal places for r.

- p_digits:

  Integer. Decimal places for p-values.

- p_threshold:

  Numeric. P-values below this are shown as `"< {threshold}"`. Inherits
  from `clerk_options()$p_threshold` if `NULL`.

- p_style:

  Character. P-value style.

- stars:

  Logical. Append significance stars.

- fdr_ns:

  Logical. Replace non-surviving FDR p-values with `"ns"`.

- fdr_alpha:

  Numeric. Alpha level for FDR survival (BH-adjusted p).

- domain_other:

  Character string. Label for variables not assigned to any domain.
  Default `""` (blank). Inherits from `clerk_options()$domain_other`.

- pivot:

  Logical. Pivot to wide format (default `FALSE`).

- output:

  Character string. One of `"gt"` (default), `"html"`, or `"latex"`.

## Value

A `clerk_tbl` object with type `"correlation"`.

## Examples

``` r
tbl_correlation(
  clerk_cor_example,
  domains = list(
    "Metabolic"      = c("hdl", "glucose", "bmi"),
    "Anthropometric" = c("waist", "systolic_bp"),
    "Mental health"  = c("bdi", "panas_neg")
  ),
  fdr    = TRUE,
  output = "gt"
) |> clerk_render(title = "Partial correlations (age + sex controlled)")
#> Warning: invalid factor level, NA generated


  


Partial correlations (age + sex controlled)
```
