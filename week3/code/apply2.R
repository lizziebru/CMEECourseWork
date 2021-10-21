# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: apply2.R
# Desc: examples of the use of 'apply' for vectorisation
# Arguments: none
# Date: Oct 2021

SomeOperation <- function(v){ # takes input v --> if sum of v>0, multiply that x100
  if (sum(v) > 0){ #note that sum(v) is a single (scalar) value
    return (v * 100)
  }
  return (v)
}

M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))

# --> lots of other methods: lapply, sapply, eapply etc --> each is best for a given data type