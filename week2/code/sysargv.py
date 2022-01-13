#!/usr/bin/env python3

"""Script to demonstrate sys.argv in Python"""
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

import sys # sys is a module
# sys.argv is just an object created by python using the sys module that contains the names of the argument variables in the current script
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))
