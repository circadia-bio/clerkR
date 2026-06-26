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
| All variables          |     |                                        |
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
| All variables |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 5.992006e-01 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | 5.599878e-04 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 3.863309e-01 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 1.895409e-01 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 8.792922e-01 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | 9.521407e-05 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 1.916489e-01 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 6.062013e-01 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | 3.325514e-04 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | 1.662527e-06 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | 4.880922e-04 |

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
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Table 1. Sample characteristics by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| NA |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 5.992006e-01 |
| Metabolic |  |  |  |  |  |  |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | 5.599878e-04 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 3.863309e-01 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 1.895409e-01 |
| Anthropometric |  |  |  |  |  |  |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 8.792922e-01 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | 9.521407e-05 |
| Cognitive |  |  |  |  |  |  |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 1.916489e-01 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 6.062013e-01 |
| Mental health |  |  |  |  |  |  |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | 3.325514e-04 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | 1.662527e-06 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | 4.880922e-04 |

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
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Cognitive variables by sex |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| NA |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 5.992006e-01 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | 5.599878e-04 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 3.863309e-01 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 1.895409e-01 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 8.792922e-01 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | 9.521407e-05 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | 3.325514e-04 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | 1.662527e-06 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | 4.880922e-04 |
| Cognitive |  |  |  |  |  |  |
| tmt_time¹ | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 1.916489e-01 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 6.062013e-01 |
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
| All variables |  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 5.992006e-01 | 6.668214e-01 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | 5.599878e-04 | 1.231973e-03 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 3.863309e-01 | 5.312050e-01 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 1.895409e-01 | 3.011625e-01 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 8.792922e-01 | 8.792922e-01 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | 9.521407e-05 | 5.236774e-04 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 1.916489e-01 | 3.011625e-01 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 6.062013e-01 | 6.668214e-01 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | 3.325514e-04 | 1.219355e-03 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | 1.662527e-06 | 1.828779e-05 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | 4.880922e-04 | 1.231973e-03 |

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
| All variables |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 0.5992006373 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | 0.0005599878 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 0.3863308862 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 0.1895408997 |

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
#>              p
#> 1 5.992006e-01
#> 2 5.599878e-04
#> 3 3.863309e-01
#> 4 1.895409e-01
#> 5 8.792922e-01
#> 6 9.521407e-05
```
