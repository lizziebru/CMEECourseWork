#!/usr/bin/env python3

"""Script to demonstrate how to output files in Python"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'


#############################
# FILE OUTPUT
#############################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../results/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()
