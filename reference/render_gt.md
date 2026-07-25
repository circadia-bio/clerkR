# Render a clerk_tbl as a gt table (Word / PDF)

Renders a `clerk_tbl` as a `gt` table with clerkR styling applied via
[`clerk_theme()`](https://clerkr.circadia-lab.uk/reference/clerk_theme.md).
Domain groupings become row-group labels; log-transformed variables
receive an automatic footnote; FDR-corrected tables receive an automatic
source note. Typically called indirectly via
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md).

Domains may be nested (a named list of named lists) to express
sub-sections within a domain, e.g. repeated timepoints within a "Mental
health" domain. `gt` itself has no native support for two-level
row-group headers, so a nested domain renders as a single compound row
group labelled `"Domain — Subdomain"`. For a table with true expandable
nested groups, use `output = "html"` instead (see
[`render_reactable()`](https://clerkr.circadia-lab.uk/reference/render_reactable.md)).

## Usage

``` r
render_gt(
  x,
  title = NULL,
  subtitle = NULL,
  footnote = NULL,
  footnotes = NULL,
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

  Optional character vector of blanket footnotes, one source note per
  element.

- footnotes:

  Optional list of targeted footnotes. Each element is a list with
  `text` and either `rows` (variable names) or `cols` (column names).

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
