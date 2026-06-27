# Regression coefficient tables

``` r

library(clerkR)
```

## Overview

[`tbl_regression()`](https://clerkr.circadia-lab.uk/reference/tbl_regression.md)
formats a tidy data frame of regression results — β, SE, 95% CI, and
p-value — into a publication-ready table. It is designed to accept the
output of `broom::tidy()` directly.

Column-name arguments take **quoted strings**. Defaults match
`broom::tidy(model, conf.int = TRUE)` output:

| Argument    | Default       | `broom::tidy()` column |
|-------------|---------------|------------------------|
| `term`      | `"term"`      | model term             |
| `estimate`  | `"estimate"`  | coefficient β          |
| `std_error` | `"std.error"` | standard error         |
| `conf_low`  | `"conf.low"`  | lower CI bound         |
| `conf_high` | `"conf.high"` | upper CI bound         |
| `p`         | `"p.value"`   | p-value                |

`clerk_reg_example` already uses these column names:

``` r

clerk_reg_example
#>          term estimate std.error conf.low conf.high p.value
#> 1         bmi    0.021     0.023   -0.024     0.066   0.012
#> 2       waist   -0.018     0.024   -0.065     0.029   0.048
#> 3 systolic_bp    0.012     0.011   -0.010     0.034   0.210
#> 4         bdi    0.008     0.022   -0.035     0.051   0.330
#> 5   panas_neg    0.015     0.018   -0.020     0.050   0.041
#> 6         age    0.003     0.015   -0.026     0.032   0.610
#> 7     sexMale   -0.045     0.020   -0.084    -0.006   0.003
```

## Basic usage

Since `clerk_reg_example` matches all defaults, no remapping is needed:

``` r

tbl_regression(
  clerk_reg_example,
  output = "gt"
) |>
  clerk_render(title = "Linear regression: TMT completion time (log s)")
```

| Linear regression: TMT completion time (log s) |  |  |  |  |
|----|----|----|----|----|
|  | β | SE | 95% CI | p |
| All variables |  |  |  |  |
| bmi | +0.02 | 0.02 | \[-0.02, +0.07\] | = 0.012 |
| waist | -0.02 | 0.02 | \[-0.07, +0.03\] | = 0.012 |
| systolic_bp | +0.01 | 0.01 | \[-0.01, +0.03\] | = 0.012 |
| bdi | +0.01 | 0.02 | \[-0.04, +0.05\] | = 0.012 |
| panas_neg | +0.01 | 0.02 | \[-0.02, +0.05\] | = 0.012 |
| age | +0.00 | 0.01 | \[-0.03, +0.03\] | = 0.012 |
| sexMale | -0.04 | 0.02 | \[-0.08, -0.01\] | = 0.012 |

## Domain grouping

``` r

tbl_regression(
  clerk_reg_example,
  domains = list(
    "Cardiometabolic" = c("bmi", "waist", "systolic_bp"),
    "Mental health"   = c("bdi", "panas_neg")
  ),
  output = "gt"
) |>
  clerk_render(title = "Linear regression: TMT completion time (log s)")
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Linear regression: TMT completion time (log s) |  |  |  |  |
|----|----|----|----|----|
|  | β | SE | 95% CI | p |
| Cardiometabolic |  |  |  |  |
| bmi | +0.02 | 0.02 | \[-0.02, +0.07\] | = 0.012 |
| waist | -0.02 | 0.02 | \[-0.07, +0.03\] | = 0.012 |
| systolic_bp | +0.01 | 0.01 | \[-0.01, +0.03\] | = 0.012 |
| Mental health |  |  |  |  |
| bdi | +0.01 | 0.02 | \[-0.04, +0.05\] | = 0.012 |
| panas_neg | +0.01 | 0.02 | \[-0.02, +0.05\] | = 0.012 |
| NA |  |  |  |  |
| age | +0.00 | 0.01 | \[-0.03, +0.03\] | = 0.012 |
| sexMale | -0.04 | 0.02 | \[-0.08, -0.01\] | = 0.012 |

## FDR correction

``` r

tbl_regression(
  clerk_reg_example,
  domains = list(
    "Cardiometabolic" = c("bmi", "waist", "systolic_bp"),
    "Mental health"   = c("bdi", "panas_neg")
  ),
  fdr    = TRUE,
  output = "gt"
) |>
  clerk_render(
    title    = "Linear regression: TMT completion time (log s)",
    footnote = "FDR correction applied across all terms (BH)."
  )
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = "Other"):
#> invalid factor level, NA generated
```

| Linear regression: TMT completion time (log s) |  |  |  |  |  |
|----|----|----|----|----|----|
|  | β | SE | 95% CI | p | p (FDR) |
| Cardiometabolic |  |  |  |  |  |
| bmi | +0.02 | 0.02 | \[-0.02, +0.07\] | = 0.012 | = 0.042 |
| waist | -0.02 | 0.02 | \[-0.07, +0.03\] | = 0.012 | ns |
| systolic_bp | +0.01 | 0.01 | \[-0.01, +0.03\] | = 0.012 | ns |
| Mental health |  |  |  |  |  |
| bdi | +0.01 | 0.02 | \[-0.04, +0.05\] | = 0.012 | ns |
| panas_neg | +0.01 | 0.02 | \[-0.02, +0.05\] | = 0.012 | ns |
| NA |  |  |  |  |  |
| age | +0.00 | 0.01 | \[-0.03, +0.03\] | = 0.012 | ns |
| sexMale | -0.04 | 0.02 | \[-0.08, -0.01\] | = 0.012 | = 0.042 |
| FDR correction applied across all terms (BH). |  |  |  |  |  |

## Using `broom::tidy()` directly

``` r

library(broom)

lm(log(tmt_time) ~ bmi + waist + systolic_bp + bdi + panas_neg + age + sex,
   data = clerk_example) |>
  tidy(conf.int = TRUE) |>
  tbl_regression(
    domains = list(
      "Cardiometabolic" = c("bmi", "waist", "systolic_bp"),
      "Mental health"   = c("bdi", "panas_neg")
    ),
    fdr    = TRUE,
    output = "gt"
  ) |>
  clerk_render(title = "Linear regression: TMT completion time (log s)")
```

## Logistic regression — exponentiated coefficients

Set `exponentiate = TRUE` to show odds ratios or hazard ratios:

``` r

library(broom)

glm(outcome ~ bmi + age + sex, data = my_data, family = binomial) |>
  tidy(conf.int = TRUE, exponentiate = FALSE) |>
  tbl_regression(
    exponentiate = TRUE,
    output       = "gt"
  ) |>
  clerk_render(
    title    = "Logistic regression: odds ratios",
    footnote = "Values shown as OR [95% CI]."
  )
```

## Custom column names

Pass column names as strings when they differ from the defaults:

``` r

my_results <- data.frame(
  predictor = c("bmi", "age"),
  beta      = c(0.021, 0.003),
  se        = c(0.008, 0.002),
  lo95      = c(0.005, -0.001),
  hi95      = c(0.037,  0.007),
  pval      = c(0.012,  0.610)
)

tbl_regression(
  my_results,
  term      = "predictor",
  estimate  = "beta",
  std_error = "se",
  conf_low  = "lo95",
  conf_high = "hi95",
  p         = "pval",
  output    = "gt"
) |>
  clerk_render(title = "Regression results")
```

## HTML output

``` r

tbl_regression(
  clerk_reg_example,
  output = "html"
) |>
  clerk_render()
```
