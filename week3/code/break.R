# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: break.R
# Desc: script to illustrate how to break out of loops
# Arguments: none
# Date: Oct 2021

## breaking out of loops

# --> sometimes it's useful to break out of a loop when some condition is met
# --> can use break for this when you can't set a target number of iterations and you just want it to stop after certain condition is met

i <- 0 #Initialize i
    while(i < Inf) {
        if (i == 10) {
            break 
             } # Break out of the while loop! 
        else { 
            cat("i equals " , i , " \n")
            i <- i + 1 # Update i
    }
}