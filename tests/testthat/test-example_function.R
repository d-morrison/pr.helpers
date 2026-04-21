test_that("example_function works", {
  expect_equal(example_function(c(1, 2, 3)), 2)
  expect_equal(example_function(c(1, 2, 3, 4, 5)), 3)
  expect_equal(example_function(c(1, NA, 3, 4, 5)), 3.5)
  expect_equal(example_function(c(1.111, 2.222, 3.333)), 2.22)
})

test_that("example_function handles errors", {
  expect_error(example_function(character()), "Input must be numeric")
  expect_error(
    example_function(numeric()),
    "Input must have at least one element"
  )
  expect_error(
    example_function(c(NA_real_, NA_real_, NA_real_)),
    "Input cannot be all NA values"
  )
})
