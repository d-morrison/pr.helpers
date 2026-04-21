test_that("math_demo handles two distinct real roots", {
  # x^2 - 5x + 6 = 0 has roots x = 2 and x = 3
  result <- math_demo(1, -5, 6)
  expect_length(result, 2)
  expect_type(result, "double")
  expect_equal(sort(result), c(2, 3))
})

test_that("math_demo handles one repeated real root", {
  # x^2 - 4x + 4 = 0 has root x = 2 (repeated)
  result <- math_demo(1, -4, 4)
  expect_length(result, 1)
  expect_type(result, "double")
  expect_equal(result, 2)
})

test_that("math_demo handles complex roots", {
  # x^2 + 2x + 5 = 0 has complex roots x = -1 ± 2i
  result <- math_demo(1, 2, 5)
  expect_length(result, 2)
  expect_type(result, "complex")
  expect_equal(Re(result[1]), -1)
  expect_equal(Re(result[2]), -1)
  expect_equal(abs(Im(result[1])), 2)
  expect_equal(abs(Im(result[2])), 2)
})

test_that("math_demo throws error when a = 0", {
  expect_error(
    math_demo(0, 5, 3),
    "Coefficient 'a' must be non-zero for a quadratic equation"
  )
})

test_that("math_demo works with different coefficients", {
  # 2x^2 - 8x + 6 = 0 has roots x = 1 and x = 3
  result <- math_demo(2, -8, 6)
  expect_length(result, 2)
  expect_equal(sort(result), c(1, 3))
})
