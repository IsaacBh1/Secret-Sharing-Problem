check_equal <- function(actual, expected, test_name) {
  if (actual == expected) {
    cat(test_name, ": Passed\n")
  } else {
    cat(test_name, ": Failed (Expected", expected, ", but got", actual, ")\n")
  }
}

check_true <- function(condition, test_name) {
  if (condition) {
    cat(test_name, ": Passed\n")
  } else {
    cat(test_name, ": Failed\n")
  }
}

secret <- 123
threshold <- 3
n <- 5
prime <- 257

shares <- generate_shares(secret, threshold, n, prime)
check_equal(length(shares), n, "Test: Number of shares")

for (i in 1:n) {
  check_true(shares[[i]]$x > 0 && shares[[i]]$x <= n, paste("Test: Share", i, "x value"))
}

for (i in 1:n) {
  check_true(shares[[i]]$y >= 0 && shares[[i]]$y < prime, paste("Test: Share", i, "y value"))
}
