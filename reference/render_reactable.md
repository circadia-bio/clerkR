# Render a clerk_tbl as an interactive HTML table

Renders a `clerk_tbl` as a `reactable` interactive HTML table. Typically
called indirectly via
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md).

## Usage

``` r
render_reactable(x, title = NULL, ...)
```

## Arguments

- x:

  A `clerk_tbl` object.

- title:

  Optional character string displayed above the table.

- ...:

  Passed to
  [`reactable::reactable()`](https://glin.github.io/reactable/reference/reactable.html).

## Value

A `reactable` htmlwidget.

## Examples

``` r
tbl_descriptive(clerk_example, group = sex, output = "html") |>
  clerk_render()

{"x":{"tag":{"name":"Reactable","attribs":{"data":{"variable":["age","hdl","glucose","bmi","waist","systolic_bp","tmt_time","verbal_fluency","bdi","panas_neg","life_satisfaction"],"n":[300,300,300,300,300,300,300,300,300,300,300],"overall":["46.76 ± 14.15","46.81 ± 10.11","91.68 ± 24.65","26.15 ± 4.91","92.07 ± 11.56","123.25 ± 17.77","129.24 ± 64.98","14.98 ± 4.63","13.64 ± 9.26","20.98 ± 7.48","18.02 ± 4.23"],"Female":["46.42 ± 13.63","48.32 ± 9.78","92.61 ± 24.49","26.43 ± 4.84","92.14 ± 11.32","120.36 ± 17.86","132.81 ± 66.77","15.08 ± 4.44","15.07 ± 8.97","22.50 ± 7.27","17.40 ± 4.25"],"Male":["47.35 ± 15.09","44.08 ± 10.18","90.01 ± 24.96","25.64 ± 5.01","91.93 ± 12.03","128.48 ± 16.45","122.81 ± 61.40","14.79 ± 4.97","11.05 ± 9.26","18.25 ± 7.09","19.14 ± 3.99"],"statistic":["t = -0.53","t = 3.50","t = 0.87","t = 1.32","t = 0.15","t = -3.97","t = 1.31","t = 0.52","t = 3.65","t = 4.92","t = -3.54"],"p":[0.599200637297549,0.000559987784109206,0.386330886174719,0.189540899730172,0.879292237765551,9.52140709941389e-05,0.191648884494739,0.606201250667594,0.000332551366710254,1.66252652045961e-06,0.00048809216056523],"domain":["All variables","All variables","All variables","All variables","All variables","All variables","All variables","All variables","All variables","All variables","All variables"]},"columns":[{"id":"variable","name":"variable","type":"character"},{"id":"n","name":"n","type":"numeric"},{"id":"overall","name":"overall","type":"character"},{"id":"Female","name":"Female","type":"character"},{"id":"Male","name":"Male","type":"character"},{"id":"statistic","name":"statistic","type":"character"},{"id":"p","name":"p","type":"numeric"},{"id":"domain","name":"domain","type":"character"}],"searchable":true,"highlight":true,"striped":true,"compact":true,"dataKey":"850d0468578b9cee15cf89a5ebb08f26"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
```
