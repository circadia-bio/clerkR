# Render a clerk_tbl to its target output format

Dispatches to the correct renderer based on the `output` slot set at
construction time
(`tbl_descriptive(..., output = "gt"|"html"|"latex")`). All render
arguments (`title`, `subtitle`, `footnote`) can be supplied here and are
forwarded to the underlying renderer.

## Usage

``` r
render(x, title = NULL, subtitle = NULL, footnote = NULL, ...)
```

## Arguments

- x:

  A `clerk_tbl` object.

- title:

  Optional character string for the table title.

- subtitle:

  Optional character string for the table subtitle.

- footnote:

  Optional additional footnote text.

- ...:

  Passed to the underlying
  [`render_gt()`](https://clerkr.circadia-lab.uk/reference/render_gt.md),
  [`render_reactable()`](https://clerkr.circadia-lab.uk/reference/render_reactable.md),
  or
  [`render_latex()`](https://clerkr.circadia-lab.uk/reference/render_latex.md).

## Value

A `gt_tbl`, `reactable`, or `knit_asis` object depending on the `output`
slot of `x`.

## Examples

``` r
tbl_descriptive(clerk_example, group = sex, output = "gt") |>
  render(title = "Table 1")


  


Table 1
```
