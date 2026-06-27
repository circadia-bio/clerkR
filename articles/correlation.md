# Correlation and partial correlation tables

``` r

library(clerkR)
```

## Overview

[`tbl_correlation()`](https://clerkr.circadia-lab.uk/reference/tbl_correlation.md)
formats a tidy data frame of (partial) correlation results into a
publication-ready table. It expects **pre-computed** coefficients as a
tidy data frame with one row per predictor x outcome pair.

Column-name arguments take **quoted strings**. Defaults match a typical
correlation results frame with columns named `variable`, `outcome`, `r`,
`p`:

``` r

head(clerk_cor_example)
#>      variable  outcome   n      r     p
#> 1         hdl tmt_time 270  0.190 0.008
#> 2     glucose tmt_time 254 -0.229 0.398
#> 3         bmi tmt_time 290 -0.086 0.013
#> 4       waist tmt_time 253  0.279 0.002
#> 5 systolic_bp tmt_time 242  0.195 0.379
#> 6         bdi tmt_time 281  0.096 0.109
```

## Basic long-format table

Since `clerk_cor_example` already matches all defaults, a minimal call
suffices:

``` r

tbl_correlation(
  clerk_cor_example,
  output = "gt"
) |>
  clerk_render(title = "Partial correlations (age + sex controlled)")
```

| Partial correlations (age + sex controlled) |                |        |         |
|---------------------------------------------|----------------|--------|---------|
|                                             | Outcome        | r      | p       |
| All variables                               |                |        |         |
| hdl                                         | tmt_time       | +0.190 | = 0.008 |
| glucose                                     | tmt_time       | -0.229 | = 0.398 |
| bmi                                         | tmt_time       | -0.086 | = 0.013 |
| waist                                       | tmt_time       | +0.279 | = 0.002 |
| systolic_bp                                 | tmt_time       | +0.195 | = 0.379 |
| bdi                                         | tmt_time       | +0.096 | = 0.109 |
| panas_neg                                   | tmt_time       | +0.157 | = 0.006 |
| life_satisfaction                           | tmt_time       | +0.247 | = 0.117 |
| hdl                                         | verbal_fluency | +0.078 | = 0.072 |
| glucose                                     | verbal_fluency | +0.216 | = 0.003 |
| bmi                                         | verbal_fluency | +0.022 | = 0.207 |
| waist                                       | verbal_fluency | +0.047 | = 0.185 |
| systolic_bp                                 | verbal_fluency | -0.105 | = 0.077 |
| bdi                                         | verbal_fluency | -0.176 | = 0.070 |
| panas_neg                                   | verbal_fluency | +0.232 | = 0.117 |
| life_satisfaction                           | verbal_fluency | +0.201 | = 0.234 |

## Including sample size

Pass the column name as a string to `n`:

``` r

tbl_correlation(
  clerk_cor_example,
  n      = "n",
  output = "gt"
) |>
  clerk_render(title = "Partial correlations (age + sex controlled)")
```

| Partial correlations (age + sex controlled) |  |  |  |  |
|----|----|----|----|----|
|  | Outcome | n | r | p |
| All variables |  |  |  |  |
| hdl | tmt_time | 270 | +0.190 | = 0.008 |
| glucose | tmt_time | 254 | -0.229 | = 0.398 |
| bmi | tmt_time | 290 | -0.086 | = 0.013 |
| waist | tmt_time | 253 | +0.279 | = 0.002 |
| systolic_bp | tmt_time | 242 | +0.195 | = 0.379 |
| bdi | tmt_time | 281 | +0.096 | = 0.109 |
| panas_neg | tmt_time | 289 | +0.157 | = 0.006 |
| life_satisfaction | tmt_time | 293 | +0.247 | = 0.117 |
| hdl | verbal_fluency | 282 | +0.078 | = 0.072 |
| glucose | verbal_fluency | 276 | +0.216 | = 0.003 |
| bmi | verbal_fluency | 291 | +0.022 | = 0.207 |
| waist | verbal_fluency | 253 | +0.047 | = 0.185 |
| systolic_bp | verbal_fluency | 293 | -0.105 | = 0.077 |
| bdi | verbal_fluency | 264 | -0.176 | = 0.070 |
| panas_neg | verbal_fluency | 265 | +0.232 | = 0.117 |
| life_satisfaction | verbal_fluency | 266 | +0.201 | = 0.234 |

## Domain grouping

``` r

tbl_correlation(
  clerk_cor_example,
  n       = "n",
  domains = list(
    "Metabolic"      = c("hdl", "glucose", "bmi"),
    "Anthropometric" = c("waist", "systolic_bp"),
    "Mental health"  = c("bdi", "panas_neg", "life_satisfaction")
  ),
  output = "gt"
) |>
  clerk_render(title = "Partial correlations (age + sex controlled)")
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Partial correlations (age + sex controlled) |  |  |  |  |
|----|----|----|----|----|
|  | Outcome | n | r | p |
| Metabolic |  |  |  |  |
| hdl | tmt_time | 270 | +0.190 | = 0.008 |
| glucose | tmt_time | 254 | -0.229 | = 0.398 |
| bmi | tmt_time | 290 | -0.086 | = 0.013 |
| hdl | verbal_fluency | 282 | +0.078 | = 0.072 |
| glucose | verbal_fluency | 276 | +0.216 | = 0.003 |
| bmi | verbal_fluency | 291 | +0.022 | = 0.207 |
| Anthropometric |  |  |  |  |
| waist | tmt_time | 253 | +0.279 | = 0.002 |
| systolic_bp | tmt_time | 242 | +0.195 | = 0.379 |
| waist | verbal_fluency | 253 | +0.047 | = 0.185 |
| systolic_bp | verbal_fluency | 293 | -0.105 | = 0.077 |
| Mental health |  |  |  |  |
| bdi | tmt_time | 281 | +0.096 | = 0.109 |
| panas_neg | tmt_time | 289 | +0.157 | = 0.006 |
| life_satisfaction | tmt_time | 293 | +0.247 | = 0.117 |
| bdi | verbal_fluency | 264 | -0.176 | = 0.070 |
| panas_neg | verbal_fluency | 265 | +0.232 | = 0.117 |
| life_satisfaction | verbal_fluency | 266 | +0.201 | = 0.234 |

## FDR correction

Set `fdr = TRUE` to add a BH-corrected `p_fdr` column. Use `fdr_within`
to correct separately within each outcome:

``` r

tbl_correlation(
  clerk_cor_example,
  fdr        = TRUE,
  fdr_within = "outcome",
  output     = "gt"
) |>
  clerk_render(
    title    = "Partial correlations (age + sex controlled)",
    footnote = "FDR correction applied within each outcome (BH)."
  )
```

| Partial correlations (age + sex controlled) |  |  |  |  |
|----|----|----|----|----|
|  | Outcome | r | p | p (FDR) |
| All variables |  |  |  |  |
| hdl | tmt_time | +0.190 | = 0.008 | = 0.021 |
| glucose | tmt_time | -0.229 | = 0.398 | ns |
| bmi | tmt_time | -0.086 | = 0.013 | = 0.026 |
| waist | tmt_time | +0.279 | = 0.002 | = 0.016 |
| systolic_bp | tmt_time | +0.195 | = 0.379 | ns |
| bdi | tmt_time | +0.096 | = 0.109 | ns |
| panas_neg | tmt_time | +0.157 | = 0.006 | = 0.021 |
| life_satisfaction | tmt_time | +0.247 | = 0.117 | ns |
| hdl | verbal_fluency | +0.078 | = 0.072 | ns |
| glucose | verbal_fluency | +0.216 | = 0.003 | = 0.024 |
| bmi | verbal_fluency | +0.022 | = 0.207 | ns |
| waist | verbal_fluency | +0.047 | = 0.185 | ns |
| systolic_bp | verbal_fluency | -0.105 | = 0.077 | ns |
| bdi | verbal_fluency | -0.176 | = 0.070 | ns |
| panas_neg | verbal_fluency | +0.232 | = 0.117 | ns |
| life_satisfaction | verbal_fluency | +0.201 | = 0.234 | ns |
| FDR correction applied within each outcome (BH). |  |  |  |  |

## Wide (pivoted) format

Set `pivot = TRUE` to show one column per outcome, with r (p) values in
each cell:

``` r

tbl_correlation(
  clerk_cor_example,
  domains = list(
    "Metabolic"    = c("hdl", "glucose", "bmi"),
    "Mental health"= c("bdi", "panas_neg")
  ),
  fdr    = TRUE,
  pivot  = TRUE,
  output = "gt"
) |>
  clerk_render(
    title    = "Partial correlations (age + sex controlled)",
    footnote = "Values shown as r (p FDR). FDR-corrected p-value (BH)."
  )
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Partial correlations (age + sex controlled) |  |  |
|----|----|----|
|  | tmt_time | verbal_fluency |
| Metabolic |  |  |
| hdl | +0.190 (= 0.032) | +0.078 (ns) |
| glucose | -0.229 (ns) | +0.216 (= 0.024) |
| bmi | -0.086 (= 0.042) | +0.022 (ns) |
| NA |  |  |
| waist | +0.279 (= 0.024) | +0.047 (ns) |
| systolic_bp | +0.195 (ns) | -0.105 (ns) |
| life_satisfaction | +0.247 (ns) | +0.201 (ns) |
| Mental health |  |  |
| bdi | +0.096 (ns) | -0.176 (ns) |
| panas_neg | +0.157 (= 0.032) | +0.232 (ns) |
| Values shown as r (p FDR). FDR-corrected p-value (BH). |  |  |

## Custom column names

When your results frame uses different column names, pass them as
strings:

``` r

my_results <- data.frame(
  predictor_var = c("bmi", "hdl"),
  outcome_var   = c("tmt_time", "tmt_time"),
  rho           = c(0.12, -0.08),
  pval          = c(0.021, 0.140),
  sample_n      = c(249, 249)
)

tbl_correlation(
  my_results,
  predictor = "predictor_var",
  outcome   = "outcome_var",
  r         = "rho",
  p         = "pval",
  n         = "sample_n",
  fdr       = TRUE,
  output    = "gt"
) |>
  clerk_render(title = "Partial correlations (age + sex controlled)")
```

## HTML output

``` r

tbl_correlation(
  clerk_cor_example,
  domains = list(
    "Metabolic"    = c("hdl", "glucose", "bmi"),
    "Mental health"= c("bdi", "panas_neg")
  ),
  fdr    = TRUE,
  output = "html"
) |>
  clerk_render()
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```
