# Simple descriptive tables

``` r

library(clerkR)
```

## Overview

[`tbl_simple()`](https://clerkr.circadia-lab.uk/reference/tbl_simple.md)
produces a concise descriptive summary — mean ± SD for continuous
variables and n (%) for categorical variables — without any group
comparisons or statistical tests. It is the right choice for
supplementary tables, sub-cohort descriptions, or any context where you
need a clean summary without inference.

## Basic usage

``` r

tbl_simple(
  clerk_example,
  output = "gt"
) |>
  clerk_render(title = "Sample characteristics")
```

| Sample characteristics |     |                                        |
|------------------------|-----|----------------------------------------|
|                        | n   | Summary                                |
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

## Selecting variables

``` r

tbl_simple(
  clerk_example,
  vars   = c(age, hdl, glucose, bmi, waist),
  output = "gt"
) |>
  clerk_render(title = "Metabolic and anthropometric characteristics")
```

| Metabolic and anthropometric characteristics |     |               |
|----------------------------------------------|-----|---------------|
|                                              | n   | Summary       |
|                                              |     |               |
| age                                          | 300 | 46.76 ± 14.15 |
| hdl                                          | 300 | 46.81 ± 10.11 |
| glucose                                      | 300 | 91.68 ± 24.65 |
| bmi                                          | 300 | 26.15 ± 4.91  |
| waist                                        | 300 | 92.07 ± 11.56 |

## Domain grouping

``` r

tbl_simple(
  clerk_example,
  domains = list(
    "Metabolic"      = c("hdl", "glucose", "bmi"),
    "Anthropometric" = c("waist", "systolic_bp"),
    "Cognitive"      = c("tmt_time", "verbal_fluency"),
    "Mental health"  = c("bdi", "panas_neg", "life_satisfaction")
  ),
  output = "gt"
) |>
  clerk_render(title = "Sample characteristics")
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

| Sample characteristics |     |                                        |
|------------------------|-----|----------------------------------------|
|                        | n   | Summary                                |
| NA                     |     |                                        |
| sex                    | 300 | Female: 193 (64.3%); Male: 107 (35.7%) |
| age                    | 300 | 46.76 ± 14.15                          |
| Metabolic              |     |                                        |
| hdl                    | 300 | 46.81 ± 10.11                          |
| glucose                | 300 | 91.68 ± 24.65                          |
| bmi                    | 300 | 26.15 ± 4.91                           |
| Anthropometric         |     |                                        |
| waist                  | 300 | 92.07 ± 11.56                          |
| systolic_bp            | 300 | 123.25 ± 17.77                         |
| Cognitive              |     |                                        |
| tmt_time               | 300 | 129.24 ± 64.98                         |
| verbal_fluency         | 300 | 14.98 ± 4.63                           |
| Mental health          |     |                                        |
| bdi                    | 300 | 13.64 ± 9.26                           |
| panas_neg              | 300 | 20.98 ± 7.48                           |
| life_satisfaction      | 300 | 18.02 ± 4.23                           |

## Log-transformed variables

``` r

tbl_simple(
  clerk_example,
  domains  = list("Cognitive" = c("tmt_time", "verbal_fluency")),
  log_vars = "tmt_time",
  output   = "gt"
) |>
  clerk_render(
    title    = "Cognitive variables",
    footnote = "Values shown on raw scale."
  )
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

| Cognitive variables |  |  |
|----|----|----|
|  | n | Summary |
| NA |  |  |
| sex | 300 | Female: 193 (64.3%); Male: 107 (35.7%) |
| age | 300 | 46.76 ± 14.15 |
| hdl | 300 | 46.81 ± 10.11 |
| glucose | 300 | 91.68 ± 24.65 |
| bmi | 300 | 26.15 ± 4.91 |
| waist | 300 | 92.07 ± 11.56 |
| systolic_bp | 300 | 123.25 ± 17.77 |
| bdi | 300 | 13.64 ± 9.26 |
| panas_neg | 300 | 20.98 ± 7.48 |
| life_satisfaction | 300 | 18.02 ± 4.23 |
| Cognitive |  |  |
| tmt_time¹ | 300 | 129.24 ± 64.98 |
| verbal_fluency | 300 | 14.98 ± 4.63 |
| ¹ Log-transformed variables shown on raw scale. |  |  |
| Values shown on raw scale. |  |  |

## HTML output

``` r

tbl_simple(
  clerk_example,
  domains = list(
    "Metabolic"    = c("hdl", "glucose", "bmi"),
    "Mental health"= c("bdi", "panas_neg")
  ),
  output = "html"
) |>
  clerk_render()
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

## When to use `tbl_simple()` vs `tbl_descriptive()`

Use
[`tbl_simple()`](https://clerkr.circadia-lab.uk/reference/tbl_simple.md)
when there is no meaningful group comparison — for example a single-arm
cohort, a subset table, or a supplementary overview. Use
[`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md)
when comparing two or more groups and you want statistical test columns
alongside the summaries.
