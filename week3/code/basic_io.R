# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: basic_io.R
# Desc: A simple script to illustrate R input-output. 
# Arguments: none
# Date: Oct 2021


# Run line by line and check inputs outputs to understand what is happening  

MyData <- read.csv("../data/trees.csv", header = TRUE) # import with headers

write.csv(MyData, "../results/MyData.csv") #write it out as a new file

write.table(MyData[1,], file = "../results/MyData.csv",append=TRUE) # Append to it

write.csv(MyData, "../results/MyData.csv", row.names=TRUE) # write row names

write.table(MyData, "../results/MyData.csv", col.names=FALSE) # ignore column names

print("Script complete!") # can be useful to add a line like this at the end of the script so that you know when you've successfully run it