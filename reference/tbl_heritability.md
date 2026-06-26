# Heritability and variance components table

Formats a tidy data frame of narrow-sense heritability estimates (h2)
into a publication-ready table. Column-name defaults match the output of
`R-itable::herit_batch()` directly.

Column-name arguments accept **character strings** (quoted names).

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
  digits = 2,
  p_digits = 3,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame with one row per trait x covariate model.

- metric:

  Character string. Name of the trait/phenotype column. Default
  `"trait"` (matches `herit_batch()`).

- h2:

  Character string. Name of the h2 estimate column. Default `"h2"`.

- ci_low:

  Character string. Name of the lower 95% CI bound column. Default
  `"ci_lo"` (matches `herit_batch()`).

- ci_high:

  Character string. Name of the upper 95% CI bound column. Default
  `"ci_hi"` (matches `herit_batch()`).

- p:

  Character string. Name of the one-sided LRT p-value column. Default
  `"pval"` (matches `herit_batch()`).

- sigma2_a:

  Character string or `NULL`. Name of the additive genetic variance
  column. Default `NULL`.

- sigma2_e:

  Character string or `NULL`. Name of the residual variance column.
  Default `NULL`.

- model:

  Character string or `NULL`. Name of a column identifying covariate
  models. Pass `"covariates"` when using `herit_batch()` output. Default
  `NULL`.

- domains:

  A named list mapping trait names to domain/section labels.

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column name to group FDR correction
  within.

- digits:

  Integer. Decimal places for h2 and variance components (default `2`).

- p_digits:

  Integer. Decimal places for p-values (default `3`).

- output:

  Character string. One of `"gt"` (default), `"html"`, or `"latex"`.

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
) |> clerk_render(title = "Heritability estimates for cortical shape metrics")


  


Heritability estimates for cortical shape metrics
```
