# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: next.R
# Desc: script to illustrate how use next in loops
# Arguments: none
# Date: Oct 2021

## using next

# --> to skip to next iteration of a loop

# --> both 'next' and 'break' can be used within other loops

for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop 
  print(i)
}