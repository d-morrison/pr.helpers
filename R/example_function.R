#' Example Function with Mathematical Notation
#'
#' This is an example function that demonstrates basic functionality and
#' various ways to include mathematical notation in roxygen2 documentation.
#'
#' # Mathematical Notation in roxygen2
#'
#' ## Using `\eqn{}` for inline math (works in all formats)
#'
#' The median is a measure of central tendency where \eqn{x_{0.5}} represents
#' the value that splits the data in half.
#'
#' ## Using `\deqn{}` for display equations (works in all formats)
#'
#' The sample median for odd \eqn{n} is defined as:
#' \deqn{m = x_{(n+1)/2}}
#'
#' ## Using `$$` for display math (HTML/pkgdown only, requires roxygen2 >= 7.0.0)
#'
#' For even sample sizes, the median is the average of the two middle values:
#' $$m = \frac{x_{(n/2)} + x_{(n/2+1)}}{2}$$
#'
#' ## Using `$` for inline math (HTML/pkgdown only, requires roxygen2 >= 7.0.0)
#'
#' In general, the median minimizes $\sum_{i=1}^{n} |x_i - m|$.
#'
#' @param x A numeric vector
#'
#' @return The median of the input vector
#' @export
#'
#' @examples
#' example_function(c(1, 2, 3, 4, 5))
example_function <- function(x) {
  stats::median(x)
}
