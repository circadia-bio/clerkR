# Simple descriptive summary table (no inferential tests)

Produces a concise descriptive summary — mean ± SD for continuous
variables and n (%) for categorical variables — with no group
comparisons or statistical tests.

Formatting defaults are inherited from
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md)
and can be overridden per call.

## Usage

``` r
tbl_simple(
  data,
  vars = NULL,
  domains = list(),
  log_vars = character(0),
  digits = NULL,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A data frame.

- vars:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Variables to include. Defaults to all columns.

- domains:

  A named list mapping variable names to domain/section labels.

- log_vars:

  Character vector of log-transformed variable names.

- digits:

  Integer. Decimal places for continuous variables. Inherits from
  `clerk_options()$digits` if `NULL`.

- output:

  Character string. One of `"gt"` (default), `"html"`, or `"latex"`.

## Value

A `clerk_tbl` object with type `"simple"`.

## Examples

``` r
tbl_simple(
  clerk_example,
  domains  = list(
    "Metabolic"    = c("hdl", "glucose", "bmi"),
    "Mental health"= c("bdi", "panas_neg")
  ),
  log_vars = "tmt_time",
  output   = "gt"
) |> clerk_render(title = "Descriptive statistics")
#> Warning: invalid factor level, NA generated


  


Descriptive statistics
```
