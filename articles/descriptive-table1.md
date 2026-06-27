# Descriptive tables (Table 1)

``` r

library(clerkR)
```

## Overview

[`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md)
produces a Table 1-style sample characteristics summary. Continuous
variables are shown as mean ± SD; categorical variables as n (%). Group
comparisons use independent-samples t-tests (two groups) or one-way
ANOVA (three or more groups) for continuous variables and chi-squared
tests for categorical variables.

## Basic usage

The minimum call needs only a data frame. Without a `group` argument you
get an overall summary column.

``` r

tbl_descriptive(
  clerk_example,
  output = "gt"
) |>
  clerk_render(title = "Sample characteristics")
```

| Sample characteristics |     |                                        |
|------------------------|-----|----------------------------------------|
|                        | n   | Overall                                |
|                        |     |                                        |
| sex                    | 300 | Female: 193 (64.3%); Male: 107 (35.7%) |
| age                    | 300 | 46.76 ± 14.15                          |
| hdl                    | 300 | 46.81 ± 10.11                          |
| glucose                | 300 | 91.68 ± 24.65                          |
| bmi                    | 300 | 26.15 ± 4.91                           |
| waist                  | 300 | 92.07 ± 11.56                          |
| systolic_bp            | 300 | 123.25 ± 17.77                         |
| tmt_time               | 300 | 129.24 ± 64.98                         |
| verbal_fluency         | 300 | 14.98 ± 4.63                           |
| bdi                    | 300 | 13.64 ± 9.26                           |
| panas_neg              | 300 | 20.98 ± 7.48                           |
| life_satisfaction      | 300 | 18.02 ± 4.23                           |

## Group comparisons

Pass an unquoted column name to `group` to add per-group columns and a
statistical test.

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  output = "gt"
) |>
  clerk_render(title = "Sample characteristics by sex")
```

| Sample characteristics by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
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

## Domain grouping

Use the `domains` argument to organise rows under labelled section
headers. Any variable not mentioned in `domains` is placed under
“Other”.

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
  output = "gt"
) |>
  clerk_render(title = "Table 1. Sample characteristics by sex")
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

| Table 1. Sample characteristics by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| NA |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| Metabolic |  |  |  |  |  |  |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| Anthropometric |  |  |  |  |  |  |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| Cognitive |  |  |  |  |  |  |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| Mental health |  |  |  |  |  |  |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |

## Log-transformed variables

Use `log_vars` to flag variables that were log-transformed before
analysis but are shown on the raw scale. A footnote is added
automatically.

``` r

tbl_descriptive(
  clerk_example,
  group    = sex,
  domains  = list(
    "Cognitive" = c("tmt_time", "verbal_fluency")
  ),
  log_vars = "tmt_time",
  output   = "gt"
) |>
  clerk_render(
    title    = "Cognitive variables by sex",
    footnote = "Continuous variables: mean \u00b1 SD. Group comparisons: t-test."
  )
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

| Cognitive variables by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| NA |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |
| Cognitive |  |  |  |  |  |  |
| tmt_time¹ | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| ¹ Log-transformed variables shown on raw scale. |  |  |  |  |  |  |
| Continuous variables: mean ± SD. Group comparisons: t-test. |  |  |  |  |  |  |

## FDR correction

Set `fdr = TRUE` to apply Benjamini-Hochberg FDR correction across all
p-values. A `p_fdr` column is added to the table.

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  fdr    = TRUE,
  output = "gt"
) |>
  clerk_render(title = "Sample characteristics by sex (FDR-corrected)")
```

| Sample characteristics by sex (FDR-corrected) |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p | p (FDR) |
|  |  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 | ns |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 | = 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 | ns |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 | ns |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 | ns |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 | ns |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 | ns |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 | = 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 | = 0.001 |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |  |  |  |

## Selecting variables

Use `vars` with `dplyr` selection helpers to include only a subset of
columns.

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  vars   = dplyr::any_of(c("age", "hdl", "glucose", "bmi")),
  output = "gt"
) |>
  clerk_render(title = "Metabolic variables by sex")
```

| Metabolic variables by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |

## HTML output

Set `output = "html"` for an interactive searchable table.

``` r

tbl_descriptive(
  clerk_example,
  group  = sex,
  output = "html"
) |>
  clerk_render()
```

## Inspecting the underlying data

The `clerk_tbl` object is a plain list. Access `$table` to see the
formatted data frame before rendering.

``` r

result <- tbl_descriptive(clerk_example, group = sex)
head(result$table)
#>      variable   n        overall         Female           Male statistic
#> 1         age 300  46.76 ± 14.15  46.42 ± 13.63  47.35 ± 15.09 t = -0.53
#> 2         hdl 300  46.81 ± 10.11   48.32 ± 9.78  44.08 ± 10.18  t = 3.50
#> 3     glucose 300  91.68 ± 24.65  92.61 ± 24.49  90.01 ± 24.96  t = 0.87
#> 4         bmi 300   26.15 ± 4.91   26.43 ± 4.84   25.64 ± 5.01  t = 1.32
#> 5       waist 300  92.07 ± 11.56  92.14 ± 11.32  91.93 ± 12.03  t = 0.15
#> 6 systolic_bp 300 123.25 ± 17.77 120.36 ± 17.86 128.48 ± 16.45 t = -3.97
#>         p
#> 1 = 0.599
#> 2 < 0.001
#> 3 = 0.386
#> 4 = 0.190
#> 5 = 0.879
#> 6 < 0.001
```
