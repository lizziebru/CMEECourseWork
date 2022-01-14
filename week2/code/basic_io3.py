#!/usr/bin/env python3

"""Script to demonstrate how to store files in Python"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'


#############################
# STORING OBJECTS
#############################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../data/test.txt','wb') ## note the b: accept binary files
pickle.dump(my_dictionary, f)
f.close()

## Load the data again
f = open('../data/test.txt','rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
