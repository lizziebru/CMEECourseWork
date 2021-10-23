# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: DataWrang.R
# Desc: script to illustrate how to wrangle data in R
# Date: Oct 2021

################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))

# make sure there's a copy of the raw file saved (it is in PoundHillData.csv) - just make sure not to overwrite this csv and it'll be sufficient to keep the raw data there


# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")
## useful to keep the original data spreadsheet well documented using a 'metadata' file that describes the data
## --> minimum info in it: description of each field - also good to have the measurement units


############# Inspect the dataset ###############
head(MyData)
dim(MyData) # gives you dimension of the object
str(MyData) # displays the structure of the object
fix(MyData) # invokes edit (which invokes a text editor) on the object and assigns the new version of the object into the workspace
fix(MyMetaData)

############# Transpose ############### (first step of getting data into long format)
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
# blanks = true absences (the spp wasn't present in that quadrat):
MyData[MyData == ""] <- 0

############# Convert raw matrix to data frame ###############

# create a temporary data frame with just the data, without the column names
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important! (prevents R from converting all the strings to factors)
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
require(stats) # need this before can install reshape2
install.packages("reshape2") # needed to manually install and library reshape2 to be able to install it
library(reshape2) 

?melt # this converts an object into a molten data frame (converts wide-formatted data into a single column of data (stacks it all))

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

require(tidyverse) # useful for data exploration

# convert the dataframe to a 'tibble' (= equivalent o R's traditional data.frame (i.e. tibble = a modified data frame))
tibble::as_tibble(MyWrangledData)

dplyr::glimpse(MyWrangledData) #like str(), but nicer! - to view the structure of the data
# can also use this:
utils::View(MyWrangledData)

# can subset the data:
dplyr::filter(MyWrangledData, Count>100) #like subset(), but nicer!


# can look at certain sets of data rows:
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows

