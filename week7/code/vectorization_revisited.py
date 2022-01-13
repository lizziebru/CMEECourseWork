#!/usr/bin/env python3

"""This script illustrates how to vectorize in Python"""

__author__ = 'Lizzie Bru (eab21@ic.ac.uk)'

import numpy as np
import matplotlib.pylab as p

# example to show the difference in runtime between a loop method and a vectorized method using numpy

# calculating a new array c in which each entry is the product of the two corresponding entries in a and b
def loop_product(a, b): # define a loop-based function to calculate this
    """Return a new array in which each entry is the product of the 2 corresponding entries in arguments a and b"""
    N = len(a)
    c = np.zeros(N)
    for i in range(N):
        c[i] = a[i] * b[i]
    return c


def vect_product(a, b): # define a vectorized function to calculate this
    """Return a new array in which each entry is the product of the 2 corresponding entries in arguments a and b, but this time in a more vectorized way"""
    return np.multiply(a, b) # multiply function from numpy = vectorized implementation of the elementwise product that we've explicitly written in the function loop_product


# compare these 2 functions on increasingly large randomly-generated 1D arrays:

import timeit

array_lengths = [1, 100, 10000, 1000000, 10000000]
t_loop = []
t_vect = []

for N in array_lengths:
    print("\nSet N=%d" % N)
    # randomly generate our 1D arrays of length N
    a = np.random.rand(N)
    b = np.random.rand(N)

    # time loop_product 3 times and save the mean execution time.
    timer = timeit.repeat('loop_product(a, b)', globals=globals().copy(), number=3)
    t_loop.append(1000 * np.mean(timer))
    print("Loop method took %d ms on average." % t_loop[-1])

    # time vect_product 3 times and save the mean execution time.
    timer = timeit.repeat('vect_product(a, b)', globals=globals().copy(), number=3)
    t_vect.append(1000 * np.mean(timer))
    print("vectorized method took %d ms on average." % t_vect[-1])

#--> vectorized method took 3ms on average vs loop method took 1372ms!!


# compare the timings on a plot:
p.figure()
p.plot(array_lengths, t_loop, label="loop method")
p.plot(array_lengths, t_vect, label="vect method")
p.xlabel("Array length")
p.ylabel("Execution time (ms)")
p.legend()
p.show()


# BUT: there are trade-offs: vectorizing increases RAM usage (because it involves storing parts of matrices rather than running each element one by one)

# if you try to vectorize a problem that's too large, you'll probably run into memory errors:
# for example if you make the same example as before even bigger:

N = 1000000000

a = np.random.rand(N)
b = np.random.rand(N)
c = vect_product(a, b)

# if no error, remove a, b, c from memory.
del a
del b
del c

#--> returns a memory error
