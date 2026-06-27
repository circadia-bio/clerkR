# Regression coefficients table

Formats a tidy data frame of regression results into a publication-ready
table. Accepts `broom::tidy()` output directly. Formatting defaults
inherited from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md).

## Usage

``` r
tbl_regression(
  data,
  term = "term",
  estimate = "estimate",
  std_error = "std.error",
  conf_low = "conf.low",
  conf_high = "conf.high",
  p = "p.value",
  model = NULL,
  domains = list(),
  exponentiate = FALSE,
  fdr = FALSE,
  fdr_within = NULL,
  ci_sep = ", ",
  digits = NULL,
  p_digits = NULL,
  p_threshold = NULL,
  p_style = NULL,
  stars = NULL,
  fdr_ns = NULL,
  fdr_alpha = NULL,
  domain_other = NULL,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame of regression results.

- term:

  Character string. Model term column. Default `"term"`.

- estimate:

  Character string. Coefficient column. Default `"estimate"`.

- std_error:

  Character string. SE column. Default `"std.error"`.

- conf_low:

  Character string. Lower CI column. Default `"conf.low"`.

- conf_high:

  Character string. Upper CI column. Default `"conf.high"`.

- p:

  Character string. P-value column. Default `"p.value"`.

- model:

  Character string or `NULL`. Multiple-model column.

- domains:

  A named list mapping term names to domain/section labels.

- exponentiate:

  Logical. Exponentiate estimates and CIs (default `FALSE`).

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column to group FDR within.

- ci_sep:

  Character string separating CI bounds (default `", "`).

- digits:

  Integer. Decimal places for estimates.

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

- output:

  Character string. One of `"gt"`, `"html"`, or `"latex"`.

## Value

A `clerk_tbl` object with type `"regression"`.

## Examples

``` r
tbl_regression(
  clerk_reg_example,
  domains = list(
    "Cardiometabolic" = c("bmi", "waist", "systolic_bp"),
    "Mental health"   = c("bdi", "panas_neg")
  ),
  fdr    = TRUE,
  output = "gt"
) |> clerk_render(title = "Linear regression: TMT completion time")
#> Warning: invalid factor level, NA generated


  


Linear regression: TMT completion time
```
