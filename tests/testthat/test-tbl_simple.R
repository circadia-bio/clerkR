test_that("tbl_simple returns a clerk_tbl", {
  result <- tbl_simple(clerk_example)
  expect_s3_class(result, "clerk_tbl")
  expect_equal(result$type, "simple")
  expect_null(result$group)
})

test_that("tbl_simple table has expected columns", {
  result <- tbl_simple(clerk_example)
  nms <- names(result$table)
  expect_true("variable" %in% nms)
  expect_true("n"        %in% nms)
  expect_true("summary"  %in% nms)
})

test_that("tbl_simple respects vars selection", {
  result <- tbl_simple(clerk_example, vars = c(hdl, bmi))
  expect_equal(result$table$variable, c("hdl", "bmi"))
})

test_that("tbl_simple stores domain_other", {
  result <- tbl_simple(clerk_example, domain_other = "Other")
  expect_equal(result$domain_other, "Other")
})
