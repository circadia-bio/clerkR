# Apply fdr_ns replacement to already-formatted FDR p-value strings. x_raw: the numeric BH-adjusted p-values. formatted: character vector already produced by .fmt_p().

Apply fdr_ns replacement to already-formatted FDR p-value strings.
x_raw: the numeric BH-adjusted p-values. formatted: character vector
already produced by .fmt_p().

## Usage

``` r
.apply_fdr_ns(x_raw, formatted, fdr_ns, fdr_alpha, fdr_ns_label)
```
