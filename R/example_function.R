#' Example Function
#'
#' This is an example function that demonstrates basic functionality.
#' It validates, cleans, calculates statistics, and formats the result.
#'
#' @param x A numeric vector
#'
#' @return The median of the input vector, rounded to 2 decimal places
#' @export
#'
#' @examples
#' example_function(c(1, 2, 3, 4, 5))
#' example_function(c(1, NA, 3, 4, 5))
example_function <- function(x) {
  result <- calculate_statistic(x)
  format_result(result)
}
