#!/usr/bin/env python3

"""Python II practical: illustrating numerical integration and plotting"""
__author__ = 'Lizzie Bru eab21@ic.ac.uk'

import numpy as np
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p

# Numerical integration for solving the Lotka-Volterra model
 # define a function that returns growth rate of consumer & resource popn at any given timestep
 # (i.e. basically just writes the equations into one readable format for further analysis)_
def dCR_dt(pops, t=0):

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
co = 5
rco = np.array([ro, co])

# numerically integrate this system forward from those starting conditions:
pops, infodict = integrate.odeint(dCR_dt, rco, t, full_output = True)
# -- this function integrates within some given limits
# -- have to give it a function to integrate (in this case the 2 L-V model functions)
# -- rco = telling it where to start
# -- pops = the actual answer to the question (= the first entry of the array)
# -- infodict = 2nd entry of the array = just a dictionary of the output
pops
#--> this array has 1000 rows, each corresponding to a time
#--> in each row there's a pair of numbers: R and C for each time point
type(infodict)
infodict.keys()
infodict['message'] # it worked!

# visualize the results:
import matplotlib.pylab as p

# plot population density against time:
f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')

# plot consumer density against resource density:
f2 = p.figure()
p.plot(pops[:,0], pops[:,1], "r-")
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')

# save the figures as pdfs:
f1.savefig('../results/LV_model.pdf')
f2.savefig('../results/LV_model2.pdf')