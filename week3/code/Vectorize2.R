# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: Vectorize2.R
# Desc: contains the stochastic Ricker model in a form which is more vectorized than was originally provided
# Date: Oct 2021

# Runs the stochastic Ricker equation with gaussian fluctuations

# runs it with diff parameters: things fluctuate over time (carrying capacity, r (growth rate))

rm(list = ls())


# original loop provided:

stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100)
{

  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix # rows = years, columns = popns

  N[1, ] <- p0 # assigns whole first row to starting popn values

  for (pop in 1:length(p0)) { #loop through the populations

    for (yr in 2:numyears){ #for each pop, loop through the years

      N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution (at every timestep)
                                                                        # = added random fluctuation
     }
  
  }
 return(N)

}


# Now write another function called stochrickvect that vectorizes the above to
# the extent possible, with improved performance: 

# need to fill it row by row (ie. by year), working out N for all the popns in that year all together

stochrickvect <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100)
{
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix # rows = years, columns = popns
  
  N[1, ] <- p0 # assigns whole first row to starting popn values
  
  for (yr in 2:numyears) { #loop through the years - make it work it out for all the popns in one go per year (i.e. incoroporate the original first 'for' loop into the task within the loop)
    
    N[yr, (1:length(p0))] <- N[yr-1, (1:length(p0))] * exp(r * (1 - N[yr - 1, (1:length(p0))] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution (at every timestep)

  }
  
  return(N)
  
}


# print how long each method took:

print("Non-vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrick()))

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))
##--> vectorized version is much faster!
