# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: try.R
# Desc: illustrates the use of 'try' to catch errors
# Arguments: none
# Date: Oct 2021

## write a function:

doit <- function(x){
    temp_x <- sample(x, replace = TRUE)
    if(length(unique(temp_x)) > 30) {#only take mean if sample was sufficient
         print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        } 
    else {
        stop("Couldn't calculate mean: too few unique values!")
        }
    }


## generate a population:

set.seed(1345) # again, to get the same result for illustration

popn <- rnorm(50)

hist(popn)

## run lapply

lapply(1:15, function(i) doit(popn))


## do the same using try:

result <- lapply(1:15, function(i) try(doit(popn), FALSE))
#--> stores the errors in the object result

# can also store the results manually by using a loop to do the same:

result <- vector("list", 15) #Preallocate/Initialize
for(i in 1:15) {
    result[[i]] <- try(doit(popn), FALSE)
    }

