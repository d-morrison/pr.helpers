#' Calculate Summary Statistics
#'
#' Calculate multiple summary statistics for a numeric vector.
#'
#' @param x A numeric vector
#'
#' @return A named list with mean, median, and standard deviation
#' @export
#'
#' @examples
#' calculate_summary(c(1, 2, 3, 4, 5))
#' calculate_summary(c(1, NA, 3, 4, 5))
calculate_summary <- function(x) {
  x_clean <- clean_data(x)
  
  list(
    mean = format_result(mean(x_clean)),
    median = example_function(x),
    sd = format_result(stats::sd(x_clean))
  )
}
