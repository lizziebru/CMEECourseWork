# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: DataWrangTidy.R
# Desc: Script that uses tidyverse to do some data wrangling
# Date: Oct 2021

require(dplyr)
require(tidyr)

# need to go through the script and look for function in dplyr and tidyr  that does the same thing in each data wrangling step

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
# using tibble in tidyverse:
MyData2 = as_tibble(t(MyData))

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

# instead of melt: use pivot_longer from tidyr:
MyWrangledData1 <- TempData
MyWrangledData2 <- as.data.frame(MyWrangledData1 %>%
  tidyr::pivot_longer(cols = c(5:45),
                      names_to = c("Species"),
                      names_pattern = NULL))
colnames(MyWrangledData2)[6] <- "Count"

MyWrangledData2[, "Cultivation"] <- as.factor(MyWrangledData2[, "Cultivation"])
MyWrangledData2[, "Block"] <- as.factor(MyWrangledData2[, "Block"])
MyWrangledData2[, "Plot"] <- as.factor(MyWrangledData2[, "Plot"])
MyWrangledData2[, "Quadrat"] <- as.factor(MyWrangledData2[, "Quadrat"])
MyWrangledData2[, "Count"] <- as.numeric(as.integer(MyWrangledData2[, "Count"]))

str(MyWrangledData2)
head(MyWrangledData2)
dim(MyWrangledData2)

############# Exploring the data  ###############

require(tidyverse) # useful for data exploration

# convert the dataframe to a 'tibble' (= equivalent to R's traditional data.frame (i.e. tibble = a modified data frame))
tibble::as_tibble(MyWrangledData)

dplyr::glimpse(MyWrangledData) #like str(), but nicer! - to view the structure of the data
# can also use this:
utils::View(MyWrangledData)

# can subset the data:
dplyr::filter(MyWrangledData, Count>100) #like subset(), but nicer!

# can look at certain sets of data rows:
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows