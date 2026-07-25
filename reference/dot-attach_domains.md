# Attach domain (and, for nested domains, subdomain) columns to a table.

`domains` accepts two shapes, and the two can be mixed within one list:

- flat: list("Metabolic" = c("hdl", "glucose"))

- nested: list("Mental health" = list("Baseline" = c("bdi_bl", ...),
  "Follow-up 1" = c("bdi_fu1", ...))) A flat entry gets subdomain = "".
  A nested entry's subdomain is the name of its inner list element.
  `domain_group` is the compound label used as gt's single row-group
  column – the domain and subdomain names joined with an em dash when
  there's a subdomain, or just the domain name when there isn't.
  reactable ignores `domain_group` and groups on domain/subdomain
  directly for true nesting. Both `domain` and `domain_group` are
  returned as factors with levels in the order variables were supplied
  in `domains`, so row-group order in the rendered table always matches
  the order the user wrote them in, rather than falling back to
  alphabetical.

## Usage

``` r
.attach_domains(tbl, domains, domain_other = "")
```
