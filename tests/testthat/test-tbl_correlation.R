test_that("tbl_correlation returns a clerk_tbl", {
  result <- tbl_correlation(clerk_cor_example)
  expect_s3_class(result, "clerk_tbl")
  expect_equal(result$type, "correlation")
})

test_that("tbl_correlation table has expected columns", {
  result <- tbl_correlation(clerk_cor_example)
  nms <- names(result$table)
  expect_true("variable" %in% nms)
  expect_true("outcome"  %in% nms)
  expect_true("r"        %in% nms)
  expect_true("p"        %in% nms)
})

test_that("tbl_correlation FDR adds p_fdr column", {
  result <- tbl_correlation(clerk_cor_example, fdr = TRUE)
  expect_true("p_fdr" %in% names(result$table))
})

test_that("tbl_correlation fdr_ns replaces non-survivors with ns", {
  # create data where BH p-values will not survive
  dat <- data.frame(
    variable = paste0("v", 1:20),
    outcome  = "y",
    r        = runif(20, -0.1, 0.1),
    p        = c(0.0005, runif(19, 0.4, 0.9))
  )
  result <- tbl_correlation(dat, fdr = TRUE)
  # at least some rows should show "ns"
  expect_true(any(result$table$p_fdr == "ns"))
})

test_that("tbl_correlation fdr_ns = FALSE shows numeric FDR values", {
  dat <- data.frame(
    variable = paste0("v", 1:10),
    outcome  = "y",
    r        = runif(10, -0.1, 0.1),
    p        = runif(10, 0.4, 0.9)
  )
  result <- tbl_correlation(dat, fdr = TRUE, fdr_ns = FALSE)
  expect_false(any(result$table$p_fdr == "ns", na.rm = TRUE))
})

test_that("tbl_correlation pivot produces wide output", {
  result <- tbl_correlation(clerk_cor_example, pivot = TRUE)
  expect_true(result$pivot)
  # outcomes should become columns
  outcomes <- unique(clerk_cor_example$outcome)
  for (o in outcomes) expect_true(o %in% names(result$table))
})

test_that("tbl_correlation stores domain_other", {
  result <- tbl_correlation(clerk_cor_example, domain_other = "Other")
  expect_equal(result$domain_other, "Other")
})
