#' Validate Input Data
#'
#' Internal helper function to validate input data for statistical calculations.
#'
#' @param x A numeric vector
#'
#' @return TRUE if valid, throws error otherwise
#' @keywords internal
#' @noRd
validate_input <- function(x) {
  if (!is.numeric(x)) {
    cli::cli_abort("Input must be numeric", call = NULL)
  }
  if (length(x) == 0) {
    cli::cli_abort("Input must have at least one element", call = NULL)
  }
  if (all(is.na(x))) {
    cli::cli_abort("Input cannot be all NA values", call = NULL)
  }
  TRUE
}
