# clerkR NEWS

## clerkR 0.1.1

### Bug fixes

* Fixed a critical formatting bug in `.fmt_p()` where using `ifelse()` with a
  scalar `p_style` condition caused all p-values in a vector to format
  identically (the value of the first element was recycled across all rows).
  Replaced the inner `ifelse()` with `if/else` for the scalar check. This
  affected all table archetypes when `fdr = TRUE` — FDR-corrected p-values
  were displaying incorrect numeric values.

* `fdr_ns` now reliably replaces non-surviving FDR cells with `"ns"`.
  Previously, option lookup could silently return `NULL` before `.onLoad()`
  had run, causing `isTRUE(NULL)` to evaluate to `FALSE` and the replacement
  to be skipped. `.get_clerk_options()` now falls back to built-in defaults
  via `getOption(key, default = value)`.

* Fixed `.attach_domains()` crashing on 0-row tables by replacing
  `tbl[["domain"]] <- "All variables"` with `rep("All variables", nrow(tbl))`.

* Renamed `fdr_threshold` → `fdr_alpha` throughout to make clear that the
  threshold is applied to the **BH-adjusted** p-value, not the raw p.

---

## clerkR 0.1.0

Initial release.

### Table archetypes

* `tbl_descriptive()` — Table 1-style descriptive summary with optional group
  comparisons (t-test, ANOVA, chi-squared), domain grouping, log-transform
  footnotes, and BH FDR correction.
* `tbl_simple()` — Descriptive summary without inferential tests.
* `tbl_correlation()` — Partial correlation results with r, p, and optional
  FDR-corrected p column. Supports pivot to wide format.
* `tbl_regression()` — Regression coefficients (β, SE, 95% CI, p) from
  `broom::tidy()` output. Supports exponentiation and FDR correction.
* `tbl_heritability()` — Narrow-sense heritability estimates (h², 95% CI,
  LRT p, σ²a, σ²e) compatible directly with `R-itable::herit_batch()`.

### Rendering

* `clerk_render()` — unified S3 dispatcher.
* `render_gt()` — `gt` output for Word/PDF with domain row groups, themed
  headers, and automatic footnotes for log-transformed variables.
* `render_reactable()` — interactive `reactable` HTML output with domain
  grouping and search.
* `render_latex()` — LaTeX output via `gt::as_latex()`.

### Options

* `clerk_options()` — session-level formatting defaults following biomed/APA
  conventions. Loaded automatically on package attach via `.onLoad()`.
  Controls decimal places (`digits`, `r_digits`, `p_digits`), p-value display
  style (`p_style`: `"apa"`, `"plain"`, `"stars"`, `"stars_p"`), significance
  stars, and FDR non-survival labelling (`fdr_ns`, `fdr_alpha`, `fdr_ns_label`).

### Theme and palette

* `clerk_theme()` — `gt` theme with navy/teal clerkR visual identity.
* `clerk_palette()`, `clerk_colour()` — named palette accessors.
* `clerk_diverging()`, `clerk_sequential()` — colour ramps for visualisation.

### Example data

* `clerk_example` — 300-participant synthetic dataset with metabolic,
  anthropometric, cognitive, and mental health variables.
* `clerk_cor_example` — 16 synthetic partial correlation results.
* `clerk_reg_example` — 7 synthetic regression terms (broom::tidy format).
* `clerk_h2_example` — 12 synthetic heritability estimates (herit_batch format).

### Authors

Lucas França and Mario Leocadio-Miguel (Circadia Lab, Northumbria University).
