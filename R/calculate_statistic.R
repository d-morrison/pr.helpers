#' Calculate Statistic
#'
#' Internal helper function to calculate a statistical measure on cleaned data.
#'
#' @param x A numeric vector
#'
#' @return The median value
#' @keywords internal
#' @noRd
calculate_statistic <- function(x) {
  x_clean <- clean_data(x)
  stats::median(x_clean)
}
