#!/usr/bin/env python3

"""This script illustrates profiling in Python"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

# example program:

def my_squares(iters):
    """Return list of square numbers starting from zero and of length equal to the argument of the function"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """Return the argument 'string', repeating it 'iters' number of times"""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Print the arguments, apply function 'my_squares' to first argument, apply function 'my_join' to both arguments, and return '0'"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")

# best way to profile this in Pycharm: click on Run > Profile 'profileme.py'
