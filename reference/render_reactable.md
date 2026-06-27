# Render a clerk_tbl as an interactive HTML table

Renders a `clerk_tbl` as a `reactable` interactive HTML table with
optional title and subtitle rendered above the widget. Typically called
indirectly via
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md).

## Usage

``` r
render_reactable(x, title = NULL, subtitle = NULL, footnote = NULL, ...)
```

## Arguments

- x:

  A `clerk_tbl` object.

- title:

  Optional character string displayed as a heading above the table.

- subtitle:

  Optional character string displayed as a subheading.

- footnote:

  Optional character string displayed as a note below the table.

- ...:

  Passed to
  [`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html).

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing the title, reactable widget, and optional footnote, or a bare
`reactable` if no title/subtitle/footnote are provided.

## Examples

``` r
tbl_correlation(clerk_cor_example, output = "html") |>
  clerk_render(title = "Partial correlations", subtitle = "age + sex controlled")
#> <p style="font-size:14px; font-weight:600; color:#293681;margin:0 0 2px 0; font-family:&#39;DM Sans&#39;,sans-serif;">Partial correlations</p>
#> <p style="font-size:12px; color:#4274D9;margin:0 0 8px 0; font-family:&#39;DM Sans&#39;,sans-serif;">age + sex controlled</p>
#> <div class="reactable html-widget html-fill-item" id="htmlwidget-e5c8c404fe174e4c81bd" style="width:auto;height:auto;"></div>
#> <script type="application/json" data-for="htmlwidget-e5c8c404fe174e4c81bd">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"variable":["hdl","glucose","bmi","waist","systolic_bp","bdi","panas_neg","life_satisfaction","hdl","glucose","bmi","waist","systolic_bp","bdi","panas_neg","life_satisfaction"],"outcome":["tmt_time","tmt_time","tmt_time","tmt_time","tmt_time","tmt_time","tmt_time","tmt_time","verbal_fluency","verbal_fluency","verbal_fluency","verbal_fluency","verbal_fluency","verbal_fluency","verbal_fluency","verbal_fluency"],"r":["+0.190","-0.229","-0.086","+0.279","+0.195","+0.096","+0.157","+0.247","+0.078","+0.216","+0.022","+0.047","-0.105","-0.176","+0.232","+0.201"],"p":["= 0.008","= 0.398","= 0.013","= 0.002","= 0.379","= 0.109","= 0.006","= 0.117","= 0.072","= 0.003","= 0.207","= 0.185","= 0.077","= 0.070","= 0.117","= 0.234"],"domain":["","","","","","","","","","","","","","","",""]},"columns":[{"id":"variable","name":"variable","type":"character"},{"id":"outcome","name":"outcome","type":"character"},{"id":"r","name":"r","type":"character"},{"id":"p","name":"p","type":"character"},{"id":"domain","name":"domain","type":"character"}],"searchable":true,"highlight":true,"striped":true,"compact":true,"dataKey":"47d4f166a5d7d8299ba0fae6e969ed5a"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>
```
