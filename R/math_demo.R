#' Demonstrate LaTeX Math Formatting in Roxygen
#'
#' This function demonstrates how to include formatted mathematical expressions
#' in roxygen2 documentation using LaTeX syntax.
#'
#' @description
#' The quadratic formula is given by:
#' \deqn{x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}}{
#'   x = (-b ± sqrt(b^2 - 4ac)) / (2a)}
#'
#' For inline math, the variance is denoted \eqn{\sigma^2}{sigma^2},
#' and the standard deviation is \eqn{\sigma}{sigma}.
#'
#' @details
#' This function computes the roots of a quadratic equation of the form:
#' \deqn{ax^2 + bx + c = 0}{ax^2 + bx + c = 0}
#'
#' The discriminant is \eqn{\Delta = b^2 - 4ac}{Delta = b^2 - 4ac}.
#' When \eqn{\Delta > 0}{Delta > 0}, there are two real roots.
#' When \eqn{\Delta = 0}{Delta = 0}, there is one repeated real root.
#' When \eqn{\Delta < 0}{Delta < 0}, there are two complex conjugate roots.
#'
#' Additional mathematical notation examples:
#' \itemize{
#'   \item Sum notation: \eqn{\sum_{i=1}^{n} x_i}{sum(x_i, i=1..n)}
#'   \item Integral: \eqn{\int_{0}^{\infty} e^{-x} dx = 1}{
#'     integral from 0 to infinity of e^(-x) dx = 1}
#'   \item Matrix multiplication:
#'     \eqn{\mathbf{Y} = \mathbf{X}\boldsymbol{\beta} +
#'     \boldsymbol{\epsilon}}{Y = X*beta + epsilon}
#'   \item Greek letters: \eqn{\alpha, \beta, \gamma, \delta}{
#'     alpha, beta, gamma, delta}
#' }
#'
#' @param a Numeric coefficient of \eqn{x^2}{x^2}
#' @param b Numeric coefficient of \eqn{x}{x}
#' @param c Numeric constant term
#'
#' @return A numeric vector of length 1 or 2 containing the root(s) of
#'   the equation. Complex roots are returned as complex numbers.
#'
#' @export
#'
#' @examples
#' # Two real roots: x^2 - 5x + 6 = 0
#' # Solution: x = 2 or x = 3
#' math_demo(1, -5, 6)
#'
#' # One repeated root: x^2 - 4x + 4 = 0
#' # Solution: x = 2
#' math_demo(1, -4, 4)
#'
#' # Complex roots: x^2 + 2x + 5 = 0
#' # Solution: x = -1 ± 2i
#' math_demo(1, 2, 5)
math_demo <- function(a, b, c) {
  # Check for valid input
  if (isTRUE(all.equal(a, 0))) {
    stop("Coefficient 'a' must be non-zero for a quadratic equation")
  }
  
  # Calculate discriminant
  discriminant <- b^2 - 4 * a * c
  
  # Calculate roots based on discriminant
  if (discriminant > 0) {
    # Two distinct real roots
    root1 <- (-b + sqrt(discriminant)) / (2 * a)
    root2 <- (-b - sqrt(discriminant)) / (2 * a)
    return(c(root1, root2))
  } else if (discriminant == 0) {
    # One repeated real root
    root <- -b / (2 * a)
    return(root)
  } else {
    # Two complex conjugate roots
    real_part <- -b / (2 * a)
    imaginary_part <- sqrt(-discriminant) / (2 * a)
    root1 <- complex(real = real_part, imaginary = imaginary_part)
    root2 <- complex(real = real_part, imaginary = -imaginary_part)
    return(c(root1, root2))
  }
}
