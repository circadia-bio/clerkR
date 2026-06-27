# Heritability and variance components table

Formats a tidy data frame of narrow-sense heritability estimates (h2)
into a publication-ready table. Column-name defaults match
`R-itable::herit_batch()` output directly. Formatting defaults inherited
from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md).

## Usage

``` r
tbl_heritability(
  data,
  metric = "trait",
  h2 = "h2",
  ci_low = "ci_lo",
  ci_high = "ci_hi",
  p = "pval",
  sigma2_a = NULL,
  sigma2_e = NULL,
  model = NULL,
  domains = list(),
  fdr = FALSE,
  fdr_within = NULL,
  r_digits = NULL,
  p_digits = NULL,
  p_style = NULL,
  stars = NULL,
  fdr_ns = NULL,
  fdr_alpha = NULL,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame with one row per trait x covariate model.

- metric:

  Character string. Trait column name. Default `"trait"`.

- h2:

  Character string. h2 estimate column. Default `"h2"`.

- ci_low:

  Character string. Lower CI column. Default `"ci_lo"`.

- ci_high:

  Character string. Upper CI column. Default `"ci_hi"`.

- p:

  Character string. P-value column. Default `"pval"`.

- sigma2_a:

  Character string or `NULL`. Additive genetic variance column.

- sigma2_e:

  Character string or `NULL`. Residual variance column.

- model:

  Character string or `NULL`. Covariate model column. Pass
  `"covariates"` for `herit_batch()` output.

- domains:

  A named list mapping trait names to domain/section labels.

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column to group FDR within.

- r_digits:

  Integer. Decimal places for h2 and variance components.

- p_digits:

  Integer. Decimal places for p-values.

- p_style:

  Character. P-value style.

- stars:

  Logical. Append significance stars.

- fdr_ns:

  Logical. Replace non-surviving FDR p-values with `"ns"`.

- fdr_alpha:

  Numeric. Alpha level for FDR survival (BH-adjusted p).

- output:

  Character string. One of `"gt"`, `"html"`, or `"latex"`.

## Value

A `clerk_tbl` object with type `"heritability"`.

## Examples

``` r
tbl_heritability(
  clerk_h2_example,
  model    = "covariates",
  sigma2_a = "sigma2_a",
  sigma2_e = "sigma2_e",
  fdr      = TRUE,
  output   = "gt"
) |> clerk_render(title = "Heritability estimates")


  


Heritability estimates
```
