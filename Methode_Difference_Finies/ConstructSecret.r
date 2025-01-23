read_shares_and_threshold <- function() {
  cat("Enter the threshold (t): ")
  t <- as.integer(readline())
  
  cat("Enter the number of shares (n >= t): ")
  n <- as.integer(readline())
  if (n < t) {
    stop("Error: Number of shares must be >= threshold.")
  }
  
  shares <- data.frame(x = numeric(n), y = numeric(n))
  for (i in 1:n) {
    cat(paste("\nShare", i, "\n"))
    cat("Enter x value: ")
    x <- as.numeric(readline())
    cat("Enter y value: ")
    y <- as.numeric(readline())
    shares[i, ] <- c(x, y)
  }
  
  return(list(shares = shares, t = t))
}

validate_even_distribution <- function(shares) {
  shares <- shares[order(shares$x), ]
  x <- shares$x
  diffs <- diff(x)
  
  if (length(unique(diffs)) != 1) {
    stop("Error: Shares are not evenly distributed. x-values must be evenly spaced.")
  }
  return(shares)
}

retrieve_secret_and_coefficients <- function(shares, t) {
  if (nrow(shares) < t) {
    stop("Not enough shares.")
  }
  
  shares <- validate_even_distribution(shares)
  x_values <- shares$x[1:t]
  
  diff_table <- matrix(0, nrow = t, ncol = t)
  diff_table[, 1] <- shares$y[1:t]
  
  for (j in 2:t) {
    for (i in 1:(t - j + 1)) {
      diff_table[i, j] <- diff_table[i + 1, j - 1] - diff_table[i, j - 1]
    }
  }
  
  h <- diff(shares$x)[1]
  coefficients <- numeric(t)
  coefficients[1] <- diff_table[1, 1]
  
  for (j in 2:t) {
    coefficients[j] <- diff_table[1, j] / (factorial(j - 1) * h^(j - 1))
  }
  
  return(list(
    secret = coefficients[1],
    coefficients = coefficients,
    x0 = x_values[1],
    h = h
  ))
}

plot_polynomial <- function(shares, coefficients, x0, h) {
  x_min <- min(shares$x) - 1
  x_max <- max(shares$x) + 1
  x_plot <- seq(x_min, x_max, length.out = 1000)
  
  evaluate_poly <- function(x) {
    result <- coefficients[1]
    term <- 1
    for (j in 2:length(coefficients)) {
      term <- term * (x - (x0 + (j - 2) * h)) / (h * (j - 1))
      result <- result + coefficients[j] * term
    }
    return(result)
  }
  
  y_plot <- sapply(x_plot, evaluate_poly)
  
  plot(x_plot, y_plot, type = "l", col = "blue",
       xlab = "x", ylab = "y",
       main = "Reconstructed Polynomial and Shares")
  points(shares$x, shares$y, col = "red", pch = 19)
  legend("topleft", legend = c("Polynomial", "Shares"),
         col = c("blue", "red"), lty = c(1, NA), pch = c(NA, 19))
}

data <- read_shares_and_threshold()
shares <- data$shares
t <- data$t

result <- retrieve_secret_and_coefficients(shares, t)
secret <- result$secret
coefficients <- result$coefficients
x0 <- result$x0
h <- result$h

plot_polynomial(shares, coefficients, x0, h)

cat(paste("\nRetrieved secret:", secret, "\n"))