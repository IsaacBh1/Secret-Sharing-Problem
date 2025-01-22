library(gmp)

# Multiply two polynomials
multiply_polynomials <- function(p1, p2) {
  result <- rep(0, length(p1) + length(p2) - 1)
  for (i in seq_along(p1)) {
    for (j in seq_along(p2)) {
      result[i + j - 1] <- result[i + j - 1] + p1[i] * p2[j]
    }
  }
  return(result)
}

# Parse a formatted polynomial string
parse_polynomial <- function(formatted_polynomial) {
  terms <- unlist(strsplit(formatted_polynomial, "\\+"))
  coefficients <- numeric(length(terms))
  powers <- numeric(length(terms))
  
  for (i in seq_along(terms)) {
    term <- gsub(" ", "", terms[i])
    if (grepl("x\\^", term)) {
      coef_and_power <- strsplit(term, "x\\^")[[1]]
      coefficients[i] <- as.numeric(coef_and_power[1])
      powers[i] <- as.numeric(coef_and_power[2])
    } else if (grepl("x", term)) {
      coefficients[i] <- 1
      powers[i] <- 1
    } else {
      coefficients[i] <- as.numeric(term)
      powers[i] <- 0
    }
  }
  
  return(list(coefficients = coefficients, powers = powers))
}

# Format a polynomial for display
format_polynomial <- function(coefficients) {
  terms <- sapply(0:(length(coefficients) - 1), function(i) {
    coeff <- coefficients[i + 1]
    if (coeff == 0) return(NULL)
    term <- paste0(ifelse(coeff > 0 && i > 0, " + ", ""), coeff)
    if (i > 0) term <- paste0(term, "x^", i)
    return(term)
  })
  return(paste(terms[!sapply(terms, is.null)], collapse = ""))
}

# Function to extract coefficients from final polynomial terms
extract_coefficients_from_polynomial <- function(final_polynomial_terms) {
  if (!is.numeric(final_polynomial_terms)) {
    stop("The input must be a numeric vector representing the polynomial terms.")
  }
  
  coefficients <- final_polynomial_terms
  powers <- seq_along(final_polynomial_terms) - 1 # Powers are indices minus 1
  
  return(list(coefficients = coefficients, powers = powers))
}

# Evaluate the polynomial at a given x
evaluate_polynomial <- function(coefficients, x_value) {
  result <- sum(coefficients * (x_value^(0:(length(coefficients) - 1))))
  return(result)
}

# Display evaluations of the polynomial for f(0) and f(k) where k is the x-coordinates of the shares
evaluate_and_display_table <- function(coefficients, shares) {
  # Evaluate f(0)
  f_at_0 <- evaluate_polynomial(coefficients, 0)
  
  # Evaluate f(k) for each share point k
  share_x_values <- sapply(shares, function(share) share$x)
  evaluations <- sapply(share_x_values, function(x) evaluate_polynomial(coefficients, x))
  
  # Create a data frame to store the results
  evaluation_table <- data.frame(
    x = c(0, share_x_values),
    f_x = c(f_at_0, evaluations)
  )
  
  # Print the table with good formatting
  cat("Polynomial Evaluation Table:\n")
  cat("-------------------------------\n")
  cat(sprintf("%-10s %-10s\n", "x", "f(x)"))
  cat("-------------------------------\n")
  
  for (i in 1:nrow(evaluation_table)) {
    cat(sprintf("%-10s %-10.2f\n", evaluation_table$x[i], evaluation_table$f_x[i]))
  }
  
  cat("-------------------------------\n")
}

