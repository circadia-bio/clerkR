# Regression coefficients table

Formats a tidy data frame of regression results into a publication-ready
table. Designed to accept the output of `broom::tidy()` directly.

Column-name arguments accept **character strings** (quoted names).
Defaults match `broom::tidy(model, conf.int = TRUE)` output.

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
  digits = 3,
  p_digits = 3,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame of regression results with one row per term.

- term:

  Character string. Name of the model term column. Default `"term"`.

- estimate:

  Character string. Name of the coefficient column. Default
  `"estimate"`.

- std_error:

  Character string. Name of the standard error column. Default
  `"std.error"`.

- conf_low:

  Character string. Name of the lower CI bound column. Default
  `"conf.low"`.

- conf_high:

  Character string. Name of the upper CI bound column. Default
  `"conf.high"`.

- p:

  Character string. Name of the p-value column. Default `"p.value"`.

- model:

  Character string or `NULL`. Name of a column identifying multiple
  models. Default `NULL`.

- domains:

  A named list mapping term names to domain/section labels.

- exponentiate:

  Logical. Exponentiate estimates and CIs (default `FALSE`).

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column name to group FDR correction
  within.

- ci_sep:

  Character string separating CI bounds (default `", "`).

- digits:

  Integer. Decimal places for estimates (default `3`).

- p_digits:

  Integer. Decimal places for p-values (default `3`).

- output:

  Character string. One of `"gt"` (default), `"html"`, or `"latex"`.

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
