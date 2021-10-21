# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: apply1.R
# Desc: examples of use of 'apply' to vectorise
# Arguments: none
# Date: Oct 2021

##--> don't use set.seed every time --> makes it always the same output
##--> sometimes useful if you need to debug about whether it's your random number which is causing issues

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans <- apply(M, 1, mean)
print (RowMeans)

## Now the variance
RowVars <- apply(M, 1, var)
print (RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print (ColMeans)
