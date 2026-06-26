# clerkR: Publication-Ready Tables for Biomedical Research

`clerkR` transforms standard R data frames into publication-ready tables
across a handful of common archetypes found in biomedical and
neuroscience manuscripts.

### Table archetypes

- **Descriptive / Table 1**
  ([`tbl_descriptive()`](https://clerkr.circadia-lab.uk/reference/tbl_descriptive.md)):
  sample characteristics with group comparisons, mean ± SD, t-test /
  chi-squared statistics.

- **Heritability** (`tbl_heritability()`): h2, confidence intervals, LRT
  p, variance components.

- **Correlation** (`tbl_correlation()`): r, p, FDR-corrected p, domain
  grouping.

- **Regression** (`tbl_regression()`): beta, SE, CI, p, FDR annotation.

- **Simple descriptive** (`tbl_simple()`): means/SDs, no inferential
  test.

### Rendering

All constructors return a `clerk_tbl` S3 object. Use
[`render_gt()`](https://clerkr.circadia-lab.uk/reference/render_gt.md)
for Word/PDF output and
[`render_reactable()`](https://clerkr.circadia-lab.uk/reference/render_reactable.md)
for interactive HTML.

## See also

Useful links:

- <https://github.com/circadia-bio/clerkR>

- Report bugs at <https://github.com/circadia-bio/clerkR/issues>

## Author

**Maintainer**: Lucas G. S. Franca <lucas.franca@northumbria.ac.uk>
([ORCID](https://orcid.org/0000-0003-0853-1319))

Authors:

- Lucas G. S. Franca <lucas.franca@northumbria.ac.uk>
  ([ORCID](https://orcid.org/0000-0003-0853-1319))
