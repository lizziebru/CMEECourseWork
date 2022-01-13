#!/usr/bin/env python3

"""Introduction to scipy"""
__author__ = 'Lizzie Bru eab21@ic.ac.uk'

# useful for more complex numerical operations

# can do linear model fitting etc like in R but in python using the scipy package

import numpy as np
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
from scipy import stats

# e.g. generate 10 samples from normal distribution:
sc.stats.norm.rvs(size = 10)

# can seed random numbers to get the same sequence
np.random.seed(1234)
sc.stats.norm.rvs(size = 10) # NB: if you run just this line a second time it doesn't come out the same as the first time (bc set.seed only applies to the next one time)

# often a more robust way is just to use the random_state argument for each specific generation of a set of random numbers
sc.stats.norm.rvs(size=5, random_state=1234)

# example of generating random integers between 1 and 10
sc.stats.randint.rvs(0, 10, size = 7)

# and doing it with random seed:
sc.stats.randint.rvs(0, 10, size = 7, random_state=1234)

sc.stats.randint.rvs(0, 10, size = 7, random_state=3445) # a different seed



# numerical integration using scipy.integrate

# e.g. calculate the area under an arbitrary curve

y = np.array([5, 20, 18, 19, 18, 7, 4]) # The y values; can also use a python list here

p.plot(y)

area = integrate.trapz(y, dx = 2)
print("area =", area)

area = integrate.trapz(y, dx = 1)
print("area =", area) # changing dx changes the spacing between points of the curve and therefore changes the area

area = integrate.trapz(y, dx = 3)
print("area =", area)


# can do the same using Simpson's rule: (slightly more computationally intensive but more accurate)
area = integrate.simps(y, dx = 2)
print("area =", area)

area = integrate.simps(y, dx = 1)
print("area =", area)

area = integrate.simps(y, dx = 3)
print("area =", area)


# Numerical integration for solving the Lotka-Volterra model
 # define a function that returns growth rate of consumer & resource popn at any given timestep
 # (i.e. basically just writes the equations into one readable format for further analysis)_
def dCR_dt(pops, t=0):
    """Return growth rate of consumer and resource population at a given timestep t"""

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return np.array([dRdt, dCdt])
type(dCR_dt)

# now assign some parameter values:
r = 1.
a = 0.1
z = 1.5
e = 0.75

# define the time vector:
t = np.linspace(0, 15, 1000) # = integrate from time point 0 to 15, using 1000 sub-divisions of time

# set the initial conditions for the two populations and convert the two into an array
ro = 10
co = 10
rco = np.array([ro, co])

# numerically integrate this system forward from those starting conditions:
pops, infodict = integrate.odeint(dCR_dt, rco, t, full_output = True)
# -- this function integrates within some given limits
# -- have to give it a function to integrate (in this case the 2 L-V model functions)
# -- rco = telling it where to start
# -- pops = the actual answer to the question (= the first entry of the array)
# -- infodict = 2nd entry of the array = just a dictionary of the output
pops
type(infodict)
infodict.keys()
infodict['message'] # it worked!

# visualize the results:

f1 = p.figure()

p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.show()# To display the figure

# save the figure as a pdf:
f1.savefig('../results/LV_model.pdf')
