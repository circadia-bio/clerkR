test_that("tbl_regression returns a clerk_tbl", {
  result <- tbl_regression(clerk_reg_example)
  expect_s3_class(result, "clerk_tbl")
  expect_equal(result$type, "regression")
})

test_that("tbl_regression table has expected columns", {
  result <- tbl_regression(clerk_reg_example)
  nms <- names(result$table)
  expect_true("variable" %in% nms)
  expect_true("beta"     %in% nms)
  expect_true("se"       %in% nms)
  expect_true("ci"       %in% nms)
  expect_true("p"        %in% nms)
})

test_that("tbl_regression FDR adds p_fdr column", {
  result <- tbl_regression(clerk_reg_example, fdr = TRUE)
  expect_true("p_fdr" %in% names(result$table))
})

test_that("tbl_regression exponentiate transforms estimates", {
  raw <- tbl_regression(clerk_reg_example)
  exp <- tbl_regression(clerk_reg_example, exponentiate = TRUE)
  # beta values should differ
  expect_false(identical(raw$table$beta, exp$table$beta))
  expect_true(exp$exponentiate)
})

test_that("tbl_regression stores domain_other", {
  result <- tbl_regression(clerk_reg_example, domain_other = "Covariates")
  expect_equal(result$domain_other, "Covariates")
})
