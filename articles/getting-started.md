# Getting started with clerkR

## Overview

`clerkR` turns standard R data frames into publication-ready tables for
biomedical and neuroscience manuscripts. It covers five table archetypes
that together account for the large majority of results tables in a
typical paper:

| Function | Purpose |
|----|----|
| [`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md) | Sample characteristics by group (Table 1) |
| [`tbl_simple()`](https://clerkr.circadia-lab.uk/reference/tbl_simple.md) | Descriptive summary without inferential tests |
| [`tbl_correlation()`](https://clerkr.circadia-lab.uk/reference/tbl_correlation.md) | Partial correlations — r, p, FDR-corrected p |
| [`tbl_regression()`](https://clerkr.circadia-lab.uk/reference/tbl_regression.md) | Regression coefficients — β, SE, CI, p |
| [`tbl_heritability()`](https://clerkr.circadia-lab.uk/reference/tbl_heritability.md) | Heritability estimates — h², CI, LRT p, σ²a/σ²e |

Every function follows the same two-step pattern:

1.  **Construct** — call a `tbl_*()` function to build a `clerk_tbl`
    object.
2.  **Render** — pipe into
    [`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md)
    to produce the output format you need: `gt` for Word/PDF, `html` for
    an interactive table, or `latex` for a manuscript compiled with a
    LaTeX engine.

``` r
tbl_*(data, ..., output = "gt") |>
  clerk_render(title = "My table")
```

The output format is set once at construction time via the `output`
argument and travels with the object, so
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md)
always knows what to produce.

## Installation

``` r

remotes::install_github("circadia-bio/clerkR")
```

## The example datasets

`clerkR` ships with four synthetic datasets — all values are simulated
and bear no relation to any real study.

``` r

library(clerkR)
```

``` r

# 300 participants, demographic + metabolic + cognitive + mental health
head(clerk_example, 3)
#>      sex  age   hdl glucose  bmi waist systolic_bp tmt_time verbal_fluency bdi
#> 1   Male 46.4 29.96    55.0 26.6  87.1         130    140.2             12  24
#> 2   Male 23.7 40.49    47.2 27.6  90.3         102     95.5             22   0
#> 3 Female 64.5 51.71    84.2 26.5 100.6         117    122.1             17   6
#>   panas_neg life_satisfaction
#> 1         7                25
#> 2        29                16
#> 3        19                25

# 16 predictor × outcome partial correlation results
head(clerk_cor_example, 3)
#>   variable  outcome   n      r     p
#> 1      hdl tmt_time 270  0.190 0.008
#> 2  glucose tmt_time 254 -0.229 0.398
#> 3      bmi tmt_time 290 -0.086 0.013

# 7 regression terms (broom::tidy() format)
clerk_reg_example
#>          term estimate std.error conf.low conf.high p.value
#> 1         bmi    0.021     0.023   -0.024     0.066   0.012
#> 2       waist   -0.018     0.024   -0.065     0.029   0.048
#> 3 systolic_bp    0.012     0.011   -0.010     0.034   0.210
#> 4         bdi    0.008     0.022   -0.035     0.051   0.330
#> 5   panas_neg    0.015     0.018   -0.020     0.050   0.041
#> 6         age    0.003     0.015   -0.026     0.032   0.610
#> 7     sexMale   -0.045     0.020   -0.084    -0.006   0.003

# 12 heritability estimates (herit_batch() format)
head(clerk_h2_example, 3)
#>           trait covariates   h2 ci_lo ci_hi  pval sigma2_a sigma2_e
#> 1   K (tension)      unadj 0.48  0.28  0.70 5e-04    0.312    0.338
#> 2     S (shape)      unadj 0.73  0.57  0.88 8e-04    0.474    0.176
#> 3 I (isometric)      unadj 0.45  0.27  0.64 9e-04    0.293    0.358
```

## A minimal Table 1

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  output = "gt"
) |>
  clerk_render(title = "Table 1. Sample characteristics by sex")
```

| Table 1. Sample characteristics by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| All variables |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |

## Adding domain grouping

Group rows under section labels with the `domains` argument — a named
list mapping variable names to section headers.

``` r

tbl_descriptive(
  clerk_example,
  group   = sex,
  domains = list(
    "Metabolic"      = c("hdl", "glucose", "bmi"),
    "Anthropometric" = c("waist", "systolic_bp"),
    "Cognitive"      = c("tmt_time", "verbal_fluency"),
    "Mental health"  = c("bdi", "panas_neg", "life_satisfaction")
  ),
  log_vars = "tmt_time",
  fdr      = TRUE,
  output   = "gt"
) |>
  clerk_render(title = "Table 1. Sample characteristics by sex")
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Table 1. Sample characteristics by sex |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p | p (FDR) |
| NA |  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 | ns |
| Metabolic |  |  |  |  |  |  |  |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 | = 0.667 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 | ns |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 | ns |
| Anthropometric |  |  |  |  |  |  |  |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 | ns |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 | \< 0.001 |
| Cognitive |  |  |  |  |  |  |  |
| tmt_time¹ | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 | ns |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 | ns |
| Mental health |  |  |  |  |  |  |  |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 | = 0.667 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 | = 0.667 |
| ¹ Log-transformed variables shown on raw scale. |  |  |  |  |  |  |  |

## Changing the output format

Swap `output = "gt"` for `output = "html"` to get an interactive
`reactable` table, or `output = "latex"` for LaTeX source.

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  output = "html"
) |>
  clerk_render()
```

## The clerkR palette

All tables are styled with the clerkR colour palette automatically via
[`clerk_theme()`](https://clerkr.circadia-lab.uk/reference/clerk_theme.md).
You can also access the palette directly for use in figures:

``` r

clerk_palette()
#>         navy     mid_blue   light_teal   near_white   terracotta    header_bg 
#>    "#293681"    "#4274D9"    "#95CCDD"    "#D0E7E6"    "#D4907E"    "#95CCDD" 
#>  header_text row_group_bg    body_text     positive     negative      neutral 
#>    "#293681"    "#D0E7E6"    "#293681"    "#293681"    "#D4907E"    "#F0EEEC"
clerk_diverging(n = 9)   # terracotta → off-white → navy
#> [1] "#D4907E" "#DBA799" "#E2BFB5" "#E9D6D0" "#F0EEEC" "#BEC0D1" "#8C92B6"
#> [8] "#5A649B" "#293681"
clerk_sequential(n = 7)  # near-white → navy
#> [1] "#D0E7E6" "#B2D9E1" "#95CCDD" "#6BA0DB" "#4274D9" "#3555AD" "#293681"
```

## What next?

Each archetype has its own vignette with a full worked example:

- **[`vignette("descriptive-table1")`](https://clerkr.circadia-lab.uk/articles/descriptive-table1.md)**
  — Table 1 with group comparisons
- **[`vignette("simple-descriptive")`](https://clerkr.circadia-lab.uk/articles/simple-descriptive.md)**
  — Summary table without tests
- **[`vignette("correlation")`](https://clerkr.circadia-lab.uk/articles/correlation.md)**
  — Partial correlation results
- **[`vignette("regression")`](https://clerkr.circadia-lab.uk/articles/regression.md)**
  — Regression coefficient tables
- **[`vignette("heritability-ritable")`](https://clerkr.circadia-lab.uk/articles/heritability-ritable.md)**
  — Heritability with R-itable
