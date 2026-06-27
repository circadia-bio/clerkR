# Descriptive summary table with group comparisons (Table 1)

Produces a descriptive/Table 1-style summary of a data frame, with
optional group comparisons. Formatting defaults are inherited from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md).

## Usage

``` r
tbl_descriptive(
  data,
  group = NULL,
  vars = NULL,
  domains = list(),
  log_vars = character(0),
  digits = NULL,
  p_digits = NULL,
  p_threshold = NULL,
  p_style = NULL,
  stars = NULL,
  fdr = FALSE,
  fdr_ns = NULL,
  fdr_alpha = NULL,
  domain_other = NULL,
  overall = TRUE,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A data frame.

- group:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Grouping variable.

- vars:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Variables to include. Defaults to all columns except `group`.

- domains:

  A named list mapping variable names to domain/section labels.

- log_vars:

  Character vector of log-transformed variable names.

- digits:

  Integer. Decimal places for continuous variables.

- p_digits:

  Integer. Decimal places for p-values.

- p_threshold:

  Numeric. P-values below this are shown as `"< {threshold}"`. Inherits
  from `clerk_options()$p_threshold` if `NULL`.

- p_style:

  Character. P-value style (`"apa"`, `"plain"`, `"stars"`, `"stars_p"`).

- stars:

  Logical. Append significance stars.

- fdr:

  Logical. Apply BH FDR correction (default `FALSE`).

- fdr_ns:

  Logical. Replace non-surviving FDR p-values with `"ns"`.

- fdr_alpha:

  Numeric. Alpha level for FDR survival (BH-adjusted p).

- domain_other:

  Character string. Label for variables not assigned to any domain.
  Default `""` (blank). Inherits from `clerk_options()$domain_other`.

- overall:

  Logical. Include an overall column (default `TRUE`).

- output:

  Character string. One of `"gt"`, `"html"`, or `"latex"`.

## Value

A `clerk_tbl` object with type `"descriptive"`.

## Examples

``` r
tbl_descriptive(
  clerk_example,
  group   = sex,
  domains = list(
    "Metabolic"    = c("hdl", "glucose", "bmi"),
    "Cognitive"    = c("tmt_time", "verbal_fluency"),
    "Mental health"= c("bdi", "panas_neg")
  ),
  log_vars = "tmt_time",
  output   = "gt"
) |> clerk_render(title = "Table 1. Sample characteristics by sex")
#> Warning: invalid factor level, NA generated


  


Table 1. Sample characteristics by sex
```
