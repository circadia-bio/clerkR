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
