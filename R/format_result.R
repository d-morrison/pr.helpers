#' Format Result
#'
#' Internal helper function to format the result for output.
#'
#' @param result A numeric value
#'
#' @return A formatted numeric value (rounded to 2 decimal places)
#' @keywords internal
#' @noRd
format_result <- function(result) {
  round(result, digits = 2)
}
