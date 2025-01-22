# Function to apply color formatting using ANSI codes
apply_color <- function(message, color_code) {
  paste0("\033[", color_code, "m", message, "\033[0m")
}

# Fancy Print Function with Colors
fancy_print <- function(message, decoration = "*", width = 60, color_code = "33") {
  colored_message <- apply_color(message, color_code)
  cat(rep(decoration, width), "\n")
  cat(paste0(decoration, " ", colored_message, " ", decoration), "\n")
  cat(rep(decoration, width), "\n\n")
}

# Generate a lagrange polynomial
lagrange_polynomial <- function(x, x_points, exclude_index) {
  polynomial <- c(1)
  for (i in seq_along(x_points)) {
    if (i != exclude_index) {
      term <- c(-x_points[i], 1)
      polynomial <- multiply_polynomials(polynomial, term)
    }
  }
  denominator <- 1
  for (i in seq_along(x_points)) {
    if (i != exclude_index) {
      denominator <- denominator * (x_points[exclude_index] - x_points[i])
    }
  }
  polynomial <- polynomial / as.bigq(denominator, 1)
  return(polynomial)
}

# Run demo with example
run_demo_with_example <- function() {
  fancy_print("Initializing Secret Sharing Example", color_code = "36")  # Cyan
  
  secret <- 1234
  threshold <- 3
  n <- 5
  
  fancy_print("Generating Shares", "-", 40, color_code = "32")  # Green
  shares <- generate_shares(secret, threshold, n)
  
  fancy_print("Generated Shares", "+", 40, color_code = "32")  # Green
  for (i in 1:length(shares)) {
    cat(paste0("  Share ", i, ": x = ", shares[[i]]$x, ", y = ", shares[[i]]$y, "\n"))
  }

  x_values <- sapply(shares, function(share) share$x)
  y_values <- sapply(shares, function(share) share$y)
  
  fancy_print("Computing Lagrange Polynomials for each Share Point", "~", 40, color_code = "34")  # Blue
  lagrange_polynomials <- list()
  
  for (i in 1:length(x_values)) {
    polynomial_terms <- lagrange_polynomial(x_values[i], x_values, i)
    lagrange_polynomials[[i]] <- polynomial_terms
    formatted_polynomial <- format_polynomial(polynomial_terms)
    cat(paste0("  L_", i, "(x) = "), formatted_polynomial, "\n\n")
  }

  fancy_print("Calculating the Final Polynomial", "#", 40, color_code = "35")  # Magenta
  final_polynomial_terms <- rep(0, length(lagrange_polynomials[[1]]))
  
  for (i in 1:length(x_values)) {
    final_polynomial_terms <- final_polynomial_terms + lagrange_polynomials[[i]] * y_values[i]
  }
  
  formatted_final_polynomial <- format_polynomial(final_polynomial_terms)
  cat("\n  Final Polynomial: ", formatted_final_polynomial, "\n\n")
  
  # Ensure final_polynomial_terms is a numeric vector
  final_polynomial_terms_numeric <- as.numeric(final_polynomial_terms)
  
  # Extracting coefficients from final polynomial terms
  coefficients <- extract_coefficients_from_polynomial(final_polynomial_terms_numeric)
  # Call the existing function to evaluate and display the table
  fancy_print("Evaluating Polynomial at x = 0 and other x values", "+", 40, color_code = "33")  # Yellow
  evaluate_and_display_table(final_polynomial_terms_numeric, shares)

  fancy_print("Visualizing the Polynomial and Shares", "=", 40, color_code = "33")  # Yellow
  # Plotting
  plot_polynomial(coefficients$coefficients, shares)
}

run_demo_with_example()
