test_that("calculate_summary works", {
  result <- calculate_summary(c(1, 2, 3, 4, 5))
  expect_type(result, "list")
  expect_named(result, c("mean", "median", "sd"))
  expect_equal(result$mean, 3)
  expect_equal(result$median, 3)
  expect_equal(result$sd, 1.58)
})

test_that("calculate_summary handles NA values", {
  result <- calculate_summary(c(1, NA, 3, 4, 5))
  expect_type(result, "list")
  expect_equal(result$median, 3.5)
  expect_equal(result$mean, 3.25)
})

test_that("calculate_summary handles errors", {
  expect_error(calculate_summary(character()), "Input must be numeric")
  expect_error(
    calculate_summary(numeric()),
    "Input must have at least one element"
  )
  expect_error(
    calculate_summary(c(NA_real_, NA_real_, NA_real_)),
    "Input cannot be all NA values"
  )
})
