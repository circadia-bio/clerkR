# Build a clerkR diverging colour scale

Returns a vector of `n` hex colours interpolated along the clerkR
diverging scale: dusty terracotta (`#D4907E`) — neutral off-white
(`#F0EEEC`) — navy (`#293681`). Suitable for use with
[`gt::data_color()`](https://gt.rstudio.com/reference/data_color.html)
or
[`scales::col_numeric()`](https://scales.r-lib.org/reference/col_numeric.html).

## Usage

``` r
clerk_diverging(n = 9, reverse = FALSE)
```

## Arguments

- n:

  Integer. Number of colour steps (default `9`). Use an odd number to
  include the neutral midpoint.

- reverse:

  Logical. Reverse the scale direction (default `FALSE`, terracotta =
  low, navy = high).

## Value

A character vector of `n` hex colour codes.

## Examples

``` r
clerk_diverging()
#> [1] "#D4907E" "#DBA799" "#E2BFB5" "#E9D6D0" "#F0EEEC" "#BEC0D1" "#8C92B6"
#> [8] "#5A649B" "#293681"
clerk_diverging(n = 5)
#> [1] "#D4907E" "#E2BFB5" "#F0EEEC" "#8C92B6" "#293681"
clerk_diverging(n = 11, reverse = TRUE)
#>  [1] "#293681" "#505A96" "#787FAB" "#A0A4C1" "#C8C9D6" "#F0EEEC" "#EADBD6"
#>  [8] "#E4C8C0" "#DFB5AA" "#D9A294" "#D4907E"
```
