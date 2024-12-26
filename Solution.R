# Function to compute divided differences
divided_differences <- function(x, y) {
  n <- length(x)
  dd <- matrix(0, n, n)
  dd[, 1] <- y
  for (j in 2:n) {
    for (i in j:n) {
      dd[i, j] <- (dd[i, j-1] - dd[i-1, j-1]) / (x[i] - x[i-j+1])
    }
  }
  return(dd)
}

# Function to reconstruct the secret
reconstruct_secret <- function(x, y, t) {
  dd <- divided_differences(x, y)
  secret <- dd[1, 1]
  for (k in 2:t) {
    term <- dd[k, k]
    for (i in 1:(k-1)) {
      term <- term * (-x[i])
    }
    secret <- secret + term
  }
  return(secret)
}

# Main program
{
  # Input parameters
  s <- as.integer(readline("Enter secret s: "))
  n <- as.integer(readline("Enter number of parties n: "))
  t <- as.integer(readline("Enter threshold t: "))
  
  # Generate polynomial coefficients
  set.seed(123)
  coefficients <- c(s, sample(1:100, t-1, replace = TRUE))
  
  # Display the polynomial
  polynomial <- paste("p(x) =", coefficients[1])
  for (i in 2:length(coefficients)) {
    polynomial <- paste(polynomial, "+", coefficients[i], "* x^", i-1)
  }
  print(paste("Polynomial:", polynomial))
  
  # Evaluate polynomial
  evaluate_poly <- function(x, coeffs) {
    y <- 0
    for (i in 1:length(coeffs)) {
      y <- y + coeffs[i] * x^(length(coeffs) - i)
    }
    return(y)
  }
  
  # Generate shares automatically
  x_values <- sample(1:100, n, replace = FALSE)
  y_values <- sapply(x_values, evaluate_poly, coeffs = coefficients)
  shares <- data.frame(Person = 1:n, x = x_values, y = y_values)
  
  # Assign shares to each person and display in the terminal
  print("Secret shares for each person:")
  for (i in 1:n) {
    print(paste("Person", shares$Person[i], "-> (x =", shares$x[i], ", y =", shares$y[i], ")"))
  }
  
  # Reconstruct secret using t shares
  selected_shares <- shares[1:t, ]
  secret_reconstructed <- reconstruct_secret(selected_shares$x, selected_shares$y, t)
  
  # Output results
  print(paste("Reconstructed Secret:", secret_reconstructed))
  # Plotting
  x_plot <- seq(0, 100, length.out = 1000)
  y_plot <- sapply(x_plot, evaluate_poly, coeffs = coefficients)
  plot(x_plot, y_plot, type = "l", col = "blue", 
       xlab = "x", ylab = "p(x)", 
       main = "Shamir's Secret Sharing Polynomial and Shares")
  points(shares$x, shares$y, pch = 19, col = "red")
  legend("topright", legend = c("Polynomial", "Shares"), 
         col = c("blue", "red"), lty = c(1, NA), pch = c(NA, 19))
}

# [1] "Person 1 -> (x = 51 , y = 733494064 )"
# [1] "Person 2 -> (x = 14 , y = 55273297 )"
# [1] "Person 2 -> (x = 14 , y = 55273297 )"
# [1] "Person 3 -> (x = 67 , y = 1265918112 )"
# [1] "Person 3 -> (x = 67 , y = 1265918112 )"
# [1] "Person 4 -> (x = 42 , y = 497456437 )"
# 