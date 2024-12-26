# Function to compute modular inverse
mod_inv <- function(a, p) {
  a <- a %% p
  if (a == 0) return(0)
  return(a^(p-2) %% p)
}

# Function to compute divided differences
divided_differences <- function(x, y, p) {
  n <- length(x)
  dd <- matrix(0, n, n)
  dd[, 1] <- y
  for (j in 2:n) {
    for (i in j:n) {
      numerator <- (dd[i, j-1] - dd[i-1, j-1]) %% p
      denominator <- (x[i] - x[i-j+1]) %% p
      if (denominator == 0) {
        stop("Denominator is zero in divided difference calculation.")
      }
      inv <- mod_inv(denominator, p)
      dd[i, j] <- (numerator * inv) %% p
    }
  }
  return(dd)
}

# Function to reconstruct the secret
reconstruct_secret <- function(x, y, t, p) {
  dd <- divided_differences(x, y, p)
  secret <- dd[1, 1]
  for (k in 2:t) {
    term <- dd[k, k]
    for (i in 1:(k-1)) {
      term <- term * (-x[i]) %% p
    }
    secret <- (secret + term) %% p
  }
  return(secret)
}

# Main program
{
  # Input parameters
  p <- as.integer(readline("Enter prime number p: "))
  s <- as.integer(readline("Enter secret s: "))
  n <- as.integer(readline("Enter number of parties n: "))
  t <- as.integer(readline("Enter threshold t: "))
  
  # Generate polynomial coefficients
  set.seed(123)
  coefficients <- c(s, sample(0:(p-1), t-1, replace = TRUE))
  
  # Evaluate polynomial
  evaluate_poly <- function(x, coeffs, p) {
    y <- 0
    for (i in 1:length(coeffs)) {
      y <- (y + coeffs[i] * x^(length(coeffs) - i)) %% p
    }
    return(y)
  }
  
  # Generate shares
  x_values <- sample(1:(p-1), n, replace = FALSE)
  y_values <- sapply(x_values, evaluate_poly, coeffs = coefficients, p = p)
  shares <- data.frame(x = x_values, y = y_values)
  
  # Reconstruct secret
  input_shares <- matrix(0, nrow = t, ncol = 2)
  for (i in 1:t) {
    input_shares[i, 1] <- as.integer(readline(paste("Enter x", i, ": ")))
    input_shares[i, 2] <- as.integer(readline(paste("Enter y", i, ": ")))
  }
  secret_reconstructed <- reconstruct_secret(input_shares[,1], input_shares[,2], t, p)
  
  # Output results
  print(paste("Reconstructed Secret:", secret_reconstructed))
  
  # Plotting (optional)
  plot_shares <- function(p, coefficients, shares) {
    x_plot <- 0:(p-1)
    y_plot <- sapply(x_plot, evaluate_poly, coeffs = coefficients, p = p)
    plot(x_plot, y_plot, type = "p", pch = 19, col = "blue", 
         xlab = "x", ylab = "p(x)", 
         main = "Shamir's Secret Sharing with Newton's Divided Differences")
    points(shares$x, shares$y, pch = 19, col = "red")
    legend("topright", legend = c("Polynomial", "Shares"), 
           pch = c(1, 1), col = c("blue", "red"))
  }
  
  # Call plotting function
  plot_shares(p, coefficients, shares)
}