# Formatting options

## Overview

All `tbl_*` constructors inherit their formatting defaults from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md).
Defaults follow biomed/APA conventions and are loaded automatically when
the package is attached — no setup required. You can inspect the current
settings at any time:

``` r

clerk_options()
```

Options can be changed session-wide with a single call, or overridden
per-table by passing the same arguments directly to any `tbl_*`
function.

------------------------------------------------------------------------

## P-value style

The `p_style` option controls how p-values are displayed. Four styles
are available:

| Style       | Example output       | Use case                  |
|-------------|----------------------|---------------------------|
| `"apa"`     | `= 0.032`, `< 0.001` | APA manuscripts (default) |
| `"plain"`   | `0.032`, `< 0.001`   | Plain decimal             |
| `"stars"`   | `**`                 | Stars only, no numeric p  |
| `"stars_p"` | `= 0.032 **`         | Stars alongside numeric p |

``` r

# APA style (default)
tbl_descriptive(clerk_example, group = sex, output = "gt") |>
  clerk_render(title = "APA style (default)")
```

| APA style (default) |  |  |  |  |  |  |
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

``` r


# Plain decimal
tbl_descriptive(clerk_example, group = sex, output = "gt",
                p_style = "plain") |>
  clerk_render(title = "Plain decimal")
```

| Plain decimal |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 0.606 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |

To set a different default for the whole session:

``` r

clerk_options(p_style = "plain")
```

------------------------------------------------------------------------

## Decimal places

Three separate options control decimal places for different value types:

| Option     | Default | Controls                                |
|------------|---------|-----------------------------------------|
| `digits`   | `2`     | Continuous statistics (mean, SD, β, SE) |
| `r_digits` | `3`     | Correlations and h² estimates           |
| `p_digits` | `3`     | P-values                                |

``` r

tbl_descriptive(clerk_example, group = sex, output = "gt",
                digits = 1, p_digits = 2) |>
  clerk_render(title = "digits = 1, p_digits = 2")
```

| digits = 1, p_digits = 2 |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.8 ± 14.2 | 46.4 ± 13.6 | 47.4 ± 15.1 | t = -0.53 | = 0.60 |
| hdl | 300 | 46.8 ± 10.1 | 48.3 ± 9.8 | 44.1 ± 10.2 | t = 3.50 | \< 0.00 |
| glucose | 300 | 91.7 ± 24.6 | 92.6 ± 24.5 | 90.0 ± 25.0 | t = 0.87 | = 0.39 |
| bmi | 300 | 26.1 ± 4.9 | 26.4 ± 4.8 | 25.6 ± 5.0 | t = 1.32 | = 0.19 |
| waist | 300 | 92.1 ± 11.6 | 92.1 ± 11.3 | 91.9 ± 12.0 | t = 0.15 | = 0.88 |
| systolic_bp | 300 | 123.3 ± 17.8 | 120.4 ± 17.9 | 128.5 ± 16.4 | t = -3.97 | \< 0.00 |
| tmt_time | 300 | 129.2 ± 65.0 | 132.8 ± 66.8 | 122.8 ± 61.4 | t = 1.31 | = 0.19 |
| verbal_fluency | 300 | 15.0 ± 4.6 | 15.1 ± 4.4 | 14.8 ± 5.0 | t = 0.52 | = 0.61 |
| bdi | 300 | 13.6 ± 9.3 | 15.1 ± 9.0 | 11.0 ± 9.3 | t = 3.65 | \< 0.00 |
| panas_neg | 300 | 21.0 ± 7.5 | 22.5 ± 7.3 | 18.3 ± 7.1 | t = 4.92 | \< 0.00 |
| life_satisfaction | 300 | 18.0 ± 4.2 | 17.4 ± 4.2 | 19.1 ± 4.0 | t = -3.54 | \< 0.00 |

The `p_threshold` option controls the value below which p-values are
shown as `< {threshold}` rather than as a decimal. The default is
`0.001`:

``` r

# Per-call: show < 0.01 instead of < 0.001
tbl_descriptive(clerk_example, group = sex, output = "gt",
                p_threshold = 0.01) |>
  clerk_render(title = "p_threshold = 0.01")
```

| p_threshold = 0.01 |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.010 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.010 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.010 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.010 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.010 |

------------------------------------------------------------------------

## Significance stars

Stars are off by default. Enable them with `stars = TRUE`:

``` r

tbl_correlation(clerk_cor_example, fdr = TRUE, output = "gt",
                stars = TRUE) |>
  clerk_render(title = "With significance stars")
```

| With significance stars |  |  |  |  |
|----|----|----|----|----|
|  | Outcome | r | p | p (FDR) |
|  |  |  |  |  |
| hdl | tmt_time | +0.190 | = 0.008\*\* | = 0.032\* |
| glucose | tmt_time | -0.229 | = 0.398 | ns |
| bmi | tmt_time | -0.086 | = 0.013\* | = 0.042\* |
| waist | tmt_time | +0.279 | = 0.002\*\* | = 0.024\* |
| systolic_bp | tmt_time | +0.195 | = 0.379 | ns |
| bdi | tmt_time | +0.096 | = 0.109 | ns |
| panas_neg | tmt_time | +0.157 | = 0.006\*\* | = 0.032\* |
| life_satisfaction | tmt_time | +0.247 | = 0.117 | ns |
| hdl | verbal_fluency | +0.078 | = 0.072 | ns |
| glucose | verbal_fluency | +0.216 | = 0.003\*\* | = 0.024\* |
| bmi | verbal_fluency | +0.022 | = 0.207 | ns |
| waist | verbal_fluency | +0.047 | = 0.185 | ns |
| systolic_bp | verbal_fluency | -0.105 | = 0.077 | ns |
| bdi | verbal_fluency | -0.176 | = 0.070 | ns |
| panas_neg | verbal_fluency | +0.232 | = 0.117 | ns |
| life_satisfaction | verbal_fluency | +0.201 | = 0.234 | ns |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |

The thresholds for `*`, `**`, and `***` are set by `star_thresholds`
(default `c(0.05, 0.01, 0.001)`). For stars-only output use
`p_style = "stars"`, or combine stars with numeric p-values using
`p_style = "stars_p"`:

``` r

tbl_regression(clerk_reg_example, output = "gt",
               p_style = "stars_p") |>
  clerk_render(title = "Stars alongside p-values")
```

| Stars alongside p-values |       |      |                  |           |
|--------------------------|-------|------|------------------|-----------|
|                          | β     | SE   | 95% CI           | p         |
|                          |       |      |                  |           |
| bmi                      | +0.02 | 0.02 | \[-0.02, +0.07\] | 0.012\*   |
| waist                    | -0.02 | 0.02 | \[-0.07, +0.03\] | 0.048\*   |
| systolic_bp              | +0.01 | 0.01 | \[-0.01, +0.03\] | 0.210     |
| bdi                      | +0.01 | 0.02 | \[-0.04, +0.05\] | 0.330     |
| panas_neg                | +0.01 | 0.02 | \[-0.02, +0.05\] | 0.041\*   |
| age                      | +0.00 | 0.01 | \[-0.03, +0.03\] | 0.610     |
| sexMale                  | -0.04 | 0.02 | \[-0.08, -0.01\] | 0.003\*\* |

------------------------------------------------------------------------

## FDR display

When `fdr = TRUE` is passed to a `tbl_*` function, a `p (FDR)` column is
added containing BH-adjusted p-values. Three options control how
non-surviving results are displayed:

| Option         | Default | Effect                                             |
|----------------|---------|----------------------------------------------------|
| `fdr_ns`       | `TRUE`  | Replace non-surviving cells with `fdr_ns_label`    |
| `fdr_alpha`    | `0.05`  | Alpha level applied to the **BH-adjusted** p-value |
| `fdr_ns_label` | `"ns"`  | The label shown for non-surviving cells            |

``` r

tbl_descriptive(clerk_example, group = sex, fdr = TRUE, output = "gt") |>
  clerk_render(title = "FDR with ns label (default)")
```

| FDR with ns label (default) |  |  |  |  |  |  |  |
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

Disable the replacement to always show the numeric FDR value:

``` r

tbl_descriptive(clerk_example, group = sex, fdr = TRUE, output = "gt",
                fdr_ns = FALSE) |>
  clerk_render(title = "FDR numeric values always shown")
```

| FDR numeric values always shown |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p | p (FDR) |
|  |  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 | = 0.667 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 | = 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 | = 0.531 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 | = 0.301 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 | = 0.301 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 | = 0.667 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 | = 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 | = 0.001 |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |  |  |  |

Use a stricter survival threshold:

``` r

tbl_correlation(clerk_cor_example, fdr = TRUE, output = "gt",
                fdr_alpha = 0.01) |>
  clerk_render(title = "FDR survival at \u03b1 = 0.01")
```

| FDR survival at α = 0.01 |  |  |  |  |
|----|----|----|----|----|
|  | Outcome | r | p | p (FDR) |
|  |  |  |  |  |
| hdl | tmt_time | +0.190 | = 0.008 | ns |
| glucose | tmt_time | -0.229 | = 0.398 | ns |
| bmi | tmt_time | -0.086 | = 0.013 | ns |
| waist | tmt_time | +0.279 | = 0.002 | ns |
| systolic_bp | tmt_time | +0.195 | = 0.379 | ns |
| bdi | tmt_time | +0.096 | = 0.109 | ns |
| panas_neg | tmt_time | +0.157 | = 0.006 | ns |
| life_satisfaction | tmt_time | +0.247 | = 0.117 | ns |
| hdl | verbal_fluency | +0.078 | = 0.072 | ns |
| glucose | verbal_fluency | +0.216 | = 0.003 | ns |
| bmi | verbal_fluency | +0.022 | = 0.207 | ns |
| waist | verbal_fluency | +0.047 | = 0.185 | ns |
| systolic_bp | verbal_fluency | -0.105 | = 0.077 | ns |
| bdi | verbal_fluency | -0.176 | = 0.070 | ns |
| panas_neg | verbal_fluency | +0.232 | = 0.117 | ns |
| life_satisfaction | verbal_fluency | +0.201 | = 0.234 | ns |
| p (FDR): Benjamini-Hochberg false discovery rate correction applied. |  |  |  |  |

------------------------------------------------------------------------

## Domain labels for unassigned variables

When a `domains` list is supplied, variables not assigned to any domain
receive a blank section header by default (`domain_other = ""`). Set it
to a string to collect them under a named section:

``` r

tbl_descriptive(
  clerk_example,
  group        = sex,
  domains      = list("Metabolic" = c("hdl", "glucose", "bmi")),
  domain_other = "Other",
  output       = "gt"
) |>
  clerk_render(title = "Unassigned variables under 'Other'")
```

| Unassigned variables under 'Other' |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| Metabolic |  |  |  |  |  |  |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| Other |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |

------------------------------------------------------------------------

## Nested domains (sub-sections within a domain)

A `domains` entry can itself be a named list instead of a plain variable
vector. This is useful when one domain naturally splits into repeated
sub-sections — the most common case being the same measures collected at
multiple timepoints. Here’s a small synthetic longitudinal example:
three mental health measures, each collected at baseline and two
follow-ups.

``` r

set.seed(1)
longitudinal_example <- data.frame(
  sex               = clerk_example$sex,
  bdi_bl            = clerk_example$bdi,
  panas_neg_bl      = clerk_example$panas_neg,
  life_sat_bl       = clerk_example$life_satisfaction,
  bdi_fu1           = clerk_example$bdi       + rnorm(300, -1, 3),
  panas_neg_fu1     = clerk_example$panas_neg + rnorm(300, -1, 3),
  life_sat_fu1      = clerk_example$life_satisfaction + rnorm(300, 1, 3),
  bdi_fu2           = clerk_example$bdi       + rnorm(300, -2, 3),
  panas_neg_fu2     = clerk_example$panas_neg + rnorm(300, -2, 3),
  life_sat_fu2      = clerk_example$life_satisfaction + rnorm(300, 2, 3)
)
```

Nest the three timepoints inside a single `"Mental health"` domain by
supplying a named list instead of a character vector for that entry.
Flat and nested entries can be mixed freely in the same `domains` list:

``` r

tbl_descriptive(
  longitudinal_example,
  group   = sex,
  domains = list(
    "Mental health" = list(
      "Baseline"    = c("bdi_bl",  "panas_neg_bl",  "life_sat_bl"),
      "Follow-up 1" = c("bdi_fu1", "panas_neg_fu1", "life_sat_fu1"),
      "Follow-up 2" = c("bdi_fu2", "panas_neg_fu2", "life_sat_fu2")
    )
  ),
  output = "gt"
) |>
  clerk_render(title = "Mental health by timepoint")
```

| Mental health by timepoint |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
| Mental health — Baseline |  |  |  |  |  |  |
| bdi_bl | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg_bl | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_sat_bl | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |
| Mental health — Follow-up 1 |  |  |  |  |  |  |
| bdi_fu1 | 300 | 12.74 ± 9.64 | 13.91 ± 9.34 | 10.62 ± 9.86 | t = 2.81 | = 0.005 |
| panas_neg_fu1 | 300 | 19.95 ± 8.40 | 21.50 ± 8.28 | 17.15 ± 7.91 | t = 4.49 | \< 0.001 |
| life_sat_fu1 | 300 | 18.83 ± 5.45 | 18.34 ± 5.48 | 19.72 ± 5.31 | t = -2.14 | = 0.034 |
| Mental health — Follow-up 2 |  |  |  |  |  |  |
| bdi_fu2 | 300 | 11.48 ± 9.85 | 12.97 ± 9.80 | 8.79 ± 9.41 | t = 3.63 | \< 0.001 |
| panas_neg_fu2 | 300 | 19.13 ± 8.20 | 20.60 ± 8.14 | 16.48 ± 7.65 | t = 4.37 | \< 0.001 |
| life_sat_fu2 | 300 | 19.82 ± 5.20 | 19.24 ± 5.35 | 20.86 ± 4.78 | t = -2.71 | = 0.007 |

**A `gt`/Word/PDF/LaTeX limitation, not a clerkR one:** `gt` has no
native support for two-level row-group headers (there’s a long-standing
open feature request upstream for it). So for `output = "gt"` and
`output = "latex"`, a nested domain renders as one row group per
sub-domain, labelled with a compound `"Domain — Subdomain"` string — you
get the grouping, but not a shared header spanning all three
sub-domains.

If you need the domain and its sub-domains to render as a genuine
expandable/collapsible two-level hierarchy, use `output = "html"`
instead. `reactable` *does* support real nested grouping, so the same
`domains` list produces an actual tree — click “Mental health” to expand
into its three timepoints:

``` r

tbl_descriptive(
  longitudinal_example,
  group   = sex,
  domains = list(
    "Mental health" = list(
      "Baseline"    = c("bdi_bl",  "panas_neg_bl",  "life_sat_bl"),
      "Follow-up 1" = c("bdi_fu1", "panas_neg_fu1", "life_sat_fu1"),
      "Follow-up 2" = c("bdi_fu2", "panas_neg_fu2", "life_sat_fu2")
    )
  ),
  output = "html"
) |>
  clerk_render(title = "Mental health by timepoint (expandable)")
```

Mental health by timepoint (expandable)

Row-group order always follows the order you write `domains` in — top to
bottom, then sub-domain top to bottom within each — regardless of what
order the variables happen to appear in the underlying data.

------------------------------------------------------------------------

## Custom footnotes

Two automatic footnotes already appear without you asking for them: a
log-transform note for any `log_vars`, and an FDR source note whenever
`fdr = TRUE`. On top of those,
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md)
(and
[`render_gt()`](https://clerkr.circadia-lab.uk/reference/render_gt.md) /
[`render_latex()`](https://clerkr.circadia-lab.uk/reference/render_latex.md)
directly) takes two further arguments for your own notes.

**`footnote`** — one or more blanket notes, shown below the whole table
(pass a character vector for more than one):

``` r

tbl_descriptive(clerk_example, group = sex, output = "gt") |>
  clerk_render(
    title    = "Table 1",
    footnote = c(
      "Data collected 2024-2025.",
      "Missing data (< 5% per variable) excluded listwise."
    )
  )
```

| Table 1 |  |  |  |  |  |  |
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
| Data collected 2024-2025. |  |  |  |  |  |  |
| Missing data (\< 5% per variable) excluded listwise. |  |  |  |  |  |  |

**`footnotes`** — targeted notes attached to specific rows or columns,
rather than the whole table. Each element is a list with a `text` string
and either `rows` (variable names, matched against the table stub) or
`cols` (column names):

``` r

tbl_descriptive(clerk_example, group = sex, output = "gt") |>
  clerk_render(
    title = "Table 1",
    footnotes = list(
      list(text = "Assessed via self-report questionnaire.",
           rows = c("bdi", "panas_neg")),
      list(text = "Age- and sex-adjusted.", cols = "overall")
    )
  )
```

| Table 1 |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall¹ | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | = 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | = 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | = 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | = 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | = 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | = 0.606 |
| bdi² | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg² | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |
| ¹ Age- and sex-adjusted. |  |  |  |  |  |  |
| ² Assessed via self-report questionnaire. |  |  |  |  |  |  |

`footnote` and `footnotes` can be combined freely, and both stack with
the automatic log-transform/FDR notes rather than replacing them.

For `output = "html"`, `reactable` has no per-cell footnote-marker
equivalent, so both `footnote` and any `footnotes[[i]]$text` are shown
together as a plain note list underneath the widget rather than attached
to specific cells.

------------------------------------------------------------------------

## Session-wide vs per-call options

Options set via
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md)
apply to all subsequent tables in the session. Arguments passed directly
to a `tbl_*` function override the session default for that call only:

``` r

# Change session default to plain style
clerk_options(p_style = "plain")

# This table uses plain (from session)
tbl_descriptive(clerk_example, group = sex, output = "gt") |>
  clerk_render(title = "Session default: plain")
```

| Session default: plain |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
|  | n | Overall | Female | Male | Statistic | p |
|  |  |  |  |  |  |  |
| age | 300 | 46.76 ± 14.15 | 46.42 ± 13.63 | 47.35 ± 15.09 | t = -0.53 | 0.599 |
| hdl | 300 | 46.81 ± 10.11 | 48.32 ± 9.78 | 44.08 ± 10.18 | t = 3.50 | \< 0.001 |
| glucose | 300 | 91.68 ± 24.65 | 92.61 ± 24.49 | 90.01 ± 24.96 | t = 0.87 | 0.386 |
| bmi | 300 | 26.15 ± 4.91 | 26.43 ± 4.84 | 25.64 ± 5.01 | t = 1.32 | 0.190 |
| waist | 300 | 92.07 ± 11.56 | 92.14 ± 11.32 | 91.93 ± 12.03 | t = 0.15 | 0.879 |
| systolic_bp | 300 | 123.25 ± 17.77 | 120.36 ± 17.86 | 128.48 ± 16.45 | t = -3.97 | \< 0.001 |
| tmt_time | 300 | 129.24 ± 64.98 | 132.81 ± 66.77 | 122.81 ± 61.40 | t = 1.31 | 0.192 |
| verbal_fluency | 300 | 14.98 ± 4.63 | 15.08 ± 4.44 | 14.79 ± 4.97 | t = 0.52 | 0.606 |
| bdi | 300 | 13.64 ± 9.26 | 15.07 ± 8.97 | 11.05 ± 9.26 | t = 3.65 | \< 0.001 |
| panas_neg | 300 | 20.98 ± 7.48 | 22.50 ± 7.27 | 18.25 ± 7.09 | t = 4.92 | \< 0.001 |
| life_satisfaction | 300 | 18.02 ± 4.23 | 17.40 ± 4.25 | 19.14 ± 3.99 | t = -3.54 | \< 0.001 |

``` r


# This table overrides back to APA for this call only
tbl_descriptive(clerk_example, group = sex, output = "gt",
                p_style = "apa") |>
  clerk_render(title = "Per-call override: apa")
```

| Per-call override: apa |  |  |  |  |  |  |
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

``` r


# Reset to factory defaults
clerk_options(reset = TRUE)
```

------------------------------------------------------------------------

## Full option reference

``` r

clerk_options(
  digits          = 2,        # continuous stats decimal places
  r_digits        = 3,        # correlations / h² decimal places
  p_digits        = 3,        # p-value decimal places
  p_threshold     = 0.001,    # below this → "< 0.001"
  p_style         = "apa",    # "apa" | "plain" | "stars" | "stars_p"
  stars           = FALSE,    # append * ** ***
  star_thresholds = c(0.05, 0.01, 0.001),
  fdr_ns          = TRUE,     # replace non-surviving FDR with label
  fdr_alpha       = 0.05,     # applied to BH-adjusted p, not raw p
  fdr_ns_label    = "ns",     # label for non-surviving FDR cells
  domain_other    = ""        # label for unassigned variables
)
```
