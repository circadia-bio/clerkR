# Synthetic partial correlation results for clerkR examples

A synthetic dataset of partial correlation results (age + sex
controlled) between eight predictor variables and two cognitive
outcomes, designed to illustrate
[`tbl_correlation()`](https://clerkr.circadia-lab.uk/reference/tbl_correlation.md).
All values are simulated and bear no relation to any real study.

## Usage

``` r
clerk_cor_example
```

## Format

A data frame with 16 rows and 5 variables:

- variable:

  Predictor variable name (character).

- outcome:

  Outcome variable name: `"tmt_time"` or `"verbal_fluency"` (character).

- n:

  Sample size for each correlation (integer).

- r:

  Partial correlation coefficient (numeric).

- p:

  Two-tailed p-value (numeric).

## Source

Simulated data generated in `data-raw/clerk_cor_example.R`.
