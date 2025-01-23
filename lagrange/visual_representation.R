plot_polynomial <- function(coefficients, shares) {
  x_values <- seq(min(sapply(shares, function(share) share$x)) - 1, 
                  max(sapply(shares, function(share) share$x)) + 1, 
                  length.out = 100)
  
  y_values <- sapply(x_values, function(x) evaluate_polynomial(coefficients, x))
  
  share_x_values <- sapply(shares, function(share) share$x)
  share_y_values <- sapply(shares, function(share) share$y)
  
  data <- data.frame(x = x_values, y = y_values)
  share_data <- data.frame(x = share_x_values, y = share_y_values)
  
  plot <- ggplot(data, aes(x = x, y = y)) +
    geom_line(color = "#007BFF", size = 1.5, linetype = "solid") +
    geom_point(data = share_data, aes(x = x, y = y), color = "#FF5733", size = 4, shape = 21, fill = "#FF5733") +
    labs(title = "Polynomial Curve with Share Points",
         subtitle = "Polynomial curve with marked share points",
         x = "x", y = "f(x)",
         caption = paste("Reconstructed Secret: ", extract_secret_from_polynomial(coefficients))) +
    theme_minimal(base_family = "Arial") +
    theme(
      plot.background = element_rect(fill = "white", color = NA),
      panel.grid = element_line(color = "gray40", size = 0.2),  # Thicker gray grid
      panel.background = element_rect(fill = "white"),
      axis.title.x = element_text(face = "bold", size = 14, color = "black"),
      axis.title.y = element_text(face = "bold", size = 14, color = "black"),
      axis.text.x = element_text(size = 12, color = "black"),
      axis.text.y = element_text(size = 12, color = "black"),
      plot.title = element_text(hjust = 0.5, size = 18, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(hjust = 0.5, size = 14, color = "#7F8C8D"),
      plot.caption = element_text(hjust = 1, size = 12, color = "#95A5A6")
    ) +
    scale_x_continuous(breaks = seq(min(x_values), max(x_values), by = 1)) +
    scale_y_continuous(labels = scales::number_format(accuracy = 0.1)) +
    coord_cartesian(expand = FALSE) +  # Removes space between plot and axes
    theme(
      aspect.ratio = 1  # Ensures the grid cells are square-shaped
    ) +
    annotate("text", x = mean(x_values), y = max(y_values), label = "Polynomial Curve", size = 6, color = "#2C3E50", hjust = 0.5, vjust = -2, fontface = "italic") +
    annotate("text", x = mean(x_values), y = max(y_values) * 0.9, label = "Curve represents the reconstructed secret", size = 5, color = "#7F8C8D", hjust = 0.5)
  
  for (i in 1:length(share_x_values)) {
    plot <- plot + annotate("text", x = share_x_values[i] + 0.6, y = share_y_values[i] + 2, 
                            label = paste("Share", i), size = 3, color = "#FF5733", 
                            hjust = 0.5, fontface = "plain")
  }

  # Save the plot with higher resolution (dpi increased)
  ggsave("lagrange/polynomial_plot.png", plot = plot, dpi = 600, width = 8, height = 6)
  
  # Print the plot
  print(plot)
}
