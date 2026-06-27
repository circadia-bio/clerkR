# Render a clerk_tbl as a gt table (Word / PDF)

Renders a `clerk_tbl` as a `gt` table with clerkR styling applied via
[`clerk_theme()`](https://clerkr.circadia-lab.uk/reference/clerk_theme.md).
Domain groupings become row-group labels; log-transformed variables
receive an automatic footnote; FDR-corrected tables receive an automatic
source note. Typically called indirectly via
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md).

## Usage

``` r
render_gt(
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

  Optional table title.

- subtitle:

  Optional table subtitle.

- footnote:

  Optional additional footnote.

- fdr_footnote:

  Logical. Add an automatic FDR source note when a `p_fdr` column is
  present (default `TRUE`).

- ...:

  Reserved for future use.

## Value

A `gt_tbl` object.

## Examples

``` r
tbl_descriptive(clerk_example, group = sex) |>
  render_gt(title = "Table 1")


  


Table 1
```
