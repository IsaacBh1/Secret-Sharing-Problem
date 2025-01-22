generate_shares <- function(secret, threshold, n) {
  x_values <- sample(1:n, n)
  coefficients <- sample(1:100, threshold - 1, replace = TRUE)
  polynomial <- c(secret, coefficients)
  shares <- list()
  for (i in 1:n) {
    x <- x_values[i]
    y <- evaluate_polynomial(polynomial, x)
    shares[[i]] <- list(x = x, y = y)
  }
  return(shares)
}
