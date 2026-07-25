test_that(".fmt_p formats a vector correctly without recycling", {
  result <- clerkR:::.fmt_p(c(0.6668, 0.0012))
  expect_equal(result, c("= 0.667", "= 0.001"))
})

test_that(".fmt_p formats values below threshold with < prefix", {
  result <- clerkR:::.fmt_p(0.0005)
  expect_equal(result, "< 0.001")
})

test_that(".fmt_p plain style omits = prefix", {
  result <- clerkR:::.fmt_p(0.032, p_style = "plain")
  expect_equal(result, "0.032")
})

test_that(".fmt_p returns NA for NA input", {
  result <- clerkR:::.fmt_p(NA_real_)
  expect_true(is.na(result))
})

test_that("clerk_options sets and retrieves values", {
  clerk_options(p_digits = 2)
  expect_equal(clerkR:::.get_clerk_options()$p_digits, 2)
  clerk_options(reset = TRUE)
  expect_equal(clerkR:::.get_clerk_options()$p_digits, 3L)
})

test_that("clerk_options reset restores all defaults", {
  clerk_options(p_style = "plain", stars = TRUE, fdr_alpha = 0.01)
  clerk_options(reset = TRUE)
  opts <- clerkR:::.get_clerk_options()
  expect_equal(opts$p_style, "apa")
  expect_false(opts$stars)
  expect_equal(opts$fdr_alpha, 0.05)
})

test_that("domain_other blank by default — no NA group label", {
  result <- tbl_descriptive(clerk_example, group = sex)
  # After render, domain column should not contain NA
  tbl <- clerkR:::.attach_domains(result$table, result$domains,
                                   result$domain_other)
  expect_false(any(is.na(tbl$domain)))
})

test_that("render_gt adds FDR source note automatically", {
  gt_tbl <- tbl_descriptive(clerk_example, group = sex, fdr = TRUE) |>
    render_gt()
  # gt stores source notes in the source_notes list
  sn <- gt_tbl[["_source_notes"]]
  expect_true(length(sn) > 0)
})

test_that("render_gt FDR note suppressed with fdr_footnote = FALSE", {
  gt_tbl_with    <- tbl_descriptive(clerk_example, group = sex, fdr = TRUE) |>
    render_gt(fdr_footnote = TRUE)
  gt_tbl_without <- tbl_descriptive(clerk_example, group = sex, fdr = TRUE) |>
    render_gt(fdr_footnote = FALSE)
  expect_gt(length(gt_tbl_with[["_source_notes"]]),
            length(gt_tbl_without[["_source_notes"]]))
})

test_that("footnote accepts a vector and adds one source note per element", {
  gt_tbl <- tbl_simple(clerk_example) |>
    render_gt(footnote = c("Note one.", "Note two."))
  expect_equal(length(gt_tbl[["_source_notes"]]), 2)
})

test_that("footnotes attaches a targeted footnote to the gt table", {
  gt_tbl <- tbl_simple(clerk_example) |>
    render_gt(footnotes = list(
      list(text = "Assessed at 6-month follow-up.", rows = "bdi")
    ))
  expect_equal(length(gt_tbl[["_footnotes"]]), 1)
})

test_that(".has_nested_domains detects a nested list but not a flat one", {
  flat <- list("Metabolic" = c("hdl", "glucose"))
  nested <- list("Mental health" = list(
    "Baseline"   = c("bdi_bl", "panas_neg_bl"),
    "Follow-up 1" = c("bdi_fu1", "panas_neg_fu1")
  ))
  expect_false(clerkR:::.has_nested_domains(flat))
  expect_true(clerkR:::.has_nested_domains(nested))
  expect_false(clerkR:::.has_nested_domains(list()))
})

test_that(".attach_domains builds a compound domain_group label for nested domains", {
  domains <- list(
    "Metabolic"     = c("hdl", "glucose"),
    "Mental health" = list(
      "Baseline"    = c("bdi", "panas_neg"),
      "Follow-up 1" = c("bdi_fu1", "panas_neg_fu1")
    )
  )
  tbl <- data.frame(
    variable = c("hdl", "glucose", "bdi", "panas_neg",
                 "bdi_fu1", "panas_neg_fu1", "unassigned"),
    stringsAsFactors = FALSE
  )
  out <- clerkR:::.attach_domains(tbl, domains, domain_other = "Other")

  expect_true(all(c("domain", "subdomain", "domain_group") %in% names(out)))
  expect_equal(
    as.character(out$domain_group[out$variable == "bdi"]),
    "Mental health \u2014 Baseline"
  )
  expect_equal(
    as.character(out$domain_group[out$variable == "bdi_fu1"]),
    "Mental health \u2014 Follow-up 1"
  )
  expect_equal(as.character(out$domain_group[out$variable == "hdl"]),
               "Metabolic")
  expect_equal(as.character(out$domain_group[out$variable == "unassigned"]),
               "Other")
  # row order should follow the order domains/subdomains were written in,
  # not the incoming table's original row order
  expect_equal(
    as.character(out$domain_group),
    c("Metabolic", "Metabolic",
      "Mental health \u2014 Baseline", "Mental health \u2014 Baseline",
      "Mental health \u2014 Follow-up 1", "Mental health \u2014 Follow-up 1",
      "Other")
  )
})

test_that("nested domains still work through tbl_simple -> render_gt end to end", {
  gt_tbl <- tbl_simple(
    clerk_example,
    domains = list(
      "Mental health" = list(
        "Baseline" = c("bdi", "panas_neg")
      )
    )
  ) |> render_gt()
  expect_s3_class(gt_tbl, "gt_tbl")
})
