# Apply the clerkR gt theme to a gt table

Applies the clerkR visual style to an existing `gt_tbl` object: light
teal column headers with navy text, near-white row group bars, clean
borders, and consistent typography. Can be applied after any `gt`
pipeline.

This function is called automatically by
[`render_gt()`](https://clerkr.circadia-lab.uk/reference/render_gt.md)
and
[`render_latex()`](https://clerkr.circadia-lab.uk/reference/render_latex.md);
you only need it directly if you are building a `gt` table outside of
the `tbl_*` constructors.

## Usage

``` r
clerk_theme(gt_tbl)
```

## Arguments

- gt_tbl:

  A `gt_tbl` object.

## Value

A `gt_tbl` object with clerkR styling applied.

## Examples

``` r
if (FALSE) { # \dontrun{
gt::gt(mtcars) |> clerk_theme()
} # }
```
