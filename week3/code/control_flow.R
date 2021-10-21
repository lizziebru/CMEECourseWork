# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: control_flow.R
# Desc: script to illustrate the use of control flows in R
# Arguments: none
# Date: Oct 2021

## basic 'if' statement:
a <- TRUE
if (a == TRUE){
    print ("a is TRUE")
    } else {
    print ("a is FALSE")
}

# can also write an 'if' statement on a single line:
z <- runif(1) # Generate a uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}
# --> BUT: makes code more readable to write across multiple lines rather than squeezing things into just one

# NB: also indent code for readability (even if it's not necessary unlike Python)


## 'for' loops

for (i in 1:10){ # you could also use seq(10)
    j <- i * i # j = temporary variable
    print(paste(i, " squared is", j ))
} # --> loops over numbers 1-10, squares each, then prints the result

# looping over a vector of strings:
for(species in c('Heliodoxa rubinoides', 
                 'Boissonneaua jardini', 
                 'Sula nebouxii')){
  print(paste('The species is', species))
}

# looping using a pre-existing vector:
v1 <- c("a","bc","def")
for (i in v1){
    print(i)
}


## 'while' loops

# --> performs an operation til some condition is met

i <- 0
while (i < 10){
    i <- i+1
    print(i^2)
}