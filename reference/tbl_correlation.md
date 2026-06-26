# Correlation / partial correlation table

Formats a tidy data frame of (partial) correlation results into a
publication-ready table. Expects pre-computed coefficients as a tidy
data frame with one row per predictor x outcome pair.

Column-name arguments accept **character strings** (quoted names).
Defaults match a typical correlation results frame with columns named
`variable`, `outcome`, `r`, and `p`.

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
  digits = 3,
  p_digits = 3,
  pivot = FALSE,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A tidy data frame of correlation results.

- predictor:

  Character string. Name of the predictor variable column. Default
  `"variable"`.

- outcome:

  Character string. Name of the outcome variable column. Default
  `"outcome"`.

- r:

  Character string. Name of the correlation coefficient column. Default
  `"r"`.

- p:

  Character string. Name of the p-value column. Default `"p"`.

- n:

  Character string or `NULL`. Name of the sample size column. Default
  `NULL` (omitted).

- extra_cols:

  Character vector of additional column names to carry through (e.g.
  `"hemisphere"`, `"lobe"`).

- domains:

  A named list mapping predictor variable names to domain/section
  labels.

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_within:

  Character string or `NULL`. Column name to group FDR correction within
  (e.g. `"outcome"`).

- digits:

  Integer. Decimal places for r (default `3`).

- p_digits:

  Integer. Decimal places for p-values (default `3`).

- pivot:

  Logical. Pivot to wide format with one column per outcome (default
  `FALSE`).

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
