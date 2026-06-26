# clerkR colour palette

Returns the named clerkR colour palette as a character vector of hex
codes. Individual colours can be accessed by name via
[`clerk_colour()`](https://clerkr.circadia-lab.uk/reference/clerk_colour.md).

The palette pairs a formal cool-blue range (navy → light teal →
near-white) with a dusty terracotta warm pole for diverging scales.

## Usage

``` r
clerk_palette()
```

## Value

A named character vector of hex codes.

## Examples

``` r
clerk_palette()
#>         navy     mid_blue   light_teal   near_white   terracotta    header_bg 
#>    "#293681"    "#4274D9"    "#95CCDD"    "#D0E7E6"    "#D4907E"    "#95CCDD" 
#>  header_text row_group_bg    body_text     positive     negative      neutral 
#>    "#293681"    "#D0E7E6"    "#293681"    "#293681"    "#D4907E"    "#F0EEEC" 
clerk_palette()[["header_bg"]]
#> [1] "#95CCDD"
```
