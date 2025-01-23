{
  s <- as.integer(readline("Entrez le secret s: "))
  n <- as.integer(readline("Entrez le nombre de parties n: "))
  t <- as.integer(readline("Entrez le seuil t: "))
  
  if (n < t) {
    print("Erreur : Le nombre de parties doit être supérieur ou égal au seuil.")
    stop()
  }
  
  set.seed(123)
  coefficients <- c(s, sample(1:100, t-1, replace = TRUE))
  
  polynomial <- paste("p(x) =", coefficients[1])
  for (i in 2:length(coefficients)) {
    polynomial <- paste(polynomial, "+", coefficients[i], "* x^", i-1)
  }
  print(paste("Polynôme :", polynomial))
  
  evaluate_poly <- function(x, coeffs) {
    y <- 0
    for (i in 1:length(coeffs)) {
      y <- y + coeffs[i] * x^(length(coeffs) - i)
    }
    return(y)
  }
  
  x_values <- seq(1, n, length.out = n)
  
  y_values <- sapply(x_values, evaluate_poly, coeffs = coefficients)
  shares <- data.frame(Person = 1:n, x = x_values, y = y_values)
  
  print("Parts secrètes pour chaque personne :")
  for (i in 1:n) {
    print(paste("Personne", shares$Person[i], "-> (x =", shares$x[i], ", y =", shares$y[i], ")"))
  }
  
  x_plot <- seq(1, n, length.out = 1000)
  y_plot <- sapply(x_plot, evaluate_poly, coeffs = coefficients)
  plot(x_plot, y_plot, type = "l", col = "blue", 
       xlab = "x", ylab = "p(x)", 
       main = "Polynôme de partage de secret de Shamir et parts")
  points(shares$x, shares$y, pch = 19, col = "red")
  legend("topright", legend = c("Polynôme", "Parts"), 
         col = c("blue", "red"), lty = c(1, NA), pch = c(NA, 19))
}