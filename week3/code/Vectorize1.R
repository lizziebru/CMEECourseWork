# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: Vectorize1.R
# Desc: this script illustrates vectorization in R
# Arguments: none
# Date: Oct 2021

M <- matrix(runif(1000000),1000,1000)

SumAllElements <- function(M){
  Dimensions <- dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]){
      Tot <- Tot + M[i,j]
    }
  }
  return (Tot)
}
 
print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))


# general advice on this:
# try to avoid loops 
# but in practice it's often easier to throw in a for loop then optimize the code to avoid the loop if the run time is too long