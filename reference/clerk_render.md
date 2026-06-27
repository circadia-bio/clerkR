# Render a clerk_tbl to its target output format

Dispatches to the correct renderer based on the `output` slot set at
construction time
(`tbl_descriptive(..., output = "gt"|"html"|"latex")`). All render
arguments (`title`, `subtitle`, `footnote`) can be supplied here and are
forwarded to the underlying renderer.

## Usage

``` r
clerk_render(
  x,
  title = NULL,
  subtitle = NULL,
  footnote = NULL,
  fdr_footnote = TRUE,
  ...
)
```

## Arguments

- x:

  A `clerk_tbl` object.

- title:

  Optional character string for the table title.

- subtitle:

  Optional character string for the table subtitle.

- footnote:

  Optional additional footnote text. Appended after any automatic
  footnotes (log-transform, FDR).

- fdr_footnote:

  Logical. Automatically add a source note explaining the FDR correction
  when a `p_fdr` column is present (default `TRUE`).

- ...:

  Passed to the underlying
  [`render_gt()`](https://clerkr.circadia-lab.uk/reference/render_gt.md),
  [`render_reactable()`](https://clerkr.circadia-lab.uk/reference/render_reactable.md),
  or
  [`render_latex()`](https://clerkr.circadia-lab.uk/reference/render_latex.md).

## Value

A `gt_tbl`,
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html),
or `knit_asis` object depending on the `output` slot of `x`.

## Examples

``` r
tbl_descriptive(clerk_example, group = sex, output = "gt", fdr = TRUE) |>
  clerk_render(title = "Table 1")


  


Table 1
```
