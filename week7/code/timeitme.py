#!/usr/bin/env python3

"""This script illustrates quick profiling with timeit in Python"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import timeit

##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 1000000

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join

# don't use magic commands in Pycharm: instead use:

import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run." % (time.time() - start)) # could also specify an end() and use the difference between start and end

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run." % (time.time() - start))





