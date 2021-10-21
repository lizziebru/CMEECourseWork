# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: preallocate.R
# Desc: examples of using pre-allocation
# Arguments: none
# Date: Oct 2021

#--> tip from Samraat: always pre-allocate!!

NoPreallocFun <- function(x){
    a <- vector() # empty vector
    for (i in 1:x) {
        a <- c(a, i)
        print(a)
        print(object.size(a))
    }
}

system.time(NoPreallocFun(10))

PreallocFun <- function(x){
    a <- rep(NA, x) # pre-allocated vector
    for (i in 1:x) {
        a[i] <- i
        print(a)
        print(object.size(a))
    }
}

system.time(PreallocFun(10))