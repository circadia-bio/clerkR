# Descriptive summary table with group comparisons (Table 1)

Produces a descriptive/Table 1-style summary of a data frame, with
optional group comparisons. Continuous variables are summarised as mean
± SD and compared with an independent-samples t-test (two groups) or
one-way ANOVA (three or more groups). Categorical variables are
summarised as n (%) and compared with a chi-squared test.

## Usage

``` r
tbl_descriptive(
  data,
  group = NULL,
  vars = NULL,
  domains = list(),
  log_vars = character(0),
  digits = 2,
  p_digits = 3,
  fdr = FALSE,
  overall = TRUE,
  output = c("gt", "html", "latex")
)
```

## Arguments

- data:

  A data frame.

- group:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Unquoted name of the grouping variable. If `NULL` (default) the
  overall sample is summarised without a comparison column.

- vars:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Variables to include. Defaults to all columns except `group`.

- domains:

  A named list mapping variable names to domain/section labels, e.g.
  `list("Metabolic" = c("hdl", "glucose"), "Anthropometric" = c("bmi", "waist"))`.
  Variables not mentioned are placed in an "Other" section.

- log_vars:

  Character vector of variable names that were log-transformed prior to
  analysis. A footnote is appended noting that values are shown on the
  raw scale.

- digits:

  Integer. Number of decimal places for continuous variables (default
  `2`).

- p_digits:

  Integer. Number of decimal places for p-values (default `3`).

- fdr:

  Logical. Apply BH FDR correction to p-values across all tests (default
  `FALSE`).

- overall:

  Logical. Include an overall (ungrouped) column alongside group columns
  (default `TRUE`).

- output:

  Character string specifying the render target. One of `"gt"` (default,
  for Word/PDF via `gt`), `"html"` (interactive `reactable`), or
  `"latex"` (LaTeX via
  [`gt::as_latex()`](https://gt.rstudio.com/reference/as_latex.html)).
  This value is stored on the returned object and used by
  [`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md)
  to dispatch to the correct renderer automatically.

## Value

A `clerk_tbl` object (a list with class `"clerk_tbl"`) containing:

- `table`:

  A data frame with one row per variable.

- `domains`:

  The domain list supplied by the user.

- `log_vars`:

  The log-transformed variable names.

- `type`:

  Character string `"descriptive"`.

- `group`:

  Name of the grouping variable, or `NULL`.

- `output`:

  The render target: `"gt"`, `"html"`, or `"latex"`.

## Examples

``` r
tbl_descriptive(
  clerk_example,
  group    = sex,
  domains  = list(
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
