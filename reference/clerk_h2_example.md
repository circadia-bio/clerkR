# Synthetic heritability estimates for clerkR examples

A synthetic data frame of narrow-sense heritability (h²) estimates for
three cortical shape metrics across four covariate models, designed to
illustrate
[`tbl_heritability()`](https://clerkr.circadia-lab.uk/reference/tbl_heritability.md).
Column names match the output of `R-itable::herit_batch()` for direct
compatibility. All values are simulated.

## Usage

``` r
clerk_h2_example
```

## Format

A data frame with 12 rows and 7 variables:

- trait:

  Phenotype name (character).

- covariates:

  Covariate model label (character).

- h2:

  Narrow-sense heritability point estimate (numeric).

- ci_lo:

  Lower 95% profile-likelihood CI bound (numeric).

- ci_hi:

  Upper 95% profile-likelihood CI bound (numeric).

- pval:

  One-sided LRT p-value (numeric).

- sigma2_a:

  Additive genetic variance component (numeric).

- sigma2_e:

  Residual variance component (numeric).

## Source

Simulated data generated in `data-raw/clerk_h2_example.R`.
