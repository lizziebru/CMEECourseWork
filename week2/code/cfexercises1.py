#!/usr/bin/env python3

"""Some functions exemplifying the use of conditionals"""
#docstrings are considered part of the running code (normal comments are
#stripped). Hence, you can access your docstrings at run time.
__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

import sys

def foo_1(x):
    """Raise input to the power of 0.5."""
    return x ** 0.5

def foo_2(x, y):
    """Needs two inputs.
    Print the one which has a greater numerical value."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Rearrange the three inputs provided into ascending order if they are not already."""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x):
    """Return the factorial of the input"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """Calculate the factorial of input"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     
def foo_6(x):
    """Calculate the factorial of input in a different way"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto


## test arguments to show that these functions work:

def main(argv):
    print(foo_1(14))
    print(foo_2(5,10))
    print(foo_3(89,44,61))
    print(foo_4(124))
    print(foo_5(34))
    print(foo_6(88))
    return 0


if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)