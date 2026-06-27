# clerkR: Publication-Ready Tables for Biomedical Research

`clerkR` transforms standard R data frames into publication-ready tables
across a handful of common archetypes found in biomedical and
neuroscience manuscripts.

### Table archetypes

- **Descriptive / Table 1**
  ([`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md)):
  sample characteristics with group comparisons, mean ± SD, t-test /
  chi-squared statistics.

- **Heritability**
  ([`tbl_heritability()`](https://clerkr.circadia-lab.uk/reference/tbl_heritability.md)):
  h2, confidence intervals, LRT p, variance components. Directly
  compatible with `R-itable::herit_batch()`.

- **Correlation**
  ([`tbl_correlation()`](https://clerkr.circadia-lab.uk/reference/tbl_correlation.md)):
  r, p, FDR-corrected p, domain grouping.

- **Regression**
  ([`tbl_regression()`](https://clerkr.circadia-lab.uk/reference/tbl_regression.md)):
  beta, SE, CI, p, FDR annotation.

- **Simple descriptive**
  ([`tbl_simple()`](https://clerkr.circadia-lab.uk/reference/tbl_simple.md)):
  means/SDs, no inferential test.

### Rendering

All constructors return a `clerk_tbl` S3 object. Pass to
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md)
to dispatch to `gt` (Word/PDF), `reactable` (HTML), or LaTeX output.

### Options

Formatting defaults (decimal places, p-value style, FDR display) are
controlled via
[`clerk_options()`](https://clerkr.circadia-lab.uk/reference/clerk_options.md).
Biomed/APA defaults are loaded automatically on package attach.

## See also

Useful links:

- <https://clerkr.circadia-lab.uk>

- <https://github.com/circadia-bio/clerkR>

- Report bugs at <https://github.com/circadia-bio/clerkR/issues>

## Author

**Maintainer**: Lucas G. S. Franca <lucas.franca@northumbria.ac.uk>
([ORCID](https://orcid.org/0000-0003-0853-1319))

Authors:

- Lucas G. S. Franca <lucas.franca@northumbria.ac.uk>
  ([ORCID](https://orcid.org/0000-0003-0853-1319))
