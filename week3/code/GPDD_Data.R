# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: GPDD_Data.R
# Desc: Mapping in R using the maps package
# Date: Nov 2021

# load data
load("../data/GPDDFiltered.RData")

# install maps package
install.packages("maps")
library(maps)

# create world map
map()

# superimpose all the locations from which we have data in the GPDD dataframe
points(gpdd, add = TRUE, col = "blue")

# what biases might you expect in any analysis based on the data represented?
#--> Most of the data is clustered around Europe and the Middle East, so any analysis will be biased towards these regions. 