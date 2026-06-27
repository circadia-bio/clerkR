# Render a clerk_tbl as a LaTeX table

Renders a `clerk_tbl` as a LaTeX table via
[`gt::as_latex()`](https://gt.rstudio.com/reference/as_latex.html).
Typically called indirectly via
[`clerk_render()`](https://clerkr.circadia-lab.uk/reference/clerk_render.md).

## Usage

``` r
render_latex(x, title = NULL, subtitle = NULL, footnote = NULL, ...)
```

## Arguments

- x:

  A `clerk_tbl` object.

- title:

  Optional table title (used as the `\caption{}`).

- subtitle:

  Optional subtitle appended to the caption.

- footnote:

  Optional additional footnote.

- ...:

  Reserved for future use.

## Value

A `knit_asis` character object containing the LaTeX table source.

## Examples

``` r
tbl_descriptive(clerk_example, group = sex, output = "latex") |>
  clerk_render(title = "Sample characteristics by sex")
#> [1] "\\begin{table}[t]\n\\caption*{\n{\\fontsize{10}{12}\\selectfont  Sample characteristics by sex\\fontsize{9}{11}\\selectfont }\n} \n\\fontsize{9.0pt}{11.0pt}\\selectfont\n\\begin{tabular*}{\\linewidth}{@{\\extracolsep{\\fill}}l|rlllll}\n\\toprule\n & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{n}}} & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{Overall}}} & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{Female}}} & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{Male}}} & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{Statistic}}} & {\\bfseries \\cellcolor[HTML]{95CCDD}{\\textcolor[HTML]{293681}{p}}} \\\\ \n\\midrule\\addlinespace[2.5pt]\n\\multicolumn{7}{l}{{\\bfseries \\cellcolor[HTML]{D0E7E6}{\\textcolor[HTML]{293681}{All variables}}}} \\\\[2.5pt] \n\\midrule\\addlinespace[2.5pt]\n{\\itshape \\textcolor[HTML]{293681}{age}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{46.76 ± 14.15}} & {\\textcolor[HTML]{293681}{46.42 ± 13.63}} & {\\textcolor[HTML]{293681}{47.35 ± 15.09}} & {\\textcolor[HTML]{293681}{t = -0.53}} & {\\textcolor[HTML]{293681}{= 0.599}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{hdl}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{46.81 ± 10.11}} & {\\textcolor[HTML]{293681}{48.32 ± 9.78}} & {\\textcolor[HTML]{293681}{44.08 ± 10.18}} & {\\textcolor[HTML]{293681}{t = 3.50}} & {\\textcolor[HTML]{293681}{< 0.001}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{glucose}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{91.68 ± 24.65}} & {\\textcolor[HTML]{293681}{92.61 ± 24.49}} & {\\textcolor[HTML]{293681}{90.01 ± 24.96}} & {\\textcolor[HTML]{293681}{t = 0.87}} & {\\textcolor[HTML]{293681}{= 0.386}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{bmi}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{26.15 ± 4.91}} & {\\textcolor[HTML]{293681}{26.43 ± 4.84}} & {\\textcolor[HTML]{293681}{25.64 ± 5.01}} & {\\textcolor[HTML]{293681}{t = 1.32}} & {\\textcolor[HTML]{293681}{= 0.190}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{waist}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{92.07 ± 11.56}} & {\\textcolor[HTML]{293681}{92.14 ± 11.32}} & {\\textcolor[HTML]{293681}{91.93 ± 12.03}} & {\\textcolor[HTML]{293681}{t = 0.15}} & {\\textcolor[HTML]{293681}{= 0.879}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{systolic\\_bp}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{123.25 ± 17.77}} & {\\textcolor[HTML]{293681}{120.36 ± 17.86}} & {\\textcolor[HTML]{293681}{128.48 ± 16.45}} & {\\textcolor[HTML]{293681}{t = -3.97}} & {\\textcolor[HTML]{293681}{< 0.001}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{tmt\\_time}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{129.24 ± 64.98}} & {\\textcolor[HTML]{293681}{132.81 ± 66.77}} & {\\textcolor[HTML]{293681}{122.81 ± 61.40}} & {\\textcolor[HTML]{293681}{t = 1.31}} & {\\textcolor[HTML]{293681}{= 0.192}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{verbal\\_fluency}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{14.98 ± 4.63}} & {\\textcolor[HTML]{293681}{15.08 ± 4.44}} & {\\textcolor[HTML]{293681}{14.79 ± 4.97}} & {\\textcolor[HTML]{293681}{t = 0.52}} & {\\textcolor[HTML]{293681}{= 0.606}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{bdi}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{13.64 ± 9.26}} & {\\textcolor[HTML]{293681}{15.07 ± 8.97}} & {\\textcolor[HTML]{293681}{11.05 ± 9.26}} & {\\textcolor[HTML]{293681}{t = 3.65}} & {\\textcolor[HTML]{293681}{< 0.001}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{panas\\_neg}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{20.98 ± 7.48}} & {\\textcolor[HTML]{293681}{22.50 ± 7.27}} & {\\textcolor[HTML]{293681}{18.25 ± 7.09}} & {\\textcolor[HTML]{293681}{t = 4.92}} & {\\textcolor[HTML]{293681}{< 0.001}} \\\\ \n{\\itshape \\textcolor[HTML]{293681}{life\\_satisfaction}} & {\\textcolor[HTML]{293681}{300}} & {\\textcolor[HTML]{293681}{18.02 ± 4.23}} & {\\textcolor[HTML]{293681}{17.40 ± 4.25}} & {\\textcolor[HTML]{293681}{19.14 ± 3.99}} & {\\textcolor[HTML]{293681}{t = -3.54}} & {\\textcolor[HTML]{293681}{< 0.001}} \\\\ \n\\bottomrule\n\\end{tabular*}\n\\end{table}\n"
#> attr(,"class")
#> [1] "knit_asis"
#> attr(,"knit_cacheable")
#> [1] NA
```
