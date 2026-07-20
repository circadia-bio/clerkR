test_that("tbl_heritability returns a clerk_tbl", {
  result <- tbl_heritability(clerk_h2_example)
  expect_s3_class(result, "clerk_tbl")
  expect_equal(result$type, "heritability")
})

test_that("tbl_heritability table has expected columns", {
  result <- tbl_heritability(clerk_h2_example)
  nms <- names(result$table)
  expect_true("variable" %in% nms)
  expect_true("h2"       %in% nms)
  expect_true("ci_95"    %in% nms)
  expect_true("p"        %in% nms)
})

test_that("tbl_heritability sigma2 columns included when specified", {
  result <- tbl_heritability(
    clerk_h2_example,
    sigma2_a = "sigma2_a",
    sigma2_e = "sigma2_e"
  )
  nms <- names(result$table)
  expect_true("sigma2_a" %in% nms)
  expect_true("sigma2_e" %in% nms)
})

test_that("tbl_heritability model column included when specified", {
  result <- tbl_heritability(clerk_h2_example, model = "covariates")
  expect_true("covariates" %in% names(result$table))
})

test_that("tbl_heritability FDR adds p_fdr column", {
  result <- tbl_heritability(clerk_h2_example, fdr = TRUE)
  expect_true("p_fdr" %in% names(result$table))
})

test_that("tbl_heritability stores domain_other", {
  result <- tbl_heritability(clerk_h2_example, domain_other = "Traits")
  expect_equal(result$domain_other, "Traits")
})
