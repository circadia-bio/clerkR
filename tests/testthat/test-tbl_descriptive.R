test_that("tbl_descriptive returns a clerk_tbl", {
  result <- tbl_descriptive(clerk_example, group = sex)
  expect_s3_class(result, "clerk_tbl")
  expect_equal(result$type, "descriptive")
  expect_equal(result$group, "sex")
})

test_that("tbl_descriptive without group still works", {
  result <- tbl_descriptive(clerk_example)
  expect_s3_class(result, "clerk_tbl")
  expect_null(result$group)
  expect_true("overall" %in% names(result$table))
})

test_that("tbl_descriptive table has expected columns with group", {
  result <- tbl_descriptive(clerk_example, group = sex)
  nms <- names(result$table)
  expect_true("variable"  %in% nms)
  expect_true("n"         %in% nms)
  expect_true("Female"    %in% nms)
  expect_true("Male"      %in% nms)
  expect_true("statistic" %in% nms)
  expect_true("p"         %in% nms)
})

test_that("log_vars stored correctly", {
  result <- tbl_descriptive(clerk_example, group = sex,
                             log_vars = c("tmt_time"))
  expect_equal(result$log_vars, "tmt_time")
})

test_that("domains stored correctly", {
  doms <- list("Metabolic" = c("hdl", "glucose"))
  result <- tbl_descriptive(clerk_example, group = sex, domains = doms)
  expect_equal(result$domains, doms)
})

test_that("FDR correction adds p_fdr column", {
  result <- tbl_descriptive(clerk_example, group = sex, fdr = TRUE)
  expect_true("p_fdr" %in% names(result$table))
})

test_that("render_gt returns a gt_tbl", {
  result <- tbl_descriptive(clerk_example, group = sex) |>
    render_gt(title = "Test table")
  expect_s3_class(result, "gt_tbl")
})
