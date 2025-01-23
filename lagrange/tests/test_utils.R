# lagrange/tests/test_utils.R

source("lagrange/lagrange_utils.R")

test_multiply_polynomials <- function() {
  p1 <- c(1, 2, 3)
  p2 <- c(4, 5)
  expected_result <- c(4, 13, 22, 15)
  result <- multiply_polynomials(p1, p2)
  
  if (identical(result, expected_result)) {
    cat("multiply_polynomials test passed!\n")
  } else {
    cat("multiply_polynomials test failed. Expected:", expected_result, "but got:", result, "\n")
  }
}

test_parse_polynomial <- function() {
  formatted_polynomial <- "3 + 2x + 1x^2"
  expected_output <- list(coefficients = c(3, 2, 1), powers = c(0, 1, 2))
  result <- parse_polynomial(formatted_polynomial)
  
  if (identical(result, expected_output)) {
    cat("parse_polynomial test passed!\n")
  } else {
    cat("parse_polynomial test failed. Expected:\n")
    print(expected_output)
    cat("but got:\n")
    print(result)
  }
}



test_format_polynomial <- function() {
  coefficients <- c(3, 2, 1)
  expected_result <- "3 + 2x + x^2"
  result <- format_polynomial(coefficients)
  
  if (identical(result, expected_result)) {
    cat("format_polynomial test passed!\n")
  } else {
    cat("format_polynomial test failed. Expected:", expected_result, "but got:", result, "\n")
  }
}

test_extract_coefficients_from_polynomial <- function() {
  final_polynomial_terms <- c(3, 2, 1)
  expected_result <- list(coefficients = c(3, 2, 1), powers = c(0, 1, 2))
  result <- extract_coefficients_from_polynomial(final_polynomial_terms)
  
  if (identical(result, expected_result)) {
    cat("extract_coefficients_from_polynomial test passed!\n")
  } else {
    cat("extract_coefficients_from_polynomial test failed. Expected:", expected_result, "but got:", result, "\n")
  }
}

test_evaluate_polynomial <- function() {
  coefficients <- c(3, 2, 1)
  x_value <- 2
  expected_result <- 11
  result <- evaluate_polynomial(coefficients, x_value)
  
  if (identical(result, expected_result)) {
    cat("evaluate_polynomial test passed!\n")
  } else {
    cat("evaluate_polynomial test failed. Expected:", expected_result, "but got:", result, "\n")
  }
}

test_evaluate_and_display_table <- function() {
  coefficients <- c(3, 2, 1)
  shares <- list(list(x = 0, y = 3), list(x = 1, y = 6), list(x = 2, y = 11))
  expected_output <- "
Polynomial Evaluation Table:
-------------------------------
x         f(x)      
-------------------------------
0         3.00      
1         6.00      
2         11.00     
-------------------------------
"
  capture.output({
    evaluate_and_display_table(coefficients, shares)
  }) -> output
  
  if (grepl(expected_output, output)) {
    cat("evaluate_and_display_table test passed!\n")
  } else {
    cat("evaluate_and_display_table test failed. Expected output:\n", expected_output, "but got:\n", output, "\n")
  }
}

test_multiply_polynomials()
test_parse_polynomial()
test_format_polynomial()