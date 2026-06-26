# Synthetic regression results for clerkR examples

A synthetic data frame of linear regression results (outcome: log TMT
completion time) designed to illustrate
[`tbl_regression()`](https://clerkr.circadia-lab.uk/reference/tbl_regression.md).
Mimics the output of `broom::tidy(lm(...), conf.int = TRUE)`. All values
are simulated.

## Usage

``` r
clerk_reg_example
```

## Format

A data frame with 7 rows and 6 variables:

- term:

  Model term / predictor name (character).

- estimate:

  Regression coefficient β (numeric).

- std.error:

  Standard error of the estimate (numeric).

- conf.low:

  Lower 95% confidence interval bound (numeric).

- conf.high:

  Upper 95% confidence interval bound (numeric).

- p.value:

  Two-tailed p-value (numeric).

## Source

Simulated data generated in `data-raw/clerk_reg_example.R`.
