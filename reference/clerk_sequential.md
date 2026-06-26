# Build a clerkR sequential colour scale

Returns a vector of `n` hex colours interpolated along the clerkR
sequential scale: near-white (`#D0E7E6`) → navy (`#293681`). Suitable
for shading columns by magnitude (e.g. heritability h², correlation r).

## Usage

``` r
clerk_sequential(n = 7, reverse = FALSE)
```

## Arguments

- n:

  Integer. Number of colour steps (default `7`).

- reverse:

  Logical. Reverse the scale direction (default `FALSE`, light = low,
  dark = high).

## Value

A character vector of `n` hex colour codes.

## Examples

``` r
clerk_sequential()
#> [1] "#D0E7E6" "#B2D9E1" "#95CCDD" "#6BA0DB" "#4274D9" "#3555AD" "#293681"
clerk_sequential(n = 5, reverse = TRUE)
#> [1] "#293681" "#3B64C3" "#6BA0DB" "#A3D2DF" "#D0E7E6"
```
