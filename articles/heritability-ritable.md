# Heritability tables with R-itable and clerkR

## Overview

[`clerkR::tbl_heritability()`](https://clerkr.circadia-lab.uk/reference/tbl_heritability.md)
is designed to accept the output of `R-itable::herit_batch()` directly.
Column-name defaults match
[`herit_batch()`](https://r-itable.circadia-lab.uk/reference/herit_batch.html)
output exactly:

| [`tbl_heritability()`](https://clerkr.circadia-lab.uk/reference/tbl_heritability.md) argument | Default | [`herit_batch()`](https://r-itable.circadia-lab.uk/reference/herit_batch.html) column |
|----|----|----|
| `metric` | `"trait"` | trait name |
| `h2` | `"h2"` | heritability estimate |
| `ci_low` | `"ci_lo"` | lower CI bound |
| `ci_high` | `"ci_hi"` | upper CI bound |
| `p` | `"pval"` | one-sided LRT p-value |

The covariate model column is `"covariates"` in
[`herit_batch()`](https://r-itable.circadia-lab.uk/reference/herit_batch.html)
output — pass `model = "covariates"` to include it.

## Setup

Install both packages from GitHub if you haven’t already:

``` r

# install.packages("remotes")
remotes::install_github("circadia-bio/R-itable")
remotes::install_github("circadia-bio/clerkR")
```

``` r

library(Ritable)
library(clerkR)
```

## 1. Simulate a family cohort

We simulate 80 nuclear families (2 parents + 3 offspring each) with
three quantitative traits at different true h² values — BMI (~0.60),
systolic blood pressure (~0.35), and HDL cholesterol (~0.50).

``` r

set.seed(2026)
n_fam <- 80

ped <- do.call(rbind, lapply(seq_len(n_fam), function(f) {
  base <- (f - 1L) * 5L
  data.frame(
    id  = base + 1:5,
    pat = c(0L, 0L, base + 1L, base + 1L, base + 1L),
    mom = c(0L, 0L, base + 2L, base + 2L, base + 2L),
    sex = c(1L, 2L, sample(1:2, 3, replace = TRUE))
  )
}))

simulate_trait <- function(ped, n_fam, h2, seed) {
  set.seed(seed)
  genetic  <- rep(rnorm(n_fam, 0, sqrt(h2)),      each = 5)
  residual <- rnorm(nrow(ped),         0, sqrt(1 - h2))
  genetic + residual
}

pheno_all <- data.frame(
  bmi = simulate_trait(ped, n_fam, h2 = 0.60, seed = 1),
  sbp = simulate_trait(ped, n_fam, h2 = 0.35, seed = 2),
  hdl = simulate_trait(ped, n_fam, h2 = 0.50, seed = 3)
)

off_rows <- ped$pat != 0L
dat <- data.frame(
  IID     = ped$id[off_rows],
  age     = round(runif(sum(off_rows), 20, 75)),
  sex_num = ped$sex[off_rows],
  bmi     = pheno_all$bmi[off_rows],
  sbp     = pheno_all$sbp[off_rows],
  hdl     = pheno_all$hdl[off_rows]
)
dat$age2 <- dat$age^2
```

## 2. Build GRM and run batch estimation

``` r

A <- build_grm(ped, study_ids = dat$IID)

res <- herit_batch(
  traits    = c("bmi", "sbp", "hdl"),
  grm       = A,
  data      = dat,
  covs_list = list(
    unadj = NULL,
    cov1  = c("age", "sex_num"),
    cov2  = c("age", "sex_num", "age2")
  )
)

# Inspect available covariate model labels
unique(res$covariates)
#> [1] ""                 "age+sex_num"      "age+sex_num+age2"
res
#>       label trait       covariates   n     h2     se  ci_lo ci_hi pval
#> 1 bmi_unadj   bmi                  240 0.9990 0.1297 0.8400     1    0
#> 2 sbp_unadj   sbp                  240 0.8055 0.1392 0.5303     1    0
#> 3 hdl_unadj   hdl                  240 0.7998 0.1394 0.5243     1    0
#> 4  bmi_cov1   bmi      age+sex_num 240 0.9990 0.1313 0.8331     1    0
#> 5  sbp_cov1   sbp      age+sex_num 240 0.8012 0.1402 0.5240     1    0
#> 6  hdl_cov1   hdl      age+sex_num 240 0.8014 0.1395 0.5258     1    0
#> 7  bmi_cov2   bmi age+sex_num+age2 240 0.9990 0.1318 0.8280     1    0
#> 8  sbp_cov2   sbp age+sex_num+age2 240 0.7999 0.1402 0.5228     1    0
#> 9  hdl_cov2   hdl age+sex_num+age2 240 0.8039 0.1405 0.5259     1    0
#>   var_covariates sigma2_a sigma2_e
#> 1             NA  0.93477  0.00094
#> 2             NA  0.80117  0.19348
#> 3             NA  0.79550  0.19915
#> 4         0.0207  0.92785  0.00093
#> 5         0.0085  0.79187  0.19651
#> 6         0.0067  0.79210  0.19624
#> 7         0.0304  0.92432  0.00093
#> 8         0.0118  0.78783  0.19710
#> 9         0.0091  0.79525  0.19393
```

## 3. Render the full table

Pass column names as strings — defaults already match
[`herit_batch()`](https://r-itable.circadia-lab.uk/reference/herit_batch.html)
output, so only `model`, `sigma2_a`, and `sigma2_e` need to be
specified:

``` r

res |>
  tbl_heritability(
    model    = "covariates",
    sigma2_a = "sigma2_a",
    sigma2_e = "sigma2_e",
    domains  = list("Cardiometabolic" = c("bmi", "sbp", "hdl")),
    fdr      = TRUE,
    output   = "gt"
  ) |>
  clerk_render(
    title    = "Heritability estimates",
    subtitle = "Narrow-sense h\u00b2 \u00b1 95% profile-likelihood CI",
    footnote = "FDR correction applied within each covariate model (BH). p-values are one-sided LRT with chi-squared(1) boundary correction."
  )
#> Warning in `[<-.factor`(`*tmp*`, is.na(tbl[["domain"]]), value = ""): invalid
#> factor level, NA generated
```

| Heritability estimates |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
| Narrow-sense h² ± 95% profile-likelihood CI |  |  |  |  |  |  |  |
|  | covariates | h² | 95% CI | p | σ²a | σ²e | p (FDR) |
| Cardiometabolic |  |  |  |  |  |  |  |
| bmi |  | 0.999 | \[0.840, 1.000\] | \< 0.001 | 0.935 | 0.001 | \< 0.001 |
| sbp |  | 0.805 | \[0.530, 1.000\] | \< 0.001 | 0.801 | 0.193 | \< 0.001 |
| hdl |  | 0.800 | \[0.524, 1.000\] | \< 0.001 | 0.795 | 0.199 | \< 0.001 |
| bmi | age+sex_num | 0.999 | \[0.833, 1.000\] | \< 0.001 | 0.928 | 0.001 | \< 0.001 |
| sbp | age+sex_num | 0.801 | \[0.524, 1.000\] | \< 0.001 | 0.792 | 0.197 | \< 0.001 |
| hdl | age+sex_num | 0.801 | \[0.526, 1.000\] | \< 0.001 | 0.792 | 0.196 | \< 0.001 |
| bmi | age+sex_num+age2 | 0.999 | \[0.828, 1.000\] | \< 0.001 | 0.924 | 0.001 | \< 0.001 |
| sbp | age+sex_num+age2 | 0.800 | \[0.523, 1.000\] | \< 0.001 | 0.788 | 0.197 | \< 0.001 |
| hdl | age+sex_num+age2 | 0.804 | \[0.526, 1.000\] | \< 0.001 | 0.795 | 0.194 | \< 0.001 |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |  |  |  |
| FDR correction applied within each covariate model (BH). p-values are one-sided LRT with chi-squared(1) boundary correction. |  |  |  |  |  |  |  |

## Filtering to a single model

``` r

adj_model <- unique(res$covariates)[length(unique(res$covariates))]

res[res$covariates == adj_model, ] |>
  tbl_heritability(
    sigma2_a = "sigma2_a",
    sigma2_e = "sigma2_e",
    fdr      = TRUE,
    output   = "gt"
  ) |>
  clerk_render(
    title    = paste0("Heritability estimates (", adj_model, ")"),
    footnote = "FDR correction applied across all traits (BH)."
  )
```

| Heritability estimates (age+sex_num+age2) |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | h² | 95% CI | p | σ²a | σ²e | p (FDR) |
|  |  |  |  |  |  |  |
| bmi | 0.999 | \[0.828, 1.000\] | \< 0.001 | 0.924 | 0.001 | \< 0.001 |
| sbp | 0.800 | \[0.523, 1.000\] | \< 0.001 | 0.788 | 0.197 | \< 0.001 |
| hdl | 0.804 | \[0.526, 1.000\] | \< 0.001 | 0.795 | 0.194 | \< 0.001 |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |  |  |
| FDR correction applied across all traits (BH). |  |  |  |  |  |  |

## HTML output

``` r

res[res$covariates == adj_model, ] |>
  tbl_heritability(
    sigma2_a = "sigma2_a",
    sigma2_e = "sigma2_e",
    output   = "html"
  ) |>
  clerk_render()
```
