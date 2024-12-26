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
  # Input threshold
  t <- as.integer(readline("Enter threshold t: "))
  
  # Input shares (x, y) for the threshold
  shares <- data.frame(x = numeric(t), y = numeric(t))
  for (i in 1:t) {
    shares$x[i] <- as.integer(readline(paste("Enter x for share", i, ": ")))
    shares$y[i] <- as.integer(readline(paste("Enter y for share", i, ": ")))
  }
  
  # Reconstruct secret using t shares
  secret_reconstructed <- reconstruct_secret(shares$x, shares$y, t)
  
  # Output results
  print(paste("Reconstructed Secret:", secret_reconstructed))
  
  # Plotting (optional)
  plot_shares <- function(shares) {
    plot(shares$x, shares$y, pch = 19, col = "red", 
         xlab = "x", ylab = "y", 
         main = "Shares for Secret Reconstruction")
    legend("topright", legend = c("Shares"), 
           col = c("red"), pch = c(19))
  }
  
  # Call plotting function
  plot_shares(shares)
}