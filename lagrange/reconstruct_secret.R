reconstruct_secret <- function(shares) {
  # Extract x and y values from the shares
  x_points <- sapply(shares, function(share) share$x)
  y_points <- sapply(shares, function(share) share$y)
  
  # Initialize secret to 0
  secret <- 0
  
  # Loop through all shares and reconstruct the secret
  for (i in seq_along(shares)) {
    # Get the Lagrange coefficient for the i-th share at x = 0
    coeff <- lagrange_coefficient(0, x_points, i)
    
    # Add the contribution of this share to the secret
    secret <- secret + (y_points[i] * coeff)
  }
  
  return(secret)
}
