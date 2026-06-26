# Access a single clerkR colour by name

Convenience accessor for a single named colour from the clerkR palette.

## Usage

``` r
clerk_colour(name)
```

## Arguments

- name:

  Character string. One of the named entries in
  [`clerk_palette()`](https://clerkr.circadia-lab.uk/reference/clerk_palette.md).

## Value

A single hex colour string.

## Examples

``` r
clerk_colour("navy")
#> [1] "#293681"
clerk_colour("header_bg")
#> [1] "#95CCDD"
```
