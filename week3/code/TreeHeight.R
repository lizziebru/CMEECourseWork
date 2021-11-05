# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: TreeHeight.R
# Desc: calculates tree heights
# Date: Oct 2021

# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

# load trees.csv
trees <- read.csv("../data/trees.csv")

# write function to calculate tree height
TreeHeight <- function(Angle.degrees, Distance.m){
    radians <- Angle.degrees * pi / 180
    height <- Distance.m * tan(radians)
    #print(paste("Tree height is:", height))
  
    return (height)
}

# work out tree heights for all the trees in the data:
Tree.Height.m <- TreeHeight(trees[,2], trees[,3])

# add the height into a column in the data frame
TreeHts.csv <- cbind(trees, Tree.Height.m)

# save as .csv in results directory
write.csv(TreeHts.csv, "../results/TreeHts.csv")
