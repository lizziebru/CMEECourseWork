#!/usr/bin/env python3

"""This script illustrates profiling in Python - using an alternative approach to make it faster"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

# alternative approach to the same program as in profileme.py:

def my_squares(iters):
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")

# best way to profile this in Pycharm: click on Run > Profile 'profileme2.py'
##--> shows that it's faster than 'profileme.py'