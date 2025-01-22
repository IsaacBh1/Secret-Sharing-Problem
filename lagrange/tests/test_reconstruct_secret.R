check_equal <- function(actual, expected, test_name) {
  if (actual == expected) {
    cat(test_name, ": Passed\n")
  } else {
    cat(test_name, ": Failed (Expected", expected, ", but got", actual, ")\n")
  }
}

secret <- 123
threshold <- 3
n <- 5
prime <- 257

shares <- generate_shares(secret, threshold, n, prime)
subset_shares <- shares[1:threshold]

reconstructed_secret <- reconstruct_secret(subset_shares, prime)
check_equal(reconstructed_secret, secret, "Test: Secret reconstruction")
