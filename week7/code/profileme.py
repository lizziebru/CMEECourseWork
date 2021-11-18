#!/usr/bin/env python3

"""This script illustrates profiling in Python"""

__author__ = 'Lizzie Bru eab21@ic.ac.uk'

# example program:

def my_squares(iters):
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")

# best way to profile this in Pycharm: click on Run > Profile 'profileme.py'
