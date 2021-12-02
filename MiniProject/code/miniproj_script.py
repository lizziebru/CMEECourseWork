#!/usr/bin/env python3

"""Miniproject data wrangling and model fitting"""
__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import pandas as pd
import numpy as np

"""
DATA WRANGLING
"""

## reading in and getting to know the data

data = pd.read_csv("../data/LogisticGrowthData.csv")

# print the column values
print("Loaded {} columns.".format(len(data.columns.values)))
print(data.columns.values)

# print the first few lines of the data
data.head()

# print the units of the response and independent variables
print(data.PopBio_units.unique()) # response variable
print(data.Time_units.unique()) # independent variable

# read in and view the metadata too
metadata = pd.read_csv("../data/LogisticGrowthMetaData.csv")
metadata


## create unique IDs to identify unique datasets

# define unique IDs based on unique combination of species, temp, medium, and citation
data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)
data['ID'].nunique() # there are 285 unique IDs
# give them numerical IDs 1-285 (much clearer than those long ID names)
d = {ni: indi for indi, ni in enumerate(set(data.ID))} # assign a number to each unique element and store this as a dictionary d
data.ID = [d[ni] for ni in data.ID] # do a list comprehension and store the actual numbers in the data.ID column
# don't want any IDs = 0 so assign those all 285:
data['ID'] = data['ID'].replace(0, 285)

## check for any problematic values

# look for any NAs
data.isnull().values.any() # no NAs - great!

# deal with negative PopBio and temp values:
# -ve PopBio values: could get rid of entire ID altogether - bc then some subsets would have too few points?
# subset the data to cases where PopBio is negative
#neg_popbio = data.loc[data["PopBio"] < 0]
# list the IDs corresponding to negative PopBio values
#neg_popbio.ID.unique()
# drop all the rows with those IDs to get rid of them entirely (can't be trusted and those negative PopBio values make up a significant proportion of the data for those IDs toodata.drop(data.index[data['ID'] == 21])
#data2 = data.drop(data.index[data['ID'] == 21])
#data3 = data2.drop(data2.index[data2['ID'] == 54])
#data4 = data3.drop(data3.index[data3['ID'] == 141])
#data5 = data4.drop(data4.index[data4['ID'] == 187])
#--> BUT: have decided not to do this - instead will just not run models on subsets that have fewer than 4 points


# INSTEAD: get rid of all of time and PopBio rows which are negative - bc can't really trust them

data.drop(data[data["Time"] < 0].index, inplace=True)
data.drop(data[data["PopBio"] < 0].index, inplace=True)

# units of PopBio aren't all the same
# --> BUT: this won't be problematic bc they're consistent within each subset (bc we subset by citation and they're consistent within each citation)


## log transform PopBio (bc popn growth is exponential of some sort)
data['log_PopBio'] = np.log(data['PopBio'])
##-> this is important for helping to properly visualize the data/model fits etc bc of the way logarithms work:


## save the modified data
data.to_csv('../data/LogisticGrowthData2.csv')







