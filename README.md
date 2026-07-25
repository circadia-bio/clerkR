# 📋 clerkR <img src="man/figures/logo.svg" align="right" height="140"/>

**A clerk keeps tabs — `clerkR` keeps yours publication-ready.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![R](https://img.shields.io/badge/R-%3E%3D4.1.0-276DC3)](https://cran.r-project.org/)
[![pkgdown](https://img.shields.io/badge/docs-clerkr.circadia--lab.uk-4274D9)](https://clerkr.circadia-lab.uk)

---

> ⚠️ **clerkR is in early development and has not been formally tested.** The API may change without notice, estimation results have not yet been validated against a reference implementation, and the package has not undergone peer review. Use with caution and verify outputs independently before using in any research context.

---

## 📖 What is clerkR?

`clerkR` transforms standard R data frames into publication-ready tables for
biomedical and neuroscience manuscripts. Rather than wrestling with formatting
each time, `clerkR` reduces the most common table types to a handful of
opinionated constructor functions that share consistent theming, domain
grouping, footnote handling, and a unified rendering pipeline for Word/PDF
(`gt`), interactive HTML (`reactable`), and LaTeX output.

## ✨ Features

- 📋 **Five table archetypes** covering ~90% of what appears in a biomed paper
- 🎨 **clerkR theme** — light teal headers, navy text, clean borders, consistent throughout
- 🗂️ **Domain/section grouping** — organise rows under labelled section headers, with optional nested sub-sections (e.g. repeated timepoints within a domain)
- 📝 **Footnotes** — automatic notes for log-transformed variables and FDR correction, plus your own blanket or row/column-targeted footnotes
- 🖨️ **Three render targets** — `gt` for Word/PDF, `reactable` for HTML, LaTeX for manuscripts
- 🔢 **Output baked in at construction** — set `output = "gt"` once, then just `|> clerk_render()`
- 🔗 **R-itable compatible** — `herit_batch()` output pipes straight into `tbl_heritability()`
- 🧩 **Composable** — all constructors return a `clerk_tbl` S3 object

## 📋 Table archetypes

| Function | Use case | Example |
|---|---|---|
| `tbl_descriptive()` | Sample characteristics by group, mean ± SD, t/χ² | Table 1 |
| `tbl_simple()` | Descriptive summary, no inferential test | Supplementary table |
| `tbl_correlation()` | Partial correlations, r, p, p† | Correlation results |
| `tbl_regression()` | β, SE, 95% CI, p, FDR — accepts `broom::tidy()` | Linear/logistic models |
| `tbl_heritability()` | h², 95% CI, LRT p, σ²a/σ²e — accepts `herit_batch()` | Heritability results |

## 🚀 Getting Started

### Installation

```r
# clerkR, from r-universe
install.packages("clerkR", repos = "https://circadia-bio.r-universe.dev")

# For the heritability workflow, also install R-itable (same repo)
install.packages("Ritable", repos = "https://circadia-bio.r-universe.dev")
```

Or from GitHub directly:

```r
remotes::install_github("circadia-bio/clerkR")
remotes::install_github("circadia-bio/R-itable")
```

### The one-two pattern

```r
library(clerkR)

tbl_descriptive(
  clerk_example,
  group   = sex,
  domains = list(
    "Metabolic"      = c("hdl", "glucose", "bmi"),
    "Anthropometric" = c("waist", "systolic_bp"),
    "Cognitive"      = c("tmt_time", "verbal_fluency"),
    "Mental health"  = c("bdi", "panas_neg", "life_satisfaction")
  ),
  log_vars = "tmt_time",
  fdr      = TRUE,
  output   = "gt"
) |>
  clerk_render(title = "Table 1. Sample characteristics by sex")
```

### Heritability from R-itable

```r
herit_batch(traits, grm = A, data = dat, covs_list = covs_list) |>
  tbl_heritability(
    model    = "covariates",
    sigma2_a = "sigma2_a",
    sigma2_e = "sigma2_e",
    fdr      = TRUE,
    output   = "gt"
  ) |>
  clerk_render(title = "Heritability estimates")
```

### Nested domains & custom footnotes

A domain can itself hold sub-sections — handy for repeated timepoints — and
footnotes aren't limited to one blanket note per table:

```r
tbl_descriptive(
  longitudinal_example,
  group   = sex,
  domains = list(
    "Mental health" = list(
      "Baseline"    = c("bdi_bl",  "panas_neg_bl"),
      "Follow-up 1" = c("bdi_fu1", "panas_neg_fu1")
    )
  ),
  output = "gt"
) |>
  clerk_render(
    title     = "Mental health by timepoint",
    footnote  = c("Data collected 2024-2025.", "Listwise exclusion applied."),
    footnotes = list(list(text = "Self-report questionnaire.", rows = "bdi_bl"))
  )
```

See `vignette("formatting-options")` for the full write-up, including how
nested domains render (compound row-group label for `gt`/`latex`, a true
expandable tree for `output = "html"`).

## 🎨 Colour palette

```r
clerk_palette()     # full named palette
clerk_diverging()   # terracotta → off-white → navy (9 steps)
clerk_sequential()  # near-white → navy (7 steps)
```

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `dplyr` | ≥ 1.1.0 | Data manipulation |
| `tidyr` | any | Reshaping |
| `rlang` | any | Tidy evaluation |
| `gt` | ≥ 0.10.0 | Word/PDF table rendering |
| `reactable` | ≥ 0.4.0 | Interactive HTML rendering |
| `htmltools` | any | Reactable title/footnote chrome |
| `knitr` | any | LaTeX output |
| `grDevices` | any | Colour ramps |
| `stats` | any | t-test, ANOVA, chi-squared, FDR correction |
| `utils` | any | Internal helpers |

## 👥 Authors

| Role | Name |
|---|---|
| Author, maintainer | [Lucas França](https://orcid.org/0000-0003-0853-1319) |
| Author | [Mario Leocadio-Miguel](https://orcid.org/0000-0002-7248-3529) |

## 🤝 Related Tools

- ⌚️ [**zeitR**](https://github.com/circadia-bio/zeitR) — actigraphy analysis and circadian metrics
- 🛌 [**slumbR**](https://github.com/circadia-bio/slumbR) — sleep diary processing
- 🧮 [**tallieR**](https://github.com/circadia-bio/tallieR) — questionnaire and sociodemographic data
- 🔄 [**syncR**](https://github.com/circadia-bio/syncR) — integrates zeitR, slumbR, and tallieR
- 🧬 [**R-itable**](https://github.com/circadia-bio/R-itable) — pedigree-based heritability estimation
- 🔬 [**circadia-bio**](https://github.com/circadia-bio) — the Circadia Lab GitHub organisation

## 📄 Licence

Released under the [MIT License](./LICENSE).

Copyright © Lucas França & Mario Leocadio-Miguel, 2026
